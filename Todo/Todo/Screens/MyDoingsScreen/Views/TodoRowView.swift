//
//  TodoRowView.swift
//  Todo
//
//  Created by Анастасия on 29.06.2024.
//

import SwiftUI

struct TodoRowView: View {
    let todo: TodoItem
    let onToggleComplete: () -> Void
    let onInfo: () -> Void
    let onDelete: () -> Void
    
    var body: some View {
        HStack {
            if todo.done {
                Image(systemName: "checkmark.circle.fill")
                    .resizable()
                    .foregroundColor(.green)
                    .frame(width: 24, height: 24)
                    .onTapGesture {
                        onToggleComplete()
                    }
                    .padding(.trailing, 8)
            } else {
                if todo.importance == .important {
                    Image("highImportanceCircle")
                        .resizable()
                        .frame(width: 24, height: 24)
                        .foregroundColor(todo.importance == .important ? .red : .gray)
                        .onTapGesture {
                            onToggleComplete()
                        }
                        .padding(.trailing, 8)
                } else {
                    Image(systemName: "circle")
                        .resizable()
                        .frame(width: 24, height: 24)
                        .foregroundColor(todo.importance == .important ? .red : .gray)
                        .onTapGesture {
                            onToggleComplete()
                        }
                        .padding(.trailing, 8)
                }
            }
            
            if todo.importance == .important {
                Image("highImportance")
                    .resizable()
                    .frame(width: 16, height: 20)
            } else if todo.importance == .unimportant {
                Image("lowImportance")
                    .resizable()
                    .frame(width: 16, height: 20)
            }
            
            VStack(alignment: .leading) {
                Text(todo.text)
                    .lineLimit(3)
                    .font(.system(size: 16))
                    .strikethrough(todo.done, color: .gray)
                    .foregroundColor(todo.done ? .gray : .primary)
                
                if let deadline = todo.deadline {
                    HStack {
                        Image(systemName: "calendar")
                            .foregroundColor(.secondary)
                        Text(deadline, style: .date)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                }
            }
            
            Spacer()
            
            Rectangle()
                .fill(Color(hex: todo.hex))
                .frame(width: 5)
            Image(systemName: "chevron.right")
                .onTapGesture {
                    onInfo()
                }
                .foregroundColor(Color(hex: todo.hex))
        }
        .padding(.vertical, 4)
        .frame(height: 50)
        .swipeActions(edge: .leading) {
            Button {
                onToggleComplete()
            } label: {
                Label("", systemImage: todo.done ? "circle" : "checkmark.circle")
            }
            .tint(.green)
        }
        .swipeActions(edge: .trailing) {
            Button(role: .destructive) {
                onDelete()
            } label: {
                Label("", systemImage: "trash")
            }
            .tint(.red)
            
            Button {
                onInfo()
            } label: {
                Label("", systemImage: "info.circle")
            }
            .tint(.gray)
        }
    }
}
