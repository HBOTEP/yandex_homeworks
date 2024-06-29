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
                        }
                    }
                }
                Spacer()
                Toggle("", isOn: $deadlineOn)
                    .labelsHidden()
            }
            .padding()
            
            if deadlineOn && showDatePicker {
                Divider()
                DatePicker(
                    "",
                    selection: $deadline.replacingNilWith(
                        Date().addingTimeInterval(86400)
                    ),
                    in: Date()...,
                    displayedComponents: .date
                )
                    .datePickerStyle(.graphical)
                    .clipped()
                    .onChange(of: deadline) { _, _ in
                        withAnimation {
                            showDatePicker = false
                        }
                    }
            }
        }
    }
}

extension Binding where Value == Date? {
    func replacingNilWith(_ value: Date) -> Binding<Date> {
        Binding<Date>(
            get: { self.wrappedValue ?? value },
            set: { self.wrappedValue = $0 }
        )
    }
}

struct DeadlinePickerView_Preview: View {
    @State private var deadlineOn: Bool = true
    @State private var deadline: Date? = Date().addingTimeInterval(86400)
    
    var body: some View {
        DeadlinePickerView(deadlineOn: $deadlineOn, deadline: $deadline)
    }
}

#Preview {
    DeadlinePickerView_Preview()
}
