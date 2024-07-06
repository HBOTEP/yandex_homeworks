//
//  NewTodoRowView.swift
//  Todo
//
//  Created by Анастасия on 04.07.2024.
//

import SwiftUI

struct NewTodoRowView: View {
    let onCreate: () -> Void

    var body: some View {
        HStack {
            Text("Новое")
                .font(.system(size: 16))
                .foregroundColor(.secondary)
                .padding(.leading, 60)
            
            Spacer()
        }
        .padding(.vertical, 4)
        .frame(height: 50)
        .onTapGesture {
            onCreate()
        }
    }
}
