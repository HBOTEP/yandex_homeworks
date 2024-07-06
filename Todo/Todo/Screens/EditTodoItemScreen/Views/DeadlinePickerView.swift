//
//  DeadlinePickerView.swift
//  Todo
//
//  Created by Анастасия on 28.06.2024.
//

import SwiftUI

struct DeadlinePickerView: View {
    @Binding var deadlineOn: Bool
    @Binding var deadline: Date?
    @State private var showDatePicker: Bool = false
    
    var body: some View {
        VStack {
            HStack {
                VStack(alignment: .leading) {
                    Text("Сделать до")
                        .foregroundColor(.primary)
                    if deadlineOn {
                        Button(action: {
                            withAnimation {
                                showDatePicker.toggle()
                            }
                        }) {
                            Text(deadline ?? Date().addingTimeInterval(86400), style: .date)
                                .foregroundColor(.blue)
                                .font(.system(size: 13))
                        }
                    }
                }
                
                Spacer()
                Toggle("", isOn: $deadlineOn)
                    .labelsHidden()
                    .onChange(of: deadlineOn) { _, value in
                        withAnimation {
                            if value {
                                if deadline == nil {
                                    deadline = Calendar.current.date(byAdding: .day, value: 1, to: Date())
                                }
                            } else {
                                showDatePicker = false
                            }
                        }
                    }
                
            }
            .padding()
            
            if showDatePicker && deadlineOn {
                Divider()
                    .transition(.opacity)
                DatePicker("Выберите дату", selection: Binding($deadline, replacingNilWith: Date()), displayedComponents: .date)
                    .datePickerStyle(GraphicalDatePickerStyle())
                    .padding()
                    .transition(.move(edge: .top).combined(with: .opacity))
            }
        }
        .animation(.default, value: showDatePicker)
        .environment(\.locale, .current)
    }
}

extension Binding {
    init(_ source: Binding<Value?>, replacingNilWith defaultValue: Value) {
        self.init(
            get: { source.wrappedValue ?? defaultValue },
            set: { newValue in source.wrappedValue = newValue }
        )
    }
}

#Preview {
    DeadlinePickerView(deadlineOn: .constant(true), deadline: .constant(nil))
}
