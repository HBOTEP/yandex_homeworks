//
//  CalendarViewModel.swift
//  Todo
//
//  Created by Анастасия on 05.07.2024.
//

import Foundation

protocol CalendarViewModelDelegate: AnyObject {
    func dataDidUpdate()
}

final class CalendarViewModel {
    // MARK: - Fields
    var todoItems: [(String, [TodoItem])] = []
    var dates: [String] = []
    private var items: [TodoItem] = []
    private var fileCache: FileCache
    weak var delegate: CalendarViewModelDelegate?

    // MARK: - Lifecycle
    init(fileCache: FileCache = FileCache(fileStorageStrategy: JSONFileStorageStrategy())) {
        self.fileCache = fileCache
        loadItems()
    }

    // MARK: - Methods
    func loadItems() {
        todoItems.removeAll()
        dates.removeAll()
        fileCache.loadFromFile("todoitems.json")
        items = fileCache.getTodoList()
        items.forEach { item in
            guard let deadline = item.deadline else {
                if !todoItems.contains(where: { $0.0 == "Другое" } ) {
                    todoItems.append(("Другое", [item]))
                    dates.append("Другое")
                } else {
                    if let index = todoItems.firstIndex(where: { $0.0 == "Другое" }) {
                        todoItems[index].1.append(item)
                    }
                }
                return
            }
            let formatter = DateFormatter()
            formatter.locale = Locale(identifier: "ru_RU")
            formatter.dateFormat = "dd MMMM yyyy"
            let date = formatter.string(from: deadline)
            if !todoItems.contains(where: { $0.0 == date } ) {
                todoItems.append((date, [item]))
                dates.append(date)
            } else {
                if let index = todoItems.firstIndex(where: { $0.0 == date }) {
                    todoItems[index].1.append(item)
                }
            }
        }
        todoItems = todoItems.sorted { $0.0 < $1.0 }
        dates = dates.sorted { $0 < $1 }
        delegate?.dataDidUpdate()
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

    func changeDone(_ item: TodoItem) {
        updateItem(
            TodoItem(
                id: item.id,
                text: item.text,
                importance: item.importance,
                deadline: item.deadline,
                done: !item.done,
                creationDate: item.creationDate,
                modificationDate: item.modificationDate,
                hex: item.hex
            )
        )
    }
}
