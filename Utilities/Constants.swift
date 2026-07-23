import Foundation

enum AppConstants {
    static let appName = "AI Scheduling Tasks"
    static let appVersion = "1.0.0"

    enum Timing {
        static let standardAnimationDuration: TimeInterval = 0.3
        static let defaultRefreshInterval: TimeInterval = 60

        static let defaultTaskDuration = 30
        static let minTaskDuration = 5
        static let maxTaskDuration = 480
        static let taskDurationStep = 5
    }

    enum API {
        static let timeoutInterval: TimeInterval = 30
        static let retryAttempts = 3
    }

    enum UserDefaults {
        static let workStartTimeKey = "workStartTime"
        static let workEndTimeKey = "workEndTime"
        static let notificationsEnabledKey = "notificationsEnabled"
    }
}
