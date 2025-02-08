//
//  TaskButtonView.swift
//  TaskApp
//
//  Created by Guru King on 08/02/2025.
//
import SwiftUI

struct TaskButtonView: View {
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
