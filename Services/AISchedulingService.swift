import Foundation

class AISchedulingService {
    static let shared = AISchedulingService()

    private let apiService = APIService.shared
    private let preferences = UserPreferences()

    func getSchedulingRecommendations(for tasks: [Task]) async throws -> [ScheduleRecommendation] {
        let taskData = tasks.map { task in
            SchedulingRequest.SchedulingTaskData(
                id: task.id,
                title: task.title,
                description: task.description,
                priority: task.priority.rawValue,
                estimatedDuration: task.estimatedDuration,
                dueDate: task.dueDate
            )
        }

        let request = SchedulingRequest(
            tasks: taskData,
            preferences: preferences,
            constraints: ScheduleConstraints()
        )

        let recommendations = try await apiService.fetchRecommendations(request: request)
        return recommendations
    }

    func analyzeTasks(_ tasks: [Task]) -> TaskAnalysis {
        let totalDuration = tasks.reduce(0) { $0 + $1.estimatedDuration }
        let urgentCount = tasks.filter { $0.priority == .urgent }.count
        let dueToday = tasks.filter { task in
            guard let dueDate = task.dueDate else { return false }
            return Calendar.current.isDateInToday(dueDate) && !task.isCompleted
        }.count

        return TaskAnalysis(
            totalTasks: tasks.count,
            totalEstimatedDuration: totalDuration,
            urgentTasksCount: urgentCount,
            tasksOverdue: calculateOverdueTasks(tasks),
            dueTodayCount: dueToday,
            completionRate: calculateCompletionRate(tasks)
        )
    }

    private func calculateOverdueTasks(_ tasks: [Task]) -> Int {
        let now = Date()
        return tasks.filter { task in
            guard let dueDate = task.dueDate else { return false }
            return dueDate < now && !task.isCompleted
        }.count
    }

    private func calculateCompletionRate(_ tasks: [Task]) -> Double {
        guard tasks.count > 0 else { return 0 }
        let completed = Double(tasks.filter { $0.isCompleted }.count)
        return (completed / Double(tasks.count)) * 100
    }
}

struct TaskAnalysis {
    let totalTasks: Int
    let totalEstimatedDuration: Int
    let urgentTasksCount: Int
    let tasksOverdue: Int
    let dueTodayCount: Int
    let completionRate: Double
}
