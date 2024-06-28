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
        
        var result: [String: Any] = [
            "id": id,
            "text": text,
            "done": done,
            "creationDate": formatter.string(from: creationDate)
        ]
        
        if importance != .ordinary {
            result["importance"] = importance.rawValue
        }
        
        if let deadline {
            result["deadline"] = formatter.string(from: deadline)
        }
        
        if let modificationDate {
            result["modificationDate"] = formatter.string(from: modificationDate)
        }
        
        return (try? JSONSerialization.data(withJSONObject: result)) ?? Data()
    }
    
    // MARK: - Methods
    static func parse(json: Any) -> TodoItem? {
        guard let jsonData = json as? Data,
              let jsonObject = (try? JSONSerialization.jsonObject(with: jsonData, options: [])) as? [String: Any] else {
            return nil
        }
        
        let formatter = ISO8601DateFormatter()
        formatter.timeZone = .current
        
        guard let id = jsonObject["id"] as? String,
              let text = jsonObject["text"] as? String,
              let done = jsonObject["done"] as? Bool,
              let creationDateString = jsonObject["creationDate"] as? String,
              let creationDate = formatter.date(from: creationDateString) else {
            return nil
        }
        
        let importanceString = jsonObject["importance"] as? String ?? Importance.ordinary.rawValue
        guard let importance = Importance(rawValue: importanceString) else {
            return nil
        }
        
        let deadline = (jsonObject["deadline"] as? String).flatMap(formatter.date)
        let modificationDate = (jsonObject["modificationDate"] as? String).flatMap(formatter.date)
        
        return TodoItem(
            id: id,
            text: text,
            importance: importance,
            deadline: deadline,
            done: done,
            creationDate: creationDate,
            modificationDate: modificationDate
        )
    }
}
