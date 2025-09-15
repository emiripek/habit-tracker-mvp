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

    var body: some View {
        NavigationStack {
            Group {
                if habits.isEmpty {
                    VStack(spacing: 8) {
                        Text("🗓️").font(.system(size: 40))
                        Text("No habits yet").font(.headline)
                        Text("Tap Add to create your first habit")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    List(habits) { habit in
                        HStack {
                            Text(habit.name)
                                .lineLimit(1)
                                .accessibilityLabel("Habit \(habit.name)")

                            Spacer(minLength: 8)

                            Text("\(HabitStore(context: context).streak(for: habit))")
                                .font(.caption)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background(.secondary.opacity(0.15))
                                .clipShape(Capsule())
                                .accessibilityLabel("Current streak")
                        }
                        .contentShape(Rectangle())
                        .onTapGesture {
                            withAnimation {
                                _ = try? HabitStore(context: context).toggleToday(habit)
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
    }
}
