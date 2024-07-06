//
//  MyDoingsViewModel.swift
//  Todo
//
//  Created by Анастасия on 28.06.2024.
//

import Foundation

class MyDoingsViewModel: ObservableObject {
    // MARK: - Fields
    @Published var items: [TodoItem] = []
    var fileCache: FileCache

    // MARK: - Lifecycle
    init(fileCache: FileCache = FileCache(fileStorageStrategy: JSONFileStorageStrategy())) {
        self.fileCache = fileCache
        loadItems()
    }

    // MARK: - Methods
    func loadItems() {
        fileCache.loadFromFile("todoitems.json")
        items = fileCache.getTodoList()
    }

    func addItem(_ item: TodoItem) {
        fileCache.addTask(todoItem: item)
        fileCache.saveToFile("todoitems.json")
        loadItems()
    }

    func updateItem(_ item: TodoItem) {
        if items.firstIndex(where: { $0.id == item.id }) != nil {
            fileCache.deleteTask(id: item.id)
            fileCache.addTask(todoItem: item)
        } else {
            fileCache.addTask(todoItem: item)
        }
        fileCache.saveToFile("todoitems.json")
        loadItems()
    }

    func removeItem(by id: String) {
        fileCache.deleteTask(id: id)
        fileCache.saveToFile("todoitems.json")
        loadItems()
    }

    func removeItem(at offsets: IndexSet) {
        offsets.forEach { index in
            let item = items[index]
            fileCache.deleteTask(id: item.id)
        }
        fileCache.saveToFile("todoitems.json")
        loadItems()
    }
}
