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
    @Published var deadlineOn: Bool
    @Published var isPickerShown: Bool
    @Published var selectedColor: Color
    @Published var isColorPickerShown: Bool
    @Published var todoItem: TodoItem?
    
    var myDoingsViewModel: MyDoingsViewModel
    
    // MARK: - Lifecycle
    init(todoItem: TodoItem?, mydoingsViewModel: MyDoingsViewModel) {
        self.todoItem = todoItem
        self.myDoingsViewModel = mydoingsViewModel
        self.text = todoItem?.text ?? ""
        self.importance = todoItem?.importance ?? .ordinary
        self.deadline = todoItem?.deadline ?? nil
        self.isPickerShown = false
        self.deadlineOn = todoItem?.deadline == nil ? false : true
        self.selectedColor = Color(hex: todoItem?.hex ?? "FFFFFF")
        self.isColorPickerShown = false
    }
    
    // MARK: - Methods
    func edit() {
        let modifiedTodoItem = TodoItem(
            id: todoItem?.id ?? UUID().uuidString,
            text: text,
            importance: importance,
            deadline: isPickerShown ? deadline : nil,
            done: todoItem?.done ?? false,
            creationDate: todoItem?.creationDate ?? Date(),
            modificationDate: Date(),
            hex: selectedColor.hexString()
        )
        myDoingsViewModel.updateItem(modifiedTodoItem)
    }
    
    func delete() {
        guard let id = todoItem?.id else { return }
        myDoingsViewModel.removeItem(by: id)
    }
}
