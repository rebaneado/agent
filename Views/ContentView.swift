import SwiftUI

struct ContentView: View {
    @EnvironmentObject var taskViewModel: TaskListViewModel
    @State private var selectedTab = 0

    var body: some View {
        TabView(selection: $selectedTab) {
            TaskListView()
                .tabItem {
                    Label("Tasks", systemImage: "checkmark.circle")
                }
                .tag(0)

            RecommendationsView()
                .tabItem {
                    Label("Schedule", systemImage: "calendar")
                }
                .tag(1)

            DashboardView()
                .tabItem {
                    Label("Dashboard", systemImage: "chart.bar")
                }
                .tag(2)
        }
    }
}

struct DashboardView: View {
    @EnvironmentObject var taskViewModel: TaskListViewModel

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Dashboard")
                            .font(.title2)
                            .fontWeight(.bold)

                        let analysis = AISchedulingService.shared.analyzeTasks(taskViewModel.tasks)

                        HStack(spacing: 12) {
                            DashboardCard(
                                title: "Total Tasks",
                                value: "\(analysis.totalTasks)",
                                icon: "list.bullet",
                                color: .blue
                            )

                            DashboardCard(
                                title: "Urgent",
                                value: "\(analysis.urgentTasksCount)",
                                icon: "exclamationmark.circle",
                                color: .red
                            )
                        }

                        HStack(spacing: 12) {
                            DashboardCard(
                                title: "Overdue",
                                value: "\(analysis.tasksOverdue)",
                                icon: "clock.badge.xmark",
                                color: .orange
                            )

                            DashboardCard(
                                title: "Completion",
                                value: String(format: "%.0f%%", analysis.completionRate),
                                icon: "checkmark.circle",
                                color: .green
                            )
                        }
                    }
                    .padding()

                    Divider()

                    VStack(alignment: .leading, spacing: 8) {
                        Text("Today's Tasks")
                            .font(.headline)

                        if taskViewModel.tasks.filter({ Calendar.current.isDateInToday($0.dueDate ?? Date()) && !$0.isCompleted }).isEmpty {
                            Text("No tasks for today")
                                .foregroundColor(.gray)
                                .padding()
                        } else {
                            ForEach(taskViewModel.tasks.filter({ Calendar.current.isDateInToday($0.dueDate ?? Date()) && !$0.isCompleted })) { task in
                                TaskRowView(task: task)
                            }
                        }
                    }
                    .padding()
                }
            }
            .navigationTitle("Dashboard")
        }
    }
}

struct DashboardCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: icon)
                    .font(.title2)
                    .foregroundColor(color)
                Spacer()
            }

            Text(value)
                .font(.title3)
                .fontWeight(.bold)

            Text(title)
                .font(.caption)
                .foregroundColor(.gray)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(8)
    }
}

#Preview {
    ContentView()
        .environmentObject(TaskListViewModel())
        .environmentObject(SchedulingViewModel())
}
