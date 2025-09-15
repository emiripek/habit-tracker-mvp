//
//  DayKey.swift
//  habit-tracker-mvp
//
//  Created by Emirhan Ipek on 15.09.2025.
//

import Foundation

/// Helpers for converting between dates and compact yyyyMMdd integer keys.
enum DayKey {
    /// Builds a yyyyMMdd integer for the date's start-of-day in the given calendar.
    /// Uses `calendar.startOfDay(for:)` to avoid DST/timezone pitfalls.
    static func from(_ date: Date, calendar: Calendar = .current) -> Int {
        let start = calendar.startOfDay(for: date)
        let comps = calendar.dateComponents([.year, .month, .day], from: start)
        guard let y = comps.year, let m = comps.month, let d = comps.day else { return 0 }
        return y * 10_000 + m * 100 + d
    }

    /// Today's day key using the current calendar.
    static var today: Int { from(Date()) }

    /// Returns the previous day's key relative to the provided key in the given calendar.
    static func previous(_ key: Int, calendar: Calendar = .current) -> Int {
        guard let date = toDate(key, calendar: calendar),
              let prev = calendar.date(byAdding: .day, value: -1, to: date) else {
            return key
        }
        return from(prev, calendar: calendar)
    }

    /// Converts a yyyyMMdd integer key back into a `Date` at start-of-day.
    static func toDate(_ key: Int, calendar: Calendar = .current) -> Date? {
        let year = key / 10_000
        let month = (key / 100) % 100
        let day = key % 100
        var comps = DateComponents()
        comps.year = year
        comps.month = month
        comps.day = day
        return calendar.date(from: comps).map { calendar.startOfDay(for: $0) }
    }
}

