import Foundation
import CoreData

@objc(TaskEntity)
public class TaskEntity: NSManagedObject {
    @NSManaged public var id: UUID
    @NSManaged public var title: String
    @NSManaged public var description: String?
    @NSManaged public var priority: String
    @NSManaged public var dueDate: Date?
    @NSManaged public var scheduledDate: Date?
    @NSManaged public var estimatedDuration: Int32
    @NSManaged public var isCompleted: Bool
    @NSManaged public var createdAt: Date
    @NSManaged public var updatedAt: Date
}

struct Task: Identifiable, Codable {
    let id: UUID
    var title: String
    var description: String?
    var priority: TaskPriority
    var dueDate: Date?
    var scheduledDate: Date?
    var estimatedDuration: Int
    var isCompleted: Bool
    var createdAt: Date
    var updatedAt: Date

    init(
        id: UUID = UUID(),
        title: String,
        description: String? = nil,
        priority: TaskPriority = .medium,
        dueDate: Date? = nil,
        scheduledDate: Date? = nil,
        estimatedDuration: Int = 30,
        isCompleted: Bool = false,
        createdAt: Date = Date(),
        updatedAt: Date = Date()
    ) {
        self.id = id
        self.title = title
        self.description = description
        self.priority = priority
        self.dueDate = dueDate
        self.scheduledDate = scheduledDate
        self.estimatedDuration = estimatedDuration
        self.isCompleted = isCompleted
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}

enum TaskPriority: String, CaseIterable, Codable {
    case low = "Low"
    case medium = "Medium"
    case high = "High"
    case urgent = "Urgent"

    var color: String {
        switch self {
        case .low: return "green"
        case .medium: return "blue"
        case .high: return "orange"
        case .urgent: return "red"
        }
    }

    var shortLabel: String {
        switch self {
        case .low: return "L"
        case .medium: return "M"
        case .high: return "H"
        case .urgent: return "!"
        }
    }
}
