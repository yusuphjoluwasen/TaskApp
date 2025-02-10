//
//  Network.swift
//  TaskApp
//
//  Created by Guru King on 08/02/2025.
//
import Foundation
import Combine

/// **NetworkProtocol**
/// Defines the core networking functionality required for API requests.
///
/// - `call(request:)`: Executes a network request and returns a publisher.
protocol NetworkProtocol {
    func call<Response: Codable>(request: EndPointType) -> AnyPublisher<Response, Error>
}

/// **Network**
/// A concrete implementation of `NetworkProtocol` that handles API requests.
///
/// - Uses `URLSession` to perform network calls.
/// - Automatically decodes the response into a generic `Codable` model.
/// - Handles errors and retries the request once before failing.
/// - Supports dependency injection by conforming to `NetworkProtocol`.
final class Network: NetworkProtocol {

    /// **Executes a network request and returns a decoded response.**
    ///
    /// - Converts the `EndPointType` into a valid `URLRequest`.
    /// - Performs the network request asynchronously using `URLSession`.
    /// - Maps the raw response data into a `Response` object.
    /// - Handles errors such as timeouts, decoding failures, and invalid response codes.
    ///
    /// - Parameter request: An `EndPointType` representing the API endpoint.
    /// - Returns: A publisher that emits a decoded response of type `Response` or an error.
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

/// **Private Helpers**
/// Extension containing helper functions for constructing and validating network requests.
private extension Network {

    /// **Creates a URL from an `EndPointType`.**
    /// - Parameter request: The API request containing the endpoint URL.
    /// - Returns: A valid `URL` or `nil` if the URL is invalid.
    func createURL(from request: EndPointType) -> URL? {
        return URL(string: request.url)
    }

    /// **Configures a URLRequest with headers and timeout settings.**
    /// - Parameter url: The API endpoint as a `URL`.
    /// - Returns: A `URLRequest` with a default timeout.
    func configureRequest(with url: URL) -> URLRequest {
        var request = URLRequest(url: url)
        request.timeoutInterval = 10 // Sets a timeout of 10 seconds
        return request
    }

    /// **Validates an HTTP response and extracts the raw data.**
    ///
    /// - Ensures the response is an `HTTPURLResponse`.
    /// - Checks if the status code falls within the 200–299 range.
    /// - Throws an error if the response is invalid.
    ///
    /// - Parameters:
    ///   - data: The raw response data.
    ///   - response: The URL response received.
    /// - Returns: The extracted `Data` if the response is valid.
    /// - Throws: A `NetworkServiceError` if the response is invalid.
    func validateResponse(data: Data, response: URLResponse) throws -> Data {
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkServiceError.serverError
        }

        guard (200..<300).contains(httpResponse.statusCode) else {
            throw NetworkServiceError.invalidResponseCode(httpResponse.statusCode)
        }

        return data
    }

    /// **Handles and maps errors encountered during network requests.**
    ///
    /// - Detects specific `URLError` cases such as no internet connection and timeouts.
    /// - Converts decoding errors into `NetworkServiceError.decodingError`.
    /// - Returns a generic error message for any unknown issues.
    ///
    /// - Parameter error: The error encountered during the request.
    /// - Returns: A `NetworkServiceError` describing the failure reason.
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
