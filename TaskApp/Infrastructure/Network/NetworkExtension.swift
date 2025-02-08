//
//  NetworkExtension.swift
//  TaskApp
//
//  Created by Guru King on 08/02/2025.
//

import Foundation
//why i have error types and exolanation of each code

protocol EndPointType{
    var url:String {get}
}

enum NetworkServiceError: Error {
    case invalidURL
    case decodingError
    case serverError
    case invalidResponseCode(Int)
    case noInternetConnection
    case timeout
    case genericError(String)

    var localizedDescription: String {
        switch self {
        case .invalidURL:
            return "Invalid URL. Unable to proceed with the request."
        case .decodingError:
            return "Failed to decode the response. Data format might be incorrect."
        case .serverError:
            return "Invalid server response."
        case .invalidResponseCode(let code):
            return "Received invalid response code: \(code). Expected 200-299."
        case .noInternetConnection:
            return "No internet connection. Please check your network settings."
        case .timeout:
            return "Request timed out. The server took too long to respond."
        case .genericError(let error):
            return error
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
