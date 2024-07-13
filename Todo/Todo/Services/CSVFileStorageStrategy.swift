//
//  CSVFileStorageStrategy.swift
//  Todo
//
//  Created by Анастасия on 22.06.2024.
//

import Foundation
import CocoaLumberjackSwift

class CSVFileStorageStrategy: FileStorageStrategy {
    func save(data: [TodoItem], to filename: String) {
        guard let fileURL = getDocumentsDirectory()?.appendingPathComponent(filename) else {
            DDLogError("Documents directory not found")
            return
        }
        var csvArray: [String] = ["id,text,priority,deadline,isCompleted,creationDate,modificationDate"]
        csvArray.append(contentsOf: data.map { $0.csv })
        let csvString = csvArray.joined(separator: "\n")
        
        do {
            try csvString.write(to: fileURL, atomically: true, encoding: .utf8)
            DDLogInfo("CSV data saved to file \(filename)")
        } catch {
            DDLogError("Error occurred while saving CSV data to file \(filename)\n\(error)")
        }
    }
    
    func load(from filename: String) -> [TodoItem] {
        guard let fileURL = getDocumentsDirectory()?.appendingPathComponent(filename) else {
            DDLogError("Documents directory not found")
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
            DDLogInfo("CSV data loaded from file \(filename)")
        } catch {
            DDLogError("Error occurred while loading CSV data from file \(filename)\n\(error)")
        }
        return data
    }
    
    private func getDocumentsDirectory() -> URL? {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
    }
}
