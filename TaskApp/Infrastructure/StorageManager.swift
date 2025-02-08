//
//  StorageManager.swift
//  TaskApp
//
//  Created by Guru King on 08/02/2025.
//
import Foundation

final class StorageManager {
    static let shared = StorageManager()

    private init() {}

    func getFetchCount() -> Int {
        return UserDefaults.standard.integer(forKey: Constants.fetchCountKey)
    }

    func getResponseCode() -> String {
        return UserDefaults.standard.string(forKey: Constants.responseCodeKey).orEmpty
    }

    func storeFetchCount(_ count: Int) {
        UserDefaults.standard.set(count, forKey: Constants.fetchCountKey)
    }

    func storeResponseCode(_ code: String) {
        UserDefaults.standard.set(code, forKey: Constants.responseCodeKey)
    }

    func storeData(fetchCount: Int, responseCode: String) {
        storeFetchCount(fetchCount)
        storeResponseCode(responseCode)
    }
}
