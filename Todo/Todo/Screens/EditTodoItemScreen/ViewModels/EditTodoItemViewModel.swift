//
//  EditTodoItemViewModel.swift
//  Todo
//
//  Created by Анастасия on 28.06.2024.
//

import SwiftUI

final class EditTodoItemViewModel: ObservableObject {
    // MARK: - Fields
    @Published var text: String
    @Published var importance: TodoItem.Importance
    @Published var deadline: Date?
    @Published var isPickerShown: Bool
    @Published var deadlineOn: Bool
    @Published var selectedColor: Color
    @Published var isColorPickerShown: Bool
    @Published var todoItem: TodoItem?

    var myDoingsViewModel: MyDoingsViewModel

    // MARK: - Lifecycle
    init(todoItem: TodoItem?, myDoingsViewModel: MyDoingsViewModel) {
        self.todoItem = todoItem
        self.myDoingsViewModel = myDoingsViewModel
        self.text = todoItem?.text ?? ""
        self.importance = todoItem?.importance ?? .ordinary
        self.deadline = todoItem?.deadline ?? nil
        self.isPickerShown = false
        self.deadlineOn = todoItem?.deadline != nil
        self.selectedColor = Color(hex: todoItem?.hex ?? "F0171")
        self.isColorPickerShown = false
    }

    // MARK: - Metods
    func save() {
        let updatedItem = TodoItem(
            id: todoItem?.id ?? UUID().uuidString,
            text: text,
            importance: importance,
            deadline: deadlineOn ? deadline : nil,
            done: todoItem?.done ?? false,
            creationDate: todoItem?.creationDate ?? Date(),
            modificationDate: Date(),
            hex: selectedColor.hexString()
        )
        myDoingsViewModel.updateItem(updatedItem)
    }

    func delete() {
        guard let id = todoItem?.id else { return }
        myDoingsViewModel.removeItem(by: id)
    }
}
