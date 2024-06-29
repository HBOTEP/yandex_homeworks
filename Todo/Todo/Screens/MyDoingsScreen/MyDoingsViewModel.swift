//
//  MyDoingsViewModel.swift
//  Todo
//
//  Created by Анастасия on 28.06.2024.
//

import Foundation

class MyDoingsViewModel: ObservableObject {
    @Published var items: [TodoItem] = []
    
    init(fileCache: FileCache = FileCache()) {
        items = []
    }


    func addItem(_ item: TodoItem) {
        items.append(item)
    }
    
    func updateItem(_ item: TodoItem) {
        guard items.firstIndex(where: { $0.id == item.id }) != nil else {
            items.removeAll(where: { $0.id == item.id })
            items.append(item)
            return
        }
        
    }
    
    func removeItem(by id: String) {
        items.removeAll(where: { $0.id == id })
    }
}
