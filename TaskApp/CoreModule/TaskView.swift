//
//  TaskView.swift
//  TaskApp
//
//  Created by Guru King on 07/02/2025.
//

import SwiftUI

/// TaskView: The main view that displays fetched task data.
///
/// This view shows the response code, fetch count, and an action button to fetch new data.
/// It also displays a loading indicator and an error message if applicable.
struct TaskView: View {
    /// TaskViewModel:  view model class that manages fetching tasks
    /// it also inform the view of loading and error state
    @StateObject var viewModel: TaskViewModel

    var body: some View {
        VStack(alignment: .leading) {
            /// Displays the latest response code fetched from the network.
            TaskItemView(itemLabel: Constants.responseCode, itemValue: viewModel.responseCode)

            /// Shows how many times the fetch action has been performed.
            TaskItemView(itemLabel: Constants.timesFetched, itemValue: String(viewModel.fetchCount))
                .padding(.vertical)

            /// show a progress view when loading state is true and api fetch is in operation
            /// /// shows the task button view when the loading state is false
            if viewModel.loading {
                ProgressView()
            } else {
                /// Fetch button that triggers a new task fetch when tapped.
                TaskButtonView(action: {
                    viewModel.fetchTask()
                })
            }

            /// Displays an error message if one exists.
            Text(viewModel.error)
                .foregroundColor(.red)
                .font(.footnote)
                .padding(.top)
        }
        .padding()
        /// Loads persisted stored data when the view appears.
        .onAppear {
            viewModel.loadStoredData()
        }
    }
}

#Preview {
    TaskView(viewModel: TaskViewModel(repo: TaskRepository(service: Network())))
}
