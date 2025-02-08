//
//  TaskItemView.swift
//  TaskApp
//
//  Created by Guru King on 08/02/2025.
//

import SwiftUI

struct TaskItemView: View {
    var itemLabel: String
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
