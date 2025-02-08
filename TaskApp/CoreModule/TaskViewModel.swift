//
//  TaskViewModel.swift
//  TaskApp
//
//  Created by Guru King on 08/02/2025.
//

import Foundation
import Combine

final class TaskViewModel: ObservableObject {
    @Published var fetchCount: Int = 0
    @Published var responseCode: String = ""
    @Published var error: String = ""
    @Published var loading: Bool = false

    private let repo: TaskExecuteProtocol
    private var cancellables = Set<AnyCancellable>()
    private let storage = StorageManager.shared

    init(repo: TaskExecuteProtocol) {
        self.repo = repo
    }

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
            } receiveValue: { [weak self]  res in
                guard let self = self else { return }
                self.updateData(with: res.responseCode)
                self.storeDataToDB()
            }
            .store(in: &cancellables)
    }

    /// Loads stored fetch count and last response code from Storage
    func loadStoredData() {
        fetchCount = storage.getFetchCount()
        responseCode = storage.getResponseCode()
    }

    func updateData(with newResponseCode: String?) {
        responseCode = newResponseCode.orEmpty
        incrementFetchCount()
    }

    func incrementFetchCount() {
        fetchCount += 1
    }

    private func storeDataToDB() {
        storage.storeData(fetchCount: fetchCount, responseCode: responseCode)
    }
}
