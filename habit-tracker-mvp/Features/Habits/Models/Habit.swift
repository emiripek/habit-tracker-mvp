//
//  Habit.swift
//  habit-tracker-mvp
//
//  Created by Emirhan Ipek on 15.09.2025.
//

import Foundation
import SwiftData

@Model
final class Habit {
    @Attribute(.unique) var id: UUID
    var name: String
    var createdAt: Date
    var completionDayKeys: Set<Int>
    
    init(name: String) {
        self.id = UUID()
        self.name = name
        self.createdAt = Date()
        self.completionDayKeys = Set<Int>()
    }
}

