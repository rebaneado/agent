import Foundation
import Combine

class TaskListViewModel: NSObject, ObservableObject {
    @Published var tasks: [Task] = []
    @Published var isLoading = false
    @Published var errorMessage: String?

    private let taskService = TaskService.shared

    override init() {
        super.init()
        loadTasks()
    }

    func loadTasks() {
        isLoading = true
        do {
            tasks = try taskService.fetchAllTasks()
            isLoading = false
        } catch {
            errorMessage = "Failed to load tasks: \(error.localizedDescription)"
            isLoading = false
        }
    }

    func addTask(_ task: Task) {
        do {
            try taskService.saveTask(task)
            loadTasks()
        } catch {
            errorMessage = "Failed to add task: \(error.localizedDescription)"
        }
    }

    func updateTask(_ task: Task) {
        do {
            try taskService.updateTask(task)
            loadTasks()
        } catch {
            errorMessage = "Failed to update task: \(error.localizedDescription)"
        }
    }

    func deleteTask(_ task: Task) {
        do {
            try taskService.deleteTask(task)
            loadTasks()
        } catch {
            errorMessage = "Failed to delete task: \(error.localizedDescription)"
        }
    }

    func toggleTaskCompletion(_ task: Task) {
        var updatedTask = task
        updatedTask.isCompleted.toggle()
        updatedTask.updatedAt = Date()
        updateTask(updatedTask)
    }

    func tasksSortedByPriority() -> [Task] {
        let priorityOrder = [TaskPriority.urgent, .high, .medium, .low]
        return tasks.sorted { task1, task2 in
            let index1 = priorityOrder.firstIndex(of: task1.priority) ?? Int.max
            let index2 = priorityOrder.firstIndex(of: task2.priority) ?? Int.max
            return index1 < index2
        }
    }

    func tasksSortedByDueDate() -> [Task] {
        tasks.sorted { task1, task2 in
            guard let date1 = task1.dueDate, let date2 = task2.dueDate else {
                return task1.dueDate != nil
            }
            return date1 < date2
        }
    }

    func upcomingTasks() -> [Task] {
        let now = Date()
        return tasks.filter { task in
            guard let dueDate = task.dueDate else { return false }
            return dueDate > now && !task.isCompleted
        }.sorted { $0.dueDate ?? Date() < $1.dueDate ?? Date() }
    }
}
