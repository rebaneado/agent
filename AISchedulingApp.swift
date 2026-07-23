import SwiftUI

@main
struct AISchedulingApp: App {
    @StateObject private var taskViewModel = TaskListViewModel()
    @StateObject private var schedulingViewModel = SchedulingViewModel()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(taskViewModel)
                .environmentObject(schedulingViewModel)
        }
    }
}
