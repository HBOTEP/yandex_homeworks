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
                        .padding(.trailing, 12)
                } else {
                    Image(systemName: "circle")
                        .resizable()
                        .frame(width: 24, height: 24)
                        .foregroundColor(todo.importance == .important ? .red : .gray)
                        .onTapGesture {
                            onToggleComplete()
                        }
                        .padding(.trailing, 12)
                }
                    
                
                if todo.importance == .important {
                    Image("highImportance")
                        .foregroundColor(.red)
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
            }
            .padding()
            .cornerRadius(10)
        
        .swipeActions(edge: .leading) {
            Button {
                onToggleComplete()
            } label: {
                Label("", systemImage: todo.done ? "circle" : "checkmark.circle")
            }
            .tint(.green)
        }
        .swipeActions(edge: .trailing) {
            Button {
                onInfo()
            } label: {
                Label("Info", systemImage: "info.circle")
            }
            .tint(.gray)

            Button(role: .destructive) {
                onDelete()
            } label: {
                Label("Delete", systemImage: "trash")
            }
            .tint(.red)
        }
    }
}

struct TodoRowView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            TodoRowView(todo: TodoItem(text: "Купить что-то", importance: .ordinary, done: false), onToggleComplete: {}, onInfo: {}, onDelete: {})
                .previewDisplayName("Ячейка в 1 строку")
            
            TodoRowView(todo: TodoItem(text: "Купить что-то, где-то, зачем-то, но зачем не очень понятно", importance: .ordinary, done: false), onToggleComplete: {}, onInfo: {}, onDelete: {})
                .previewDisplayName("Ячейка в 2 строки")
            
            TodoRowView(todo: TodoItem(text: "Купить что-то, где-то, зачем-то, но зачем не очень понятно, но точно чтобы показать как обрезать текст в ячейке", importance: .ordinary, done: false), onToggleComplete: {}, onInfo: {}, onDelete: {})
                .previewDisplayName("Ячейка в 3 строки")
            
            TodoRowView(todo: TodoItem(text: "Купить что-то", importance: .unimportant, done: false), onToggleComplete: {}, onInfo: {}, onDelete: {})
                .previewDisplayName("Ячейка в 1 строку, низкий приоритет")
            
            TodoRowView(todo: TodoItem(text: "Купить что-то", importance: .important, done: false), onToggleComplete: {}, onInfo: {}, onDelete: {})
                .previewDisplayName("Ячейка в 1 строку, высокий приоритет")
            
            TodoRowView(todo: TodoItem(text: "Купить что-то", importance: .ordinary, done: true), onToggleComplete: {}, onInfo: {}, onDelete: {})
                .previewDisplayName("Ячейка в 1 строку, выполнена")
            
            TodoRowView(todo: TodoItem(text: "Задание", importance: .ordinary, deadline: Date(), done: false), onToggleComplete: {}, onInfo: {}, onDelete: {})
                .previewDisplayName("Ячейка в 1 строку с датой дедлайна")
        }
        .previewLayout(.sizeThatFits)
        .padding()
    }
}
