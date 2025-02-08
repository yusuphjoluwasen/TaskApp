//
//  TaskViewModel.swift
//  TaskApp
//
//  Created by Guru King on 08/02/2025.
//

import Foundation
import Combine

final class TaskViewModel:ObservableObject{
    @Published var fetchCount:Int = 0
    @Published var responseCode:String = ""
    @Published var error:String = ""
    @Published var loading:Bool = false
    
    private let repo: TaskExecuteProtocol
    private var cancellables = Set<AnyCancellable>()
    
    init(repo: TaskExecuteProtocol) {
        self.repo = repo
        loadStoredData()
    }
    
    func fetchTask(){
        loading = true
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
    
    /// Loads both fetch count and last stored response code from UserDefaults
    private func loadStoredData() {
        fetchCount = getFetchCountFromDB()
        responseCode = getResponseCodeFromDB()
    }
    
    private func updateData(with newResponseCode: String?) {
        responseCode = newResponseCode ?? ""
        incrementFetchCount()
    }
    
    private func loadFetchCount(){
        fetchCount = getFetchCountFromDB()
    }
    
    private func incrementFetchCount() {
        fetchCount += 1
    }
    
    private func getFetchCountFromDB() -> Int{
        return UserDefaults.standard.integer(forKey: Constants.fetchCountKey)
    }
    
    /// Retrieves the last stored response code from UserDefaults
    private func getResponseCodeFromDB() -> String {
        return UserDefaults.standard.string(forKey: Constants.responseCodeKey) ?? "No Response Yet"
    }
    
    
    private func storeFetchCountToDB(_ count:Int) {
        UserDefaults.standard.set(count, forKey: Constants.fetchCountKey)
    }
    
    private func storeResponseCodeToDB(_ code: String) {
        UserDefaults.standard.set(code, forKey: Constants.responseCodeKey)
    }
    
    private func storeDataToDB() {
        UserDefaults.standard.set(fetchCount, forKey: Constants.fetchCountKey)
        UserDefaults.standard.set(responseCode, forKey: Constants.responseCodeKey)
    }
}
