//
//  TodoItem.swift
//  Todo
//
//  Created by Анастасия on 15.06.2024.
//

import Foundation

struct TodoItem {
    // MARK: - Enum Importance
    enum Importance: String {
        case unimportant
        case ordinary
        case important
    }
    
    // MARK: - Fields
    let id: String
    let text: String
    let importance: Importance
    let deadline: Date?
    let done: Bool
    let creationDate: Date
    let modificationDate: Date?
    
    // MARK: - Lifecycle
    init(
        id: String = UUID().uuidString,
        text: String,
        importance: Importance = .ordinary,
        deadline: Date? = nil,
        done: Bool = false,
        creationDate: Date = Date(),
        modificationDate: Date? = nil
    ) {
        self.id = id
        self.text = text
        self.importance = importance
        self.deadline = deadline
        self.done = done
        self.creationDate = creationDate
        self.modificationDate = modificationDate
    }
}
