//
//  NetworkExtension.swift
//  TaskApp
//
//  Created by Guru King on 08/02/2025.
//

import Foundation

protocol EndPointType {
    var url: String {get}
    var name: String {get}
}

enum NetworkServiceError: Error {
    case invalidURL
    case decodingError
    case serverError
    case invalidResponseCode(Int)
    case noInternetConnection
    case timeout
    case genericError(String)
}

extension NetworkServiceError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return NSLocalizedString("Invalid URL. Unable to proceed with the request.",
                                     comment: "Error message for invalid URL")
        case .decodingError:
            return NSLocalizedString("Failed to decode the response. Data format might be incorrect.",
                                     comment: "Error message when decoding JSON fails")
        case .serverError:
            return NSLocalizedString("Invalid server response.",
                                     comment: "Error message for unexpected server response")
        case .invalidResponseCode(let code):
            return String(format: NSLocalizedString("Received invalid response code: %d.",
                                                    comment: "Error message for invalid HTTP response codes"), code)
        case .noInternetConnection:
            return NSLocalizedString("No internet connection. Please check your network settings.",
                                     comment: "Error message when there is no internet connection")
        case .timeout:
            return NSLocalizedString("Request timed out. The server took too long to respond.",
                                     comment: "Error message when request exceeds timeout limit")
        case .genericError(let error):
            return NSLocalizedString(error, comment: "Generic error message")
        }
    }
}

extension JSONDecoder {
    static var snakeCaseConverting: JSONDecoder {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            return decoder
        }
}
