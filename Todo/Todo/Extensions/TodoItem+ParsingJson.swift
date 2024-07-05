//
//  TodoItem+ParsingJson.swift
//  Todo
//
//  Created by Анастасия on 15.06.2024.
//

import Foundation

extension TodoItem {
    // MARK: - Fields
    var json: Any {
        let formatter = ISO8601DateFormatter()
        formatter.timeZone = .current
        
        var dictionary: [String: Any] = [
            "id": id,
            "text": text,
            "creationDate": formatter.string(from: creationDate),
            "done": done,
            "hex": hex,
            "category": category.rawValue
        ]
        
        if importance != .ordinary {
            dictionary["importance"] = importance.rawValue
        }
        
        if let deadline {
            dictionary["deadline"] = formatter.string(from: deadline)
        }
        
        if let modificationDate {
            dictionary["modificationDate"] = formatter.string(from: modificationDate)
        }
        
        guard let jsonData = try? JSONSerialization.data(
            withJSONObject: dictionary,
            options: []
        ),
              let jsonResult = try? JSONSerialization.jsonObject(
                with: jsonData,
                options: []
              ) else {
            return [:]
        }
        
        return jsonResult
    }
    
    // MARK: - Methods
    static func parse(json: Any) -> TodoItem? {
        let formatter = ISO8601DateFormatter()
        formatter.timeZone = .current
        
        guard let jsonData = try? JSONSerialization.data(
            withJSONObject: json,
            options: []
        ),
              let dictionary = try? JSONSerialization.jsonObject(
                with: jsonData,
                options: []
              ) as? [String: Any],
              let id = dictionary["id"] as? String,
              let text = dictionary["text"] as? String,
              let creationDateString = dictionary["creationDate"] as? String,
              let creationDate = formatter.date(
                from: creationDateString
              ) else {
            return nil
        }
        
        let importanceString = dictionary["importance"] as? String ?? Importance.ordinary.rawValue
        
        guard let importance = Importance(rawValue: importanceString) else {
            return nil
        }
        
        let deadline: Date?
        
        if let deadlineString = dictionary["deadline"] as? String {
            deadline = formatter.date(from: deadlineString)
        } else {
            deadline = nil
        }
        
        let done = dictionary["done"] as? Bool ?? false
        
        let modificationDate: Date?
        
        if let modificationDateString = dictionary["modificationDate"] as? String {
            modificationDate = formatter.date(from: modificationDateString)
        } else {
            modificationDate = nil
        }
        
        let hex = dictionary["hex"] as? String ?? "FFFFF"
        
        let categoryString = dictionary["category"] as? String ?? Category.other.rawValue
        guard let category = Category(rawValue: categoryString) else {
            return nil
        }
        
        return TodoItem(
            id: id,
            text: text,
            importance: importance,
            deadline: deadline,
            done: done,
            creationDate: creationDate,
            modificationDate: modificationDate,
            hex: hex,
            category: category
        )
    }
}
