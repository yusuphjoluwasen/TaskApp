//
//  TaskView.swift
//  TaskApp
//
//  Created by Guru King on 07/02/2025.
//

import SwiftUI

struct TaskView: View {
    @StateObject var viewModel: TaskViewModel

    var body: some View {
        VStack(alignment: .leading) {

            TaskItemView(itemLabel: Constants.responseCode, itemValue: viewModel.responseCode)

            TaskItemView(itemLabel: Constants.timesFetched, itemValue: String(viewModel.fetchCount))
                .padding(.vertical)

            if viewModel.loading {
                ProgressView()
            } else {
                TaskButtonView(action: {
                    viewModel.fetchTask()
                })
            }

            Text(viewModel.error)
                .foregroundColor(.red)
                .font(.footnote)
                .padding(.top)
        }
        .padding()
        .onAppear {
            viewModel.loadStoredData()
        }
    }
}

#Preview {
    TaskView(viewModel: TaskViewModel(repo: TaskRepository(service: Network())))
}
