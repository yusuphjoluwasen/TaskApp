//
//  TaskItemView.swift
//  TaskApp
//
//  Created by Guru King on 08/02/2025.
//

import SwiftUI

/// TaskItemView: A simple view that displays a label and its corresponding value to be used in TaskView
///
/// This view presents an item label (bold) alongside its value in a horizontal layout.

struct TaskItemView: View {
    /// a descriptive label for the item (e.g., "Response Code:")
    var itemLabel: String

    /// The value associated with the label)
    var itemValue: String

    var body: some View {
        HStack(alignment: .top) {
            Text(itemLabel)
                .bold()

            Text(itemValue)
        }
    }
}

#Preview {
    TaskItemView(itemLabel: "Item Label:", itemValue: "Item Value")
}
