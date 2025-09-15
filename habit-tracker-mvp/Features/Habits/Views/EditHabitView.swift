//
//  EditHabitView.swift
//  habit-tracker-mvp
//
//  Created by Emirhan Ipek on 15.09.2025.
//

import SwiftUI
import SwiftData

struct EditHabitView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var context

    let habit: Habit
    @State private var name: String

    init(habit: Habit) {
        self.habit = habit
        _name = State(initialValue: habit.name)
    }

    var body: some View {
        let trimmedName = name.trimmingCharacters(in: .whitespacesAndNewlines)

        NavigationStack {
            Form {
                Section("Name") {
                    TextField("Habit name", text: $name)
                        .textInputAutocapitalization(.words)
                }
            }
            .navigationTitle("Edit Habit")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Save") {
                        let store = HabitStore(context: context)
                        if !trimmedName.isEmpty {
                            try? store.updateHabit(habit, name: trimmedName)
                            dismiss()
                        }
                    }
                    .disabled(trimmedName.isEmpty)
                }
            }
        }
    }
}

