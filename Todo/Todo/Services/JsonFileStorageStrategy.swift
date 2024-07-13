//
//  JsonFileStorageStrategy.swift
//  Todo
//
//  Created by Анастасия on 22.06.2024.
//

import Foundation
import CocoaLumberjackSwift

class JSONFileStorageStrategy: FileStorageStrategy {
    func save(data: [TodoItem], to filename: String) {
        guard let fileURL = getDocumentsDirectory()?.appendingPathComponent(filename) else {
            DDLogError("Documents directory not found")
            return
        }
        let jsonArray: [Any] = data.map { $0.json }
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: jsonArray, options: .prettyPrinted)
            try jsonData.write(to: fileURL)
            DDLogInfo("JSON data saved to file \(filename)")
        } catch {
            DDLogError("Error occurred while saving JSON data to file \(filename)\n\(error)")
        }
    }
    
    func load(from filename: String) -> [TodoItem] {
        guard let fileURL = getDocumentsDirectory()?.appendingPathComponent(filename) else {
            DDLogError("Documents directory not found")
            return []
        }
        var data: [TodoItem] = []
        
        do {
            let jsonData = try Data(contentsOf: fileURL)
            if let jsonArray = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [Any] {
                for jsonItem in jsonArray {
                    if let item = TodoItem.parse(json: jsonItem) {
                        data.append(item)
                    }
                }
            }
            DDLogInfo("JSON data loaded from file \(filename)")
        } catch {
            DDLogError("Error occurred while loading JSON data from file \(filename)\n\(error)")
        }
        return data
    }
    
    private func getDocumentsDirectory() -> URL? {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
    }
}
