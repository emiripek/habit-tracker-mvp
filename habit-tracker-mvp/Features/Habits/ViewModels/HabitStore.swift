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
    
    /// Marks the current 24h day-bucket as completed if not already; returns true if added.
    /// Uses 24-hour buckets (UTC-based) to ensure exact 24h windows.
    func toggleToday(_ habit: Habit) throws -> Bool {
        let bucket = DayBucket.today
        if habit.completionDayKeys.contains(bucket) {
            return false
        }
        habit.completionDayKeys.insert(bucket)
        try context.save()
        return true
    }
    
    // MARK: - Queries
    
    /// Computes the current streak counting back from the current 24h bucket.
    func streak(for habit: Habit, now: Date = Date()) -> Int {
        let todayBucket = DayBucket.from(now)
        return computeStreak(keys: habit.completionDayKeys, todayBucket: todayBucket)
    }
}

// MARK: - Pure helpers (no SwiftData)

/// Computes streak using 24h bucket keys directly.
internal func computeStreak(keys: Set<Int>, todayBucket: Int) -> Int {
    var count = 0
    var cursor = todayBucket
    while keys.contains(cursor) {
        count += 1
        cursor = DayBucket.previous(cursor)
    }
    return count
}
