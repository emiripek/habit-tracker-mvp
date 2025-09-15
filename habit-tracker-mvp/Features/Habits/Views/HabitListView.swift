//
//  HabitListView.swift
//  habit-tracker-mvp
//
//  Created by Emirhan Ipek on 15.09.2025.
//

import SwiftUI
import SwiftData

struct HabitListView: View {
    @Environment(\.modelContext) private var context
    @Query(sort: \Habit.createdAt, order: .forward) private var habits: [Habit]
    @State private var isPresentingAdd = false
    @State private var habitToEdit: Habit? = nil
    
    var body: some View {
        NavigationStack {
            Group {
                if habits.isEmpty {
                    VStack(spacing: 8) {
                        Text("🗓️").font(.system(size: 40))
                        Text("No habits yet").font(.headline)
                        Text("Tap '+' to create your first habit")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    List {
                        ForEach(habits) { habit in
                            HabitRow(habit: habit)
                                .contentShape(Rectangle())
                                .onTapGesture {
                                    withAnimation(.spring) {
                                        _ = try? HabitStore(context: context).toggleToday(habit)
                                    }
                                }
                                .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                                    Button(role: .destructive) {
                                        withAnimation {
                                            try? HabitStore(context: context).deleteHabit(habit)
                                        }
                                    } label: {
                                        Label("Delete", systemImage: "trash")
                                    }
                                }
                                .swipeActions(edge: .leading) {
                                    Button {
                                        habitToEdit = habit
                                    } label: {
                                        Label("Edit", systemImage: "pencil")
                                    }
                                    .tint(.blue)
                                }
                        }
                        .onDelete { indexSet in
                            let store = HabitStore(context: context)
                            for index in indexSet {
                                let h = habits[index]
                                try? store.deleteHabit(h)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Habits")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    EditButton()
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        isPresentingAdd = true
                    } label: {
                        Image(systemName: "plus")
                    }
                    .accessibilityLabel("Add Habit")
                }
            }
        }
        .sheet(isPresented: $isPresentingAdd) {
            AddHabitView()
        }
        .sheet(item: $habitToEdit) { habit in
            EditHabitView(habit: habit)
        }
    }
}

// MARK: - Row + Streak visualization
private struct HabitRow: View {
    @Environment(\.modelContext) private var context
    let habit: Habit
    
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack(alignment: .firstTextBaseline) {
                Text(habit.name)
                    .font(.body)
                    .lineLimit(1)
                Spacer(minLength: 8)
                let streak = HabitStore(context: context).streak(for: habit)
                Text("\(streak)")
                    .font(.caption)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(streak > 0 ? Color.green.opacity(0.2) : Color.secondary.opacity(0.15))
                    .clipShape(Capsule())
                    .accessibilityLabel("Current streak: \(streak)")
            }
            MiniStreakView(habit: habit, days: 7)
        }
        .padding(.vertical, 4)
        .accessibilityElement(children: .combine)
    }
}

private struct MiniStreakView: View {
    let habit: Habit
    let days: Int
    var body: some View {
        let keys = lastNDaysKeys(days)
        HStack(spacing: 6) {
            ForEach(keys, id: \.self) { key in
                let done = habit.completionDayKeys.contains(key)
                RoundedRectangle(cornerRadius: 3, style: .continuous)
                    .fill(done ? Color.accentColor : Color.secondary.opacity(0.2))
                    .frame(width: 10, height: 10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 3, style: .continuous)
                            .stroke(Color.secondary.opacity(0.25), lineWidth: 0.5)
                    )
                    .accessibilityHidden(true)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private func lastNDaysKeys(_ n: Int) -> [Int] {
        guard n > 0 else { return [] }
        let todayBucket = DayBucket.today
        return (0..<(n)).reversed().map { offset in todayBucket - offset }
    }
}
