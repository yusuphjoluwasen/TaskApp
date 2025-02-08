//
//  Network.swift
//  TaskApp
//
//  Created by Guru King on 08/02/2025.
//

import Foundation
import Combine

protocol NetworkProtocol{
    func call<response:Codable>(request:EndPointType) -> AnyPublisher<response, Error>
}

final class Network: NetworkProtocol {
    
    func call<Response: Codable>(request: EndPointType) -> AnyPublisher<Response, Error> {
        guard let url = URL(string: request.url) else {
            return Fail(error: NetworkServiceError.invalidURL).eraseToAnyPublisher()
        }
        
        let urlRequest = configureRequest(with: url)

        return URLSession.shared.dataTaskPublisher(for: urlRequest)
            .tryMap(validateResponse)
            .decode(type: Response.self, decoder: JSONDecoder.snakeCaseConverting)
            .mapError(handleError)
            .retry(1)
            .eraseToAnyPublisher()
    }
}

// MARK: - Private Helpers
private extension Network {
    
/// Constructs a valid URL from `EndPointType`
    func createURL(from request: EndPointType) -> URL? {
        return URL(string: request.url)
    }
    
   /// Configures `URLRequest` with required headers and timeout
    func configureRequest(with url: URL) -> URLRequest {
        var request = URLRequest(url: url)
        request.timeoutInterval = 10
        return request
    }
    
    /// Validates HTTP response and extracts data
    func validateResponse(data: Data, response: URLResponse) throws -> Data {
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkServiceError.serverError
        }
        
        guard (200..<300).contains(httpResponse.statusCode) else {
            throw NetworkServiceError.invalidResponseCode(httpResponse.statusCode)
        }
        
        return data
    }
    
    func handleError(_ error: Error) -> NetworkServiceError {
        if let urlError = error as? URLError {
            switch urlError.code {
            case .notConnectedToInternet:
                return .noInternetConnection
            case .timedOut:
                return .timeout
            default:
                return .genericError(urlError.localizedDescription)
            }
        }
        
        return error is DecodingError ? .decodingError : .genericError(error.localizedDescription)
    }
}

