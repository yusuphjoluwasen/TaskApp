//
//  TaskModel.swift
//  TaskApp
//
//  Created by Guru King on 08/02/2025.
//

/// **NextPathModel**
/// Represents the response received when fetching the next API path.
///
/// - `nextPath`: The URL string pointing to the next endpoint for retrieving a response code.
/// - This is an optional value because the API might return an error or an unexpected response.
struct NextPathModel: Codable {
    var nextPath: String?
}

/// **ResponseCodeModel**
/// Represents the response received when fetching a response code from the API.
///
/// - `path`: The API path associated with the response.
/// - `responseCode`: The unique response code returned by the server.
/// - Both properties are optional to handle cases where the API response is incomplete.
struct ResponseCodeModel: Codable {
    var path: String?
    var responseCode: String?
}
