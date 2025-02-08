//
//  TaskAppApp.swift
//  TaskApp
//
//  Created by Guru King on 07/02/2025.
//

import SwiftUI

@main
struct TaskApp: App {
    var body: some Scene {
        WindowGroup {
            TaskView(viewModel: DependencyManager().makeTaskViewModel())
        }
    }
}
