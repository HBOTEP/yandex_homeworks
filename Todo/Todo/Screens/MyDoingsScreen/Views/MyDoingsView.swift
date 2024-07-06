//
//  MyDoingsView.swift
//  Todo
//
//  Created by Анастасия on 28.06.2024.
//

import SwiftUI

struct MyDoingsView: View {
    // MARK: - Fields
    @StateObject private var viewModel = MyDoingsViewModel()
    @State private var showingCreationDetail = false
    @State private var showingEditorDetail = false
    @State private var selectedTodo: TodoItem?
    @State private var showCompleted = false
    @State private var sortOption: SortOption = .byCreationDate
    @State private var showingCalendar = false
    
    var body: some View {
        NavigationStack {
            VStack {
                HStack {
                    Text(" Выполнено — \(viewModel.items.filter { $0.done }.count)")
                        .foregroundColor(.secondary)
                    Spacer()
                    Menu {
                        Section(header: Text("Скрыть/показать выполненные")) {
                            Button(action: {
                                showCompleted.toggle()
                            }) {
                                Text(showCompleted ? "Скрыть" : "Показать")
                            }
                        }
                        Section(header: Text("Сортировка")) {
                            Button(action: {
                                sortOption = .byCreationDate
                            }) {
                                Text("По добавлению")
                            }
                            Button(action: {
                                sortOption = .byImportance
                            }) {
                                Text("По важности")
                            }
                        }
                    } label: {
                        Image(systemName: "slider.horizontal.3")
                            .foregroundColor(.blue)
                            .font(.system(size: 25))
                    }
                }
                .padding(.horizontal)
                
                List {
                    ForEach(filteredAndSortedItems) { item in
                        TodoRowView(
                            todo: item,
                            onToggleComplete: {
                                let updatedItem = TodoItem(
                                    id: item.id,
                                    text: item.text,
                                    importance: item.importance,
                                    deadline: item.deadline,
                                    done: !item.done,
                                    creationDate: item.creationDate,
                                    modificationDate: Date(),
                                    hex: item.hex
                                )
                                viewModel.updateItem(updatedItem)
                            },
                            onInfo: {
                                selectedTodo = item
                                showingEditorDetail = true
                            },
                            onDelete: {
                                viewModel.removeItem(by: item.id)
                            }
                        )
                    }
                    
                    NewTodoRowView {
                        showingCreationDetail = true
                    }
                    .listRowInsets(EdgeInsets())
                }
                .listStyle(DefaultListStyle())
                .toolbar {
                    ToolbarItem(placement: .bottomBar) {
                        Button(action: {
                            showingCreationDetail = true
                        }) {
                            Image(systemName: "plus.circle.fill")
                                .font(.system(size: 40))
                                .foregroundColor(.blue)
                        }
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Text("Мои дела")
                        .font(.title)
                        .bold()
                }
                ToolbarItem(placement: .topBarTrailing) {
                    NavigationLink() {
                        CalendarViewWrapper()
                            .navigationTitle("Мои дела")
                            .toolbarRole(.editor)
                            .onDisappear() {
                                viewModel.loadItems()
                            }
                    } label: {
                        Image(systemName: "calendar")
                    }
                }
            }
        }
        .onAppear() {
            viewModel.loadItems()
        }
        .sheet(isPresented: $showingCreationDetail) {
            EditTodoItemView(
                viewModel: EditTodoItemViewModel(
                    todoItem: nil,
                    myDoingsViewModel: viewModel
                ),
                isShowed: $showingCreationDetail
            )
        }
        .sheet(isPresented: $showingEditorDetail) {
            if let selectedTodo = selectedTodo {
                EditTodoItemView(
                    viewModel: EditTodoItemViewModel(
                        todoItem: selectedTodo,
                        myDoingsViewModel: viewModel
                    ),
                    isShowed: $showingEditorDetail
                )
            }
        }
    }
    
    private var filteredAndSortedItems: [TodoItem] {
        let filteredItems = viewModel.items.filter {
            !showCompleted ? !$0.done : true
        }
        switch sortOption {
        case .byCreationDate:
            return filteredItems.sorted {
                $0.creationDate < $1.creationDate
            }
        case .byImportance:
            return filteredItems.sorted {
                $0.importance > $1.importance
            }
        }
    }
    
    // MARK: - Enum SortOption
    enum SortOption {
        case byCreationDate, byImportance
    }
}

#Preview {
    MyDoingsView()
}
