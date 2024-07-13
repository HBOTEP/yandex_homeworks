//
//  ImportancePickerView.swift
//  Todo
//
//  Created by Анастасия on 28.06.2024.
//

import SwiftUI

struct ImportancePickerView: View {
    @Binding var importance: TodoItem.Importance
    
    var body: some View {
        HStack {
            Text("Важность")
                .foregroundColor(.primary)
            Spacer()
            Picker("", selection: $importance) {
                Image("lowImportance").tag(TodoItem.Importance.unimportant)
                Text("нет").tag(TodoItem.Importance.ordinary)
                Image("highImportance").tag(TodoItem.Importance.important)
            }
            .pickerStyle(.segmented)
            .frame(width: 150)
        }
        .padding()
    }
}
