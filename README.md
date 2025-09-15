# Habit Tracker MVP

## Overview
- iOS 17+ SwiftUI app using SwiftData for persistence and daily habit tracking with streaks.
- Key features: add habits, complete once per day, automatic streak counting, local persistence.

## Architecture
- SwiftUI views: `HabitListView`, `AddHabitView`
- MVVM: `HabitStore` encapsulates business logic and SwiftData operations
- SwiftData model: `Habit`
- Date normalization: `DayKey` utility for reliable per-day integer keys (yyyyMMdd)

## Use of AI Tools
- Tools: ChatGPT/Codex assisted with boilerplate generation, scaffolding, and sample code.
- Human-written: streak algorithm design, DayKey approach, and README narrative.
- Limitations: AI suggestions can be outdated; SwiftData and Swift 6 API names were verified and corrected manually.

## Challenges & Trade-offs
- Date handling across DST, time zones, and leap days solved via `Calendar.startOfDay(for:)` and `DayKey`.
- Minimal UI to keep scope focused for MVP.
- Excluded features for now: notifications, widgets, and advanced editing flows.

## Future Improvements
- Habit editing/deletion UI
- Notifications & widgets
- Color/icon customization
- Weekly stats and charts
- iCloud sync

## How to Build/Run
- Requirements: Xcode 16+ and iOS 17+ SDK.
- Steps:
  1. Clone the repository
  2. Open `habit-tracker-mvp.xcodeproj`
  3. Run on an iOS simulator or device

## Screenshots
![screenshot](docs/screenshot1.png)

