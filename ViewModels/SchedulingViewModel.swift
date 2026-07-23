import Foundation
import Combine

class SchedulingViewModel: NSObject, ObservableObject {
    @Published var recommendations: [ScheduleRecommendation] = []
    @Published var isLoadingRecommendations = false
    @Published var errorMessage: String?
    @Published var selectedRecommendation: ScheduleRecommendation?

    private let aiService = AISchedulingService.shared
    private let taskService = TaskService.shared

    func getSchedulingRecommendations(for tasks: [Task]) {
        isLoadingRecommendations = true
        errorMessage = nil

        Task {
            do {
                let recommendations = try await aiService.getSchedulingRecommendations(for: tasks)
                await MainActor.run {
                    self.recommendations = recommendations
                    self.isLoadingRecommendations = false
                }
            } catch {
                await MainActor.run {
                    self.errorMessage = "Failed to get recommendations: \(error.localizedDescription)"
                    self.isLoadingRecommendations = false
                }
            }
        }
    }

    func applyRecommendation(_ recommendation: ScheduleRecommendation, to task: Task) {
        var updatedTask = task
        updatedTask.scheduledDate = recommendation.recommendedStartTime
        updatedTask.updatedAt = Date()

        do {
            try taskService.updateTask(updatedTask)
            selectedRecommendation = recommendation
        } catch {
            errorMessage = "Failed to apply recommendation: \(error.localizedDescription)"
        }
    }

    func acceptRecommendation(_ recommendation: ScheduleRecommendation) {
        var updatedTask = Task(
            id: recommendation.taskId,
            title: recommendation.taskTitle,
            scheduledDate: recommendation.recommendedStartTime,
            estimatedDuration: Int(recommendation.recommendedEndTime.timeIntervalSince(recommendation.recommendedStartTime)) / 60
        )
        updatedTask.updatedAt = Date()

        do {
            try taskService.updateTask(updatedTask)
            recommendations.removeAll { $0.id == recommendation.id }
        } catch {
            errorMessage = "Failed to accept recommendation: \(error.localizedDescription)"
        }
    }

    func rejectRecommendation(_ recommendation: ScheduleRecommendation) {
        recommendations.removeAll { $0.id == recommendation.id }
    }
}
