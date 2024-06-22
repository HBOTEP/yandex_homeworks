//
//  FileStorageStrategy.swift
//  Todo
//
//  Created by Анастасия on 22.06.2024.
//

import Foundation

protocol FileStorageStrategy {
    func save(data: [TodoItem], to filename: String)
    func load(from filename: String) -> [TodoItem]
}
