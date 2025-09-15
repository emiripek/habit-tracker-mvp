# Habit Tracker MVP

## 1) Overview
- Case-study MVP built with SwiftUI and SwiftData.
- Tracks daily habits with a one-completion-per-day rule and automatic streaks.
- Build/Run:
  - Requirements: Xcode 16.4+ (Swift 6), iOS 17+ SDK.
  - Open `habit-tracker-mvp.xcodeproj` and run the `habit-tracker-mvp` target on a simulator or device.
  - Data is stored locally via SwiftData; no external services required.

## 2) Architecture
- Pattern: Lightweight MVVM
  - Model: `@Model Habit` with `id`, `name`, `createdAt`, `completionDayKeys`.
  - ViewModel: `HabitStore` owns business logic and persistence commands (add, update, delete, toggle, streak).
  - Views: `HabitListView`, `AddHabitView`, `EditHabitView` (+ small subviews `HabitRow`, `MiniStreakView`).
- App setup: Container is set in `HabitTrackerApp` via `.modelContainer(for: Habit.self)`. Legacy `yyyyMMdd` keys are normalized to 24h buckets at read-time only (no persistent migration in MVP).
- Day definition and streak logic:
  - A “day” is an exact 24-hour bucket (UTC-based) defined in `DayBucket`. One completion is allowed per bucket.
  - Streaks are computed by walking consecutive 24h buckets backward from “today”. Missing any bucket resets the streak naturally.
  - Legacy support: `DayKey` (yyyyMMdd) remains as a helper to convert old data during the migration.

## 3) Use of AI Tools
- Which tools: ChatGPT (Codex CLI) was used during development.
- AI-generated parts:
  - Scaffolding for delete/edit flows in the list: swipe actions, `.onDelete`, and an `EditHabitView` sheet.
  - `HabitRow` and `MiniStreakView` for a compact 7-day streak visualization.
  - `DayBucket` helper and refactors in `HabitStore` to move streak/toggle logic to 24-hour buckets.
  - Read-time normalization for legacy `DayKey` values when computing streaks and rendering mini streaks.
  - This README draft.
- Manually guided decisions and adjustments:
  - Chose 24h bucket approach (UTC) to exactly match “one completion per 24h” requirement, keeping `DayKey` only for legacy compatibility and read-time normalization.
  - Ensured SwiftUI data flow and SwiftData usage are safe and minimal, verified `.sheet(item:)` and `@Model` identifiability.
  - Tweaked visuals and accessibility labels; ensured list actions feel native and undo-free by design for MVP.
- Limitations observed:
  - AI patches sometimes required careful integration into existing files and Xcode project structure.
  - Needed validation of SwiftData behaviors (e.g., `@Model` + `Identifiable`) and minor API correctness with Swift 6.

## 4) Challenges & Trade-offs
- 24h day definition: Using exact 86,400-second buckets (UTC) provides clarity for “one completion per day” regardless of device time zone or DST, at the cost of not aligning with local calendar midnights.
- Migration simplicity: Opted for read-time normalization (no persistent migration) to keep the MVP lean and avoid schema/versioning complexity.
- UI scope: Kept the UI minimal (list + forms + swipe actions) to focus on correctness and persistence.
- Testing: No automated tests due to case-study time constraints; logic kept small and pure functions isolated for easy future testing.

## 5) Future Improvements
- Customization: Habit color/icon, reorder, grouping.
- Reminders: Local notifications and lock-screen widgets.
- Insights: Weekly/monthly charts, heatmaps, longest streak tracking.
- Data: iCloud sync, export/import, multi-device consistency.
- UX: Haptics, empty-state tips, undo for delete, “mark previous day” flow within limits.
 - Migration: Optional one-time persistent migration to convert any legacy date keys to 24h buckets.
