//
//  DayBucket.swift
//  habit-tracker-mvp
//
//  Created by Emirhan Ipek on 15.09.2025.
//

import Foundation

/// A timezone-agnostic 24-hour day bucket helper.
/// Defines a day as an exact 86,400-second window since Unix epoch (UTC).
enum DayBucket {
    private static let secondsPerDay: TimeInterval = 86_400
    
    /// Returns the bucket index for a given date using 24h windows since 1970-01-01 00:00:00 UTC.
    static func from(_ date: Date) -> Int {
        Int(floor(date.timeIntervalSince1970 / secondsPerDay))
    }
    
    /// Current bucket index for `Date()`.
    static var today: Int { from(Date()) }
    
    /// Previous bucket index.
    static func previous(_ bucket: Int) -> Int { bucket - 1 }
    
}
