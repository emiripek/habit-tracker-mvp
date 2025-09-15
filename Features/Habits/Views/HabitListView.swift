import SwiftUI
import SwiftData

struct HabitListView: View {
    @Query var habits: [Habit]

    var body: some View {
        NavigationStack {
            List(habits) { habit in
                Text(habit.name)
            }
            .navigationTitle("Habits")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        // TODO: Add habit action
                    } label: {
                        Image(systemName: "plus")
                    }
                    .accessibilityLabel("Add Habit")
                }
            }
        }
    }
}

