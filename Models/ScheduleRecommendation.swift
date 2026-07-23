import Foundation

struct ScheduleRecommendation: Identifiable, Codable {
    let id: UUID
    let taskId: UUID
    let taskTitle: String
    let recommendedDate: Date
    let recommendedStartTime: Date
    let recommendedEndTime: Date
    let confidenceScore: Double
    let reasoning: String
    let alternativeSlots: [TimeSlot]

    struct TimeSlot: Identifiable, Codable {
        let id: UUID
        let startTime: Date
        let endTime: Date
        let score: Double

        init(startTime: Date, endTime: Date, score: Double) {
            self.id = UUID()
            self.startTime = startTime
            self.endTime = endTime
            self.score = score
        }
    }

    init(
        taskId: UUID,
        taskTitle: String,
        recommendedDate: Date,
        recommendedStartTime: Date,
        recommendedEndTime: Date,
        confidenceScore: Double,
        reasoning: String,
        alternativeSlots: [TimeSlot] = []
    ) {
        self.id = UUID()
        self.taskId = taskId
        self.taskTitle = taskTitle
        self.recommendedDate = recommendedDate
        self.recommendedStartTime = recommendedStartTime
        self.recommendedEndTime = recommendedEndTime
        self.confidenceScore = confidenceScore
        self.reasoning = reasoning
        self.alternativeSlots = alternativeSlots
    }
}

struct SchedulingRequest: Codable {
    let tasks: [SchedulingTaskData]
    let preferences: UserPreferences
    let constraints: ScheduleConstraints

    struct SchedulingTaskData: Codable {
        let id: UUID
        let title: String
        let description: String?
        let priority: String
        let estimatedDuration: Int
        let dueDate: Date?
    }
}

struct UserPreferences: Codable {
    var workStartTime: Int = 9
    var workEndTime: Int = 17
    var preferredBreakDuration: Int = 15
    var focusBlockDuration: Int = 90
    var timezone: String = TimeZone.current.identifier
}

struct ScheduleConstraints: Codable {
    var maxTasksPerDay: Int = 5
    var minimumBreakBetweenTasks: Int = 10
    var bufferTimeBeforeDeadline: Int = 1440
    var respectWeekends: Bool = true
}
