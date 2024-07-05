//
//  CSVFileStorageStrategy.swift
//  Todo
//
//  Created by Анастасия on 22.06.2024.
//

import Foundation

class CSVFileStorageStrategy: FileStorageStrategy {
    func save(data: [TodoItem], to filename: String) {
        guard let fileURL = getDocumentsDirectory()?.appendingPathComponent(filename) else {
            print("Failed to get documents directory")
            return
        }
        var csvArray: [String] = ["id,text,priority,deadline,isCompleted,creationDate,modificationDate"]
        csvArray.append(contentsOf: data.map { $0.csv })
        let csvString = csvArray.joined(separator: "\n")
        
        do {
            try csvString.write(to: fileURL, atomically: true, encoding: .utf8)
            print("CSV file saved to: \(fileURL.path)")
        } catch {
            print("Failed to save CSV file: \(error)")
        }
    }
    
    func load(from filename: String) -> [TodoItem] {
        guard let fileURL = getDocumentsDirectory()?.appendingPathComponent(filename) else {
            print("Failed to get documents directory")
            return []
        }
        var data: [TodoItem] = []
        
        do {
            let csvString = try String(contentsOf: fileURL, encoding: .utf8)
            let csvLines = csvString.components(separatedBy: "\n")
            guard csvLines.count > 1 else {
                return data
            }
            for csvLine in csvLines.dropFirst() {
                if let item = TodoItem.parse(csv: csvLine) {
                    data.append(item)
                }
            }
            print("CSV file loaded from: \(fileURL.path)")
        } catch {
            print("Failed to load CSV file: \(error)")
        }
        return data
    }
    
    private func getDocumentsDirectory() -> URL? {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
    }
}

