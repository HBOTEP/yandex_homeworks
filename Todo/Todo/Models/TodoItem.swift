//
//  TodoItem.swift
//  Todo
//
//  Created by Анастасия on 15.06.2024.
//

import Foundation

struct TodoItem: Identifiable {
    // MARK: - Enum Importance
    enum Importance: String, Comparable {
        case unimportant
        case ordinary
        case important
        
        static func < (lhs: Importance, rhs: Importance) -> Bool {
            switch (lhs, rhs) {
            case (.important, .ordinary), (.important, .unimportant), (.ordinary, .unimportant):
                return false
            case (.ordinary, .important), (.unimportant, .important), (.unimportant, .ordinary):
                return true
            default:
                return false
            }
        }
    }
    
    // MARK: - Fields
    let id: String
    let text: String
    let importance: Importance
    let deadline: Date?
    let done: Bool
    let creationDate: Date
    let modificationDate: Date?
    let hex: String
    let category: Category
    
    // MARK: - Lifecycle
    init(
        id: String = UUID().uuidString,
        text: String,
        importance: Importance = .ordinary,
        deadline: Date? = nil,
        done: Bool = false,
        creationDate: Date = Date(),
        modificationDate: Date? = nil,
        hex: String = "FFFFFF",
        category: Category = .other
    ) {
        self.id = id
        self.text = text
        self.importance = importance
        self.deadline = deadline
        self.done = done
        self.creationDate = creationDate
        self.modificationDate = modificationDate
        self.hex = hex
        self.category = category
    }
}
