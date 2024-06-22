//
//  JsonFileStorageStrategy.swift
//  Todo
//
//  Created by Анастасия on 22.06.2024.
//

import Foundation

class JSONFileStorageStrategy: FileStorageStrategy {
    func save(data: [TodoItem], to filename: String) {
        guard let url = FileManager.default.urls(
            for: .documentDirectory,
            in: .userDomainMask
        ).first?.appendingPathComponent(filename) else { return }
        
        let jsonArray: [Any] = data.map { $0.json }

        do {
            let jsonData = try JSONSerialization.data(withJSONObject: jsonArray, options: .prettyPrinted)
            try jsonData.write(to: url)
        } catch { }
    }

    func load(from filename: String) -> [TodoItem] {
        guard let url = FileManager.default.urls(
            for: .documentDirectory,
            in: .userDomainMask
        ).first?.appendingPathComponent(filename) else { return [] }

        do {
            let jsonData = try Data(contentsOf: url)
            if let jsonArray = try JSONSerialization.jsonObject(
                with: jsonData,
                options: []
            ) as? [Any] {
                return jsonArray.compactMap(TodoItem.parse(json:))
            }
        } catch { }
        return []
    }
}
