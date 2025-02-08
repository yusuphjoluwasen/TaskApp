//
//  DependencyManager.swift
//  TaskApp
//
//  Created by Guru King on 08/02/2025.
//

import Foundation

/// Dependency Manager
/// creates the task view model object required by the view
///it passes the required network dependency to the repository
/// it creates the required repository for the view model
/// it aids the dependency inversion pricniple
class DependencyManager{
    func makeTaskViewModel() -> TaskViewModel{
        let network = Network()
        let repo:TaskExecuteProtocol = TaskRepository(service: network)
        return TaskViewModel(repo: repo)
    }
}
