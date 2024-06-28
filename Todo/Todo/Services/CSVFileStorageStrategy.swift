//
//  CSVFileStorageStrategy.swift
//  Todo
//
//  Created by Анастасия on 22.06.2024.
//

import Foundation

class CSVFileStorageStrategy: FileStorageStrategy {
    func save(data: [TodoItem], to filename: String) {
        guard let url = FileManager.default.urls(
            for: .documentDirectory,
            in: .userDomainMask
        ).first?.appendingPathComponent(filename) else { return }
        
        var csvArray: [String] = ["id,text,importance,deadline,done,creationDate,modificationDate"]
<<<<<<< HEAD
        csvArray.append(contentsOf: data.map(\.csv))
=======
        csvArray.append(contentsOf: data.map { $0.csv })
>>>>>>> 6b56f7f3fc43a2ed05acb6e87986352041f128bf
        
        let csvString = csvArray.joined(separator: "\n")
        
        do {
            try csvString.write(to: url, atomically: true, encoding: .utf8)
<<<<<<< HEAD
        } catch { 
            print(error)
        }
=======
        } catch { }
>>>>>>> 6b56f7f3fc43a2ed05acb6e87986352041f128bf
    }
    
    func load(from filename: String) -> [TodoItem] {
        guard let url = FileManager.default.urls(
            for: .documentDirectory,
            in: .userDomainMask
        ).first?.appendingPathComponent(filename) else { return [] }
        
        var data: [TodoItem] = []
        
        do {
            let fileContents = try String(contentsOf: url, encoding: .utf8)
            let csvLines = fileContents.components(separatedBy: "\n")
            guard csvLines.count > 1 else {
                return data
            }
            for itemCsv in csvLines.dropFirst() {
                if let item = TodoItem.parse(csv: itemCsv) {
                    data.append(item)
                }
            }
<<<<<<< HEAD
        } catch { 
            print(error)
        }
=======
        } catch { }
>>>>>>> 6b56f7f3fc43a2ed05acb6e87986352041f128bf
        return data
    }
}

