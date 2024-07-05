//
//  EditTodoItemView.swift
//  Todo
//
//  Created by Анастасия on 28.06.2024.
//

import SwiftUI

struct EditTodoItemView: View {
    // MARK: - Fields
    @ObservedObject var viewModel: EditTodoItemViewModel
    @Binding var isShowed: Bool
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    ZStack(alignment: .trailing) {
                        TextEditor(text: $viewModel.text)
                            .cornerRadius(16)
                            .frame(minHeight: 120)
                            .backgroundStyle(.blue)
                            .contentMargins(.all, 16)
                            .padding(.horizontal)
                        
                        Rectangle()
                            .fill(viewModel.selectedColor)
                            .frame(width: 5)
                            .padding(.horizontal)
                    }

                    VStack(spacing: 0) {
                        ImportancePickerView(importance: $viewModel.importance)
                        Divider()
                        CustomColorPickerView(selectedColor: $viewModel.selectedColor, showColorPicker: $viewModel.isColorPickerShown)
                        Divider()
                        DeadlinePickerView(deadlineOn: $viewModel.deadlineOn, deadline: $viewModel.deadline)
                        Divider()
                        CategoryPickerView(category: $viewModel.category)
                    }
                    .cornerRadius(16)
                    .padding(.horizontal)
                    
                    Button(role: .destructive, action: {
                        viewModel.delete()
                        isShowed = false
                    }) {
                        Text("Удалить")
                            .frame(maxWidth: .infinity)
                    }
                    .frame(height: 56)
                    .cornerRadius(16)
                    .padding(.horizontal)
                    .disabled(viewModel.todoItem?.id == nil)
                }
            }
            .background(Color.background)
            .navigationTitle("Дело")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar(content: {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Отменить") {
                        isShowed = false
                    }
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Сохранить") {
                        viewModel.save()
                        isShowed = false
                    }
                }
            })
        }
    }
}

#Preview {
    EditTodoItemView(
        viewModel: EditTodoItemViewModel(
            todoItem: TodoItem(
                text: "Сделать что-нибудь",
                importance: .important
            ),
            myDoingsViewModel: MyDoingsViewModel()
        ),
        isShowed: .constant(
            true
        )
    )
}
