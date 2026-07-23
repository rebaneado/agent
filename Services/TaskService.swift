import Foundation
import CoreData

class TaskService {
    static let shared = TaskService()

    private let container: NSPersistentContainer
    private let context: NSManagedObjectContext

    init() {
        container = NSPersistentContainer(name: "AISchedulingApp")
        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                fatalError("CoreData error: \(error), \(error.userInfo)")
            }
        }
        context = container.viewContext
    }

    func fetchAllTasks() throws -> [Task] {
        let request = NSFetchRequest<TaskEntity>(entityName: "TaskEntity")
        request.sortDescriptors = [NSSortDescriptor(keyPath: \TaskEntity.updatedAt, ascending: false)]

        let entities = try context.fetch(request)
        return entities.map { taskEntity in
            Task(
                id: taskEntity.id,
                title: taskEntity.title,
                description: taskEntity.description,
                priority: TaskPriority(rawValue: taskEntity.priority) ?? .medium,
                dueDate: taskEntity.dueDate,
                scheduledDate: taskEntity.scheduledDate,
                estimatedDuration: Int(taskEntity.estimatedDuration),
                isCompleted: taskEntity.isCompleted,
                createdAt: taskEntity.createdAt,
                updatedAt: taskEntity.updatedAt
            )
        }
    }

    func saveTask(_ task: Task) throws {
        let entity = NSEntityDescription.entity(forEntityName: "TaskEntity", in: context)!
        let taskEntity = NSManagedObject(entity: entity, insertInto: context) as! TaskEntity

        taskEntity.id = task.id
        taskEntity.title = task.title
        taskEntity.description = task.description
        taskEntity.priority = task.priority.rawValue
        taskEntity.dueDate = task.dueDate
        taskEntity.scheduledDate = task.scheduledDate
        taskEntity.estimatedDuration = Int32(task.estimatedDuration)
        taskEntity.isCompleted = task.isCompleted
        taskEntity.createdAt = task.createdAt
        taskEntity.updatedAt = task.updatedAt

        try context.save()
    }

    func updateTask(_ task: Task) throws {
        let request = NSFetchRequest<TaskEntity>(entityName: "TaskEntity")
        request.predicate = NSPredicate(format: "id == %@", task.id as CVarArg)

        if let existingEntity = try context.fetch(request).first {
            existingEntity.title = task.title
            existingEntity.description = task.description
            existingEntity.priority = task.priority.rawValue
            existingEntity.dueDate = task.dueDate
            existingEntity.scheduledDate = task.scheduledDate
            existingEntity.estimatedDuration = Int32(task.estimatedDuration)
            existingEntity.isCompleted = task.isCompleted
            existingEntity.updatedAt = task.updatedAt

            try context.save()
        }
    }

    func deleteTask(_ task: Task) throws {
        let request = NSFetchRequest<TaskEntity>(entityName: "TaskEntity")
        request.predicate = NSPredicate(format: "id == %@", task.id as CVarArg)

        if let entityToDelete = try context.fetch(request).first {
            context.delete(entityToDelete)
            try context.save()
        }
    }
}
