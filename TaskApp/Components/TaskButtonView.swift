//
//  TaskButtonView.swift
//  TaskApp
//
//  Created by Guru King on 08/02/2025.
//
import SwiftUI

/// TaskButtonView:  button created for the fetch action, to be used in TaskView
/// - Calls the provided `action` when tapped.

struct TaskButtonView: View {
    /// The action to execute when the button is tapped.
    var action: () -> Void

    var body: some View {
        Button(action: action, label: {
            Text(Constants.buttonTitle)
                .font(.subheadline)
                .foregroundStyle(.text)
        })
        .frame(maxWidth: .infinity)
        .padding()
        .background(.button)
        .cornerRadius(20)
    }
}

#Preview {
    TaskButtonView(action: {})
}
