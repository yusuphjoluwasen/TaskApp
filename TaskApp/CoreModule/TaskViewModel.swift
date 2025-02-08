//
//  TaskViewModel.swift
//  TaskApp
//
//  Created by Guru King on 08/02/2025.
//

import Foundation
import Combine

/// TaskViewModel
/// The class contains logic to:
/// - Fetch tasks from the API
/// - Handle and store response codes
/// - Manage loading and error states
/// - Persist data using `StorageManager`
///
final class TaskViewModel: ObservableObject {

    /// A variable to provide functionalities of the repository.
    /// It is private so that it does not get exposed to the view.
    private let repo: TaskExecuteProtocol

    /// A set to manage cancellable instances.
    /// Used to avoid potential memory leaks when handling async operations.
    private var cancellables = Set<AnyCancellable>()

    /// Storage manager used for persisting fetch count and response code.
    private let storage = StorageManager.shared

    /// **Output Subscribers**

    /// The number of times a task has been fetched.
    @Published var fetchCount: Int = 0

    /// The latest response code received from the API.
    @Published var responseCode: String = ""

    /// Stores an error message when the fetch operation fails.
    @Published var error: String = ""

    /// A flag that indicates whether a fetch operation is in progress.
    @Published var loading: Bool = false

    /// Initializes the view model with a repository instance.
    /// - Parameter repo: The repository that executes the task fetch operations.
    init(repo: TaskExecuteProtocol) {
        self.repo = repo
    }

    /// **Fetches a new task from the repository and updates the UI state accordingly.**
    /// - Sets `loading` to true before making a request.
    /// - Clears any previous error message.
    /// - Updates `responseCode` and increments `fetchCount` on success.
    /// -   Updates error if repository returns error
    /// - Stores data in persistent storage.
    func fetchTask() {
        loading = true
        error = ""

        repo.executeTask()
            .receive(on: RunLoop.main)
            .sink { [weak self] completion in
                guard let self = self else { return }
                self.loading = false

                if case .failure(let error) = completion {
                    self.error = error.localizedDescription
                }
            } receiveValue: { [weak self] res in
                guard let self = self else { return }
                self.updateData(with: res.responseCode)
                self.storeDataToDB()
            }
            .store(in: &cancellables)
    }

    /// **Loads stored fetch count and last response code from `StorageManager`.**
    /// - Updates `fetchCount` and `responseCode` from local storage.
    func loadStoredData() {
        fetchCount = storage.getFetchCount()
        responseCode = storage.getResponseCode()
    }

    /// **Updates response code and increments fetch count.**
    /// - Parameter newResponseCode: The latest response code received from the API.
    func updateData(with newResponseCode: String?) {
        responseCode = newResponseCode.orEmpty
        incrementFetchCount()
    }

    /// **Increments the fetch count after a successful task fetch.**
    func incrementFetchCount() {
        fetchCount += 1
    }

    /// **Saves the updated fetch count and response code to persistent storage.**
    private func storeDataToDB() {
        storage.storeData(fetchCount: fetchCount, responseCode: responseCode)
    }
}
