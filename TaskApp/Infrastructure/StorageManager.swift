//
//  StorageManager.swift
//  TaskApp
//
//  Created by Guru King on 08/02/2025.
//
import Foundation

/// **StorageManager**
/// A singleton class responsible for storing and retrieving app data using `UserDefaults`.
///
/// - Stores the fetch count and response code for persistence.
/// - Ensures data is retained across app restarts.
/// - Uses a singleton pattern to maintain a single instance  throughout the app.
final class StorageManager {

    /// **Shared Instance**
    /// A singleton instance of `StorageManager` that ensures only one instance is used throughout the app.
    static let shared = StorageManager()

    /// **Private Initializer**
    /// Prevents direct instantiation to enforce the singleton pattern.
    private init() {}

    /// **Retrieves the stored fetch count.**
    /// - Returns: The number of times a task has been fetched, defaulting to `0` if not found.
    func getFetchCount() -> Int {
        return UserDefaults.standard.integer(forKey: Constants.fetchCountKey)
    }

    /// **Retrieves the last stored response code.**
    /// - Returns: A string representing the most recent response code. Defaults to an empty string if not found.
    func getResponseCode() -> String {
        return UserDefaults.standard.string(forKey: Constants.responseCodeKey).orEmpty
    }

    /// **Stores the fetch count in `UserDefaults`.**
    /// - Parameter count: The number of times a task has been fetched.
    func storeFetchCount(_ count: Int) {
        UserDefaults.standard.set(count, forKey: Constants.fetchCountKey)
    }

    /// **Stores the last fetched response code in `UserDefaults`.**
    /// - Parameter code: The latest response code received from the API.
    func storeResponseCode(_ code: String) {
        UserDefaults.standard.set(code, forKey: Constants.responseCodeKey)
    }

    /// **Stores both fetch count and response code in `UserDefaults`.**
    /// - Parameters:
    ///   - fetchCount: The number of times a task has been fetched.
    ///   - responseCode: The latest response code received.
    func storeData(fetchCount: Int, responseCode: String) {
        storeFetchCount(fetchCount)
        storeResponseCode(responseCode)
    }
}
