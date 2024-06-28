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
<<<<<<< HEAD
        case unimportant
        case ordinary
        case important
=======
        case unimportant = "unimportant"
        case ordinary = "ordinary"
        case important = "important"
>>>>>>> 6b56f7f3fc43a2ed05acb6e87986352041f128bf
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
