import SwiftUI

struct TaskListView: View {
    @EnvironmentObject var taskViewModel: TaskListViewModel
    @State private var showingAddTask = false
    @State private var searchText = ""

    var filteredTasks: [Task] {
        if searchText.isEmpty {
            return taskViewModel.tasks
        }
        return taskViewModel.tasks.filter { task in
            task.title.localizedCaseInsensitiveContains(searchText) ||
                (task.description?.localizedCaseInsensitiveContains(searchText) ?? false)
        }
    }

    var body: some View {
        NavigationView {
            VStack {
                SearchBar(text: $searchText)

                if taskViewModel.isLoading {
                    ProgressView()
                } else if filteredTasks.isEmpty {
                    VStack(spacing: 12) {
                        Image(systemName: "checkmark.circle")
                            .font(.system(size: 48))
                            .foregroundColor(.gray)

                        Text("No Tasks")
                            .font(.headline)

                        Text("Add a new task to get started")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                    .frame(maxHeight: .infinity, alignment: .center)
                } else {
                    List {
                        ForEach(filteredTasks) { task in
                            TaskRowView(task: task)
                                .onTapGesture {
                                    showingAddTask = true
                                }
                        }
                        .onDelete { indexSet in
                            for index in indexSet {
                                taskViewModel.deleteTask(filteredTasks[index])
                            }
                        }
                    }
                }
            }
            .navigationTitle("Tasks")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showingAddTask = true }) {
                        Image(systemName: "plus.circle.fill")
                            .font(.title2)
                    }
                }
            }
            .sheet(isPresented: $showingAddTask) {
                TaskCreationView(isPresented: $showingAddTask)
                    .environmentObject(taskViewModel)
            }
        }
    }
}

struct TaskRowView: View {
    @EnvironmentObject var taskViewModel: TaskListViewModel
    let task: Task

    var body: some View {
        HStack(spacing: 12) {
            VStack(alignment: .leading, spacing: 4) {
                Text(task.title)
                    .font(.headline)
                    .strikethrough(task.isCompleted)

                if let description = task.description {
                    Text(description)
                        .font(.caption)
                        .foregroundColor(.gray)
                        .lineLimit(1)
                }

                HStack(spacing: 8) {
                    if let dueDate = task.dueDate {
                        Label(
                            dateFormatter.string(from: dueDate),
                            systemImage: "calendar"
                        )
                        .font(.caption2)
                        .foregroundColor(.orange)
                    }

                    Label(
                        "\(task.estimatedDuration)m",
                        systemImage: "clock"
                    )
                    .font(.caption2)
                    .foregroundColor(.blue)
                }
            }

            Spacer()

            VStack(alignment: .trailing, spacing: 8) {
                ZStack {
                    Circle()
                        .fill(Color(task.priority.color).opacity(0.2))
                        .frame(width: 32, height: 32)

                    Text(task.priority.shortLabel)
                        .font(.caption2)
                        .fontWeight(.bold)
                        .foregroundColor(Color(task.priority.color))
                }

                Button(action: {
                    taskViewModel.toggleTaskCompletion(task)
                }) {
                    Image(systemName: task.isCompleted ? "checkmark.circle.fill" : "circle")
                        .foregroundColor(task.isCompleted ? .green : .gray)
                }
            }
        }
        .padding(.vertical, 8)
    }
}

struct SearchBar: View {
    @Binding var text: String

    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.gray)

            TextField("Search tasks", text: $text)
                .textFieldStyle(.roundedBorder)

            if !text.isEmpty {
                Button(action: { text = "" }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.gray)
                }
            }
        }
        .padding(.horizontal)
        .padding(.vertical, 8)
    }
}

let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .medium
    return formatter
}()

#Preview {
    TaskListView()
        .environmentObject(TaskListViewModel())
}
