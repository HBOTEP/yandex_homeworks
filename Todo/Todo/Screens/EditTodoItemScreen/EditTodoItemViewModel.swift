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
    @Published var todoItem: TodoItem?
    
    private var fileCache: FileCache = FileCache()
    
    // MARK: - Lifecycle
    init(todoItem: TodoItem?) {
        self.text = todoItem?.text ?? ""
        self.importance = todoItem?.importance ?? .ordinary
        self.deadline = todoItem?.deadline ?? nil
        self.deadlineOn = todoItem?.deadline == nil ? false : true
        self.isPickerShown = false
        self.todoItem = todoItem
    }
    
    // MARK: - Methods
    func edit() {
        let modifiedTodoItem = TodoItem(id: todoItem?.id ?? UUID().uuidString, text: text, importance: importance, deadline: isPickerShown ? deadline : nil, done: todoItem?.done ?? false, creationDate: todoItem?.creationDate ?? Date(), modificationDate: Date())
        fileCache.deleteTask(id: modifiedTodoItem.id)
        fileCache.addTask(todoItem: modifiedTodoItem)
    }
    
    func delete() {
        guard let id = todoItem?.id else { return }
        fileCache.deleteTask(id: id)
    }
}
