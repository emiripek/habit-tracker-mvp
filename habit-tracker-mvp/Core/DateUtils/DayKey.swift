//
//  DayKey.swift
//  habit-tracker-mvp
//
//  Created by Emirhan Ipek on 15.09.2025.
//

import Foundation

/// Helpers for converting between dates and compact yyyyMMdd integer keys.
enum DayKey {
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
