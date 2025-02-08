//
//  MockNetwork.swift
//  TaskApp
//
//  Created by Guru King on 08/02/2025.
//

import Foundation
import Combine

final class MockNetwork: NetworkProtocol {
    /// Calls the endpoint for requests without payload
    /// - Parameter request: The endpoint type
    /// - Returns: A publisher that sends the decoded response or an error.
    func call<Response:Codable>(request:EndPointType) -> AnyPublisher<Response, Error>{
        return call(with: request)
    }

    /// Fetches data from the specified resource in the main bundle and decodes it into the specified response type.
    /// - Parameter request: The endpoint type.
    /// - Returns: A publisher that sends the decoded response or an error.
    private func call<Response:Codable>(with request:EndPointType) -> AnyPublisher<Response, Error> {
        let url = request.name
        
        /// Attempts to read the data from the specified resource in the main bundle.
        /// - Returns: A publisher that sends the data or an error.
        func readFile() -> AnyPublisher<Data, Error> {
            guard let _ = Bundle.main.url(forResource: url, withExtension: "json") else{
                return Fail(error: NetworkServiceError.invalidURL).eraseToAnyPublisher()
            }

            return Bundle.main.url(forResource: url, withExtension: "json")
                .publisher
                .tryMap{ string in
                    guard let data = try? Data(contentsOf: string) else {
                        fatalError("Failed to load \(url) from bundle.")
                    }
                    return data
                }
                .mapError { error in
                    return error
                }
                .eraseToAnyPublisher()
        }

        return readFile()
            .decode(type: Response.self, decoder: JSONDecoder.snakeCaseConverting)
            .mapError { error in
                return error
            }
            .eraseToAnyPublisher()
    }
}

/// A network protocol implementation that always fails with a generic error.
class MockNetworkFailure: NetworkProtocol {
    /// Calls the endpoint for requests without payload.
    /// - Parameter request: The endpoint type.
    /// - Returns: A publisher that fails with a generic error.
    func call<Response>(request: EndPointType) -> AnyPublisher<Response, Error>{
        return Fail(error: NetworkServiceError.genericError("should fail")).eraseToAnyPublisher()
    }
}

enum MockTaskApi{
    case nonexistent
}

extension MockTaskApi:EndPointType{
    var name: String {
        switch self {
        case .nonexistent:
            return "non existent"
        }
    }
    
    var url: String {
        switch self {
        case .nonexistent:
            return "non existent"
        }
    }
}
