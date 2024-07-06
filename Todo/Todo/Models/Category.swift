//
//  Category.swift
//  Todo
//
//  Created by Анастасия on 06.07.2024.
//

import SwiftUI

enum Category: String, CaseIterable {
    case work = "Работа"
    case study = "Учеба"
    case hobby = "Хобби"
    case other = "Другое"

    var color: Color {
        switch self {
        case .work:
            return .red
        case .study:
            return .blue
        case .hobby:
            return .green
        case .other:
            return .clear
        }
    }
    
    var uiColor: UIColor {
        switch self {
        case .work:
            return .red
        case .study:
            return .blue
        case .hobby:
            return .green
        case .other:
            return .clear
        }
    }
}
