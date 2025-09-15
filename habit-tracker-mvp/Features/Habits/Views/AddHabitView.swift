//
//  AddHabitView.swift
//  habit-tracker-mvp
//
//  Created by Emirhan Ipek on 15.09.2025.
//

import SwiftUI
import SwiftData

struct AddHabitView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var context
    @State private var name: String = ""
    
    var body: some View {
        let trimmedName = name.trimmingCharacters(in: .whitespacesAndNewlines)
        
        NavigationStack {
            Form {
                Section {
                    TextField("Habit name", text: $name)
                }
            }
            .navigationTitle("New Habit")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") { dismiss() }
                        .accessibilityLabel("Cancel")
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Save") {
                        let store = HabitStore(context: context)
                        if !trimmedName.isEmpty {
                            try? store.addHabit(trimmedName)
                            dismiss()
                        }
                    }
                    .disabled(trimmedName.isEmpty)
                    .accessibilityLabel("Save Habit")
                }
            }
        }
    }
}
