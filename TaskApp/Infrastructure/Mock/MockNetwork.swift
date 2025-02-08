import Foundation
import Combine

/// **MockNetwork**
/// A mock implementation of `NetworkProtocol` for testing purposes.
///
/// - Used to simulate API responses without making real network calls.
/// - Reads JSON files from the app bundle to return predefined responses.
/// - Supports testing of different scenarios such as valid responses and decoding failures.
final class MockNetwork: NetworkProtocol {

    /// **Simulates a network call without a payload.**
    ///
    /// - Parameter request: The `EndPointType` representing the API request.
    /// - Returns: A publisher that emits a decoded response or an error.
    func call<Response: Codable>(request: EndPointType) -> AnyPublisher<Response, Error> {
        return call(with: request)
    }

    /// **Reads a local JSON file and decodes it into the specified response type.**
    ///
    /// - Parameter request: The `EndPointType` representing the API request.
    /// - Returns: A publisher that emits a decoded response or an error.
    private func call<Response: Codable>(with request: EndPointType) -> AnyPublisher<Response, Error> {
        let url = request.name

        /// **Attempts to read a JSON file from the main bundle.**
        /// - Returns: A publisher that emits the file's data or an error.
        func readFile() -> AnyPublisher<Data, Error> {
            guard let fileUrl = Bundle.main.url(forResource: url, withExtension: "json") else {
                return Fail(error: NetworkServiceError.invalidURL).eraseToAnyPublisher()
            }

            return Just(fileUrl)
                .setFailureType(to: Error.self)
                .tryMap { string in
                    guard let data = try? Data(contentsOf: string) else {
                        fatalError("Failed to load \(url) from bundle.")
                    }
                    return data
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

/// **MockNetworkFailure**
/// A mock implementation of `NetworkProtocol` that always returns an error.
///
/// - Used for testing failure scenarios.
/// - Helps validate how the app handles API failures.
class MockNetworkFailure: NetworkProtocol {

    /// **Simulates a network call that always fails.**
    /// - Parameter request: The `EndPointType` representing the API request.
    /// - Returns: A publisher that immediately fails with a generic error.
    func call<Response>(request: EndPointType) -> AnyPublisher<Response, Error> {
        return Fail(error: NetworkServiceError.genericError("should fail")).eraseToAnyPublisher()
    }
}

/// **MockTaskApi**
/// A mock endpoint enumeration used for testing.
///
/// - Allows testing different scenarios such as missing resources.
enum MockTaskApi {
    case nonexistent
}

extension MockTaskApi: EndPointType {

    /// **Returns the name of the mock API endpoint.**
    /// - Used for locating test JSON files not in the app bundle.
    var name: String {
        switch self {
        case .nonexistent:
            return "non existent"
        }
    }

    /// **Returns the URL for the mock API endpoint.**
    /// - Typically not used in mock implementations but required for protocol conformance.
    var url: String {
        switch self {
        case .nonexistent:
            return "non existent"
        }
    }
}
