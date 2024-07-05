//
//  JsonFileStorageStrategy.swift
//  Todo
//
//  Created by Анастасия on 22.06.2024.
//

import Foundation

class JSONFileStorageStrategy: FileStorageStrategy {
    func save(data: [TodoItem], to filename: String) {
        guard let fileURL = getDocumentsDirectory()?.appendingPathComponent(filename) else {
            print("Failed to get documents directory")
            return
        }
        let jsonArray: [Any] = data.map { $0.json }
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: jsonArray, options: .prettyPrinted)
            try jsonData.write(to: fileURL)
            print("JSON file saved to: \(fileURL.path)")
        } catch {
            print("Failed to save JSON file: \(error)")
        }
    }
    
    func load(from filename: String) -> [TodoItem] {
        guard let fileURL = getDocumentsDirectory()?.appendingPathComponent(filename) else {
            print("Failed to get documents directory")
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
            print("JSON file loaded from: \(fileURL.path)")
        } catch {
            print("Failed to load JSON file: \(error)")
        }
        return data
    }
    
    private func getDocumentsDirectory() -> URL? {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
    }
}
