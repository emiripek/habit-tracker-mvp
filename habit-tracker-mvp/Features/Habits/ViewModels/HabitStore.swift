//
//  HabitStore.swift
//  habit-tracker-mvp
//
//  Created by Emirhan Ipek on 15.09.2025.
//

import Foundation
import SwiftData

// MARK: - Errors
enum ValidationError: LocalizedError {
    case emptyName

    var errorDescription: String? {
        switch self {
        case .emptyName:
            return "Habit name cannot be empty."
        }
    }
}

// MARK: - Store
@MainActor
final class HabitStore: ObservableObject {
    private let context: ModelContext

    init(context: ModelContext) {
        self.context = context
    }

    // MARK: - Commands

    /// Creates a new Habit with the given name and persists it.
    func addHabit(_ name: String) throws {
        let trimmed = name.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { throw ValidationError.emptyName }

        let habit = Habit(name: trimmed)
        context.insert(habit)
        try context.save()
    }

    /// Deletes a Habit and persists the change.
    func deleteHabit(_ habit: Habit) throws {
        context.delete(habit)
        try context.save()
    }

    /// Updates a habit's name after validation and persists it.
    func updateHabit(_ habit: Habit, name: String) throws {
        let trimmed = name.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { throw ValidationError.emptyName }
        habit.name = trimmed
        try context.save()
    }

    /// Marks today as completed if not already; returns true if added.
    func toggleToday(_ habit: Habit, calendar: Calendar = .current) throws -> Bool {
        let key = DayKey.from(Date(), calendar: calendar)
        if habit.completionDayKeys.contains(key) {
            return false
        }
        habit.completionDayKeys.insert(key)
        try context.save()
        return true
    }

    // MARK: - Queries

    /// Computes the current streak counting back from today.
    func streak(for habit: Habit, today: Date = Date(), calendar: Calendar = .current) -> Int {
        let todayKey = DayKey.from(today, calendar: calendar)
        return computeStreak(keys: habit.completionDayKeys, todayKey: todayKey, calendar: calendar)
    }
}

// MARK: - Pure helper (no SwiftData)
internal func computeStreak(keys: Set<Int>, todayKey: Int, calendar: Calendar = .current) -> Int {
    var count = 0
    var cursor = todayKey
    while keys.contains(cursor) {
        count += 1
        cursor = DayKey.previous(cursor, calendar: calendar)
    }
    return count
}
