//
//  FileCache.swift
//  Todo
//
//  Created by Анастасия on 15.06.2024.
//

final class FileCache {
    // MARK: - Fields
    private var todoList: [TodoItem]
    private let fileStorageStrategy: FileStorageStrategy
    
    // MARK: - Lifecycle
    init(
        todoList: [TodoItem] = [],
        fileStorageStrategy: FileStorageStrategy = JSONFileStorageStrategy()
    ) {
        self.todoList = todoList
        self.fileStorageStrategy = fileStorageStrategy
    }
    
    // MARK: - Methods
    public func getTodoList() -> [TodoItem] {
        return todoList
    }
    
    public func addTask(todoItem: TodoItem) {
        if (!todoList.contains(where: { $0.id == todoItem.id } )) {
            todoList.append(todoItem)
        }
    }
    
    public func deleteTask(id: String) {
        todoList.removeAll(where: { $0.id == id } )
    }
    
    public func saveToFile(_ filename: String) {
        fileStorageStrategy.save(data: todoList, to: filename)
    }
    
    public func loadFromFile(_ filename: String) {
        todoList = fileStorageStrategy.load(from: filename)
    }
}
