//
//  TodoItem+ParsingCSV.swift
//  Todo
//
//  Created by Анастасия on 15.06.2024.
//

import Foundation

extension TodoItem {
    // MARK: - Fields
    var csv: String {
        let formatter = ISO8601DateFormatter()
        formatter.timeZone = .current
        
        func escape(_ text: String) -> String {
            if text.contains(",") || text.contains("\"") || text.contains("\n") {
                return "\"\(text.replacingOccurrences(of: "\"", with: "\"\""))\""
            } else {
                return text
            }
        }
        
        var components: [String] = [
            id,
            escape(text),
            done.description,
            formatter.string(from: creationDate)
        ]
        
        if importance != .ordinary {
            components.insert(importance.rawValue, at: 2)
        } else {
            components.insert("", at: 2)
        }
        
        if let deadline = deadline {
            components.insert(formatter.string(from: deadline), at: 3)
        } else {
            components.insert("", at: 3)
        }
        
        if let modificationDate = modificationDate {
            components.append(formatter.string(from: modificationDate))
        } else {
            components.append("")
        }
        
        return components.joined(separator: ",")
    }
    
    // MARK: - Methods
    static func parse(csv: String) -> TodoItem? {
        let formatter = ISO8601DateFormatter()
        formatter.timeZone = .current
        
        func unescape(_ text: String) -> String {
            if text.hasPrefix("\"") && text.hasSuffix("\"") {
                let startIndex = text.index(after: text.startIndex)
                let endIndex = text.index(before: text.endIndex)
                return String(text[startIndex..<endIndex]).replacingOccurrences(of: "\"\"", with: "\"")
            } else {
                return text
            }
        }
        
        let pattern = "(?<=^|,)(\"(?:[^\"]|\"\")*\"|[^,]*)"
        let regex = try! NSRegularExpression(pattern: pattern, options: [])
        let matches = regex.matches(in: csv, options: [], range: NSRange(csv.startIndex..., in: csv))
        
        let components = matches.map { match -> String in
            let range = Range(match.range, in: csv)!
            return String(csv[range])
        }.map(unescape)
        
        guard components.count >= 6 else { return nil }
        
        let id = components[0]
        let text = components[1]
        let importanceString = components[2]
        let importance = importanceString.isEmpty ? .ordinary : Importance(rawValue: importanceString) ?? .ordinary
        
        let deadlineString = components[3]
        let deadline = deadlineString.isEmpty ? nil : formatter.date(from: deadlineString)
        
        let done = (components[4] as NSString).boolValue
        
        let creationDateString = components[5]
        guard let creationDate = formatter.date(from: creationDateString) else {
            return nil
        }
        
        let modificationDateString = components.count > 6 ? components[6] : ""
        let modificationDate = modificationDateString.isEmpty ? nil : formatter.date(from: modificationDateString)
        
        return TodoItem(id: id, text: text, importance: importance, deadline: deadline, done: done, creationDate: creationDate, modificationDate: modificationDate)
    }
}
