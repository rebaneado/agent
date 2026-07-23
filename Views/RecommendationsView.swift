import SwiftUI

struct RecommendationsView: View {
    @EnvironmentObject var taskViewModel: TaskListViewModel
    @EnvironmentObject var schedulingViewModel: SchedulingViewModel
    @State private var selectedDate = Date()

    var incompleteTasks: [Task] {
        taskViewModel.tasks.filter { !$0.isCompleted }
    }

    var body: some View {
        NavigationView {
            VStack {
                DatePicker(
                    "Select Date",
                    selection: $selectedDate,
                    displayedComponents: .date
                )
                .datePickerStyle(.graphical)
                .padding()

                if schedulingViewModel.isLoadingRecommendations {
                    ProgressView()
                } else if schedulingViewModel.recommendations.isEmpty {
                    VStack(spacing: 16) {
                        Image(systemName: "sparkles")
                            .font(.system(size: 48))
                            .foregroundColor(.blue)

                        Text("Get AI Scheduling Recommendations")
                            .font(.headline)

                        Text("Let AI analyze your tasks and suggest the best schedule")
                            .font(.caption)
                            .foregroundColor(.gray)
                            .multilineTextAlignment(.center)

                        Button(action: getRecommendations) {
                            HStack {
                                Image(systemName: "wand.and.stars")
                                Text("Get Suggestions")
                            }
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                        }
                        .disabled(incompleteTasks.isEmpty)
                    }
                    .padding()
                    .frame(maxHeight: .infinity, alignment: .center)
                } else {
                    List {
                        ForEach(schedulingViewModel.recommendations) { recommendation in
                            RecommendationCard(
                                recommendation: recommendation,
                                onAccept: {
                                    schedulingViewModel.acceptRecommendation(recommendation)
                                },
                                onReject: {
                                    schedulingViewModel.rejectRecommendation(recommendation)
                                }
                            )
                        }
                    }
                }
            }
            .navigationTitle("AI Schedule")
            .alert("Error", isPresented: .constant(schedulingViewModel.errorMessage != nil)) {
                Button("OK") {
                    schedulingViewModel.errorMessage = nil
                }
            } message: {
                Text(schedulingViewModel.errorMessage ?? "")
            }
        }
    }

    private func getRecommendations() {
        schedulingViewModel.getSchedulingRecommendations(for: incompleteTasks)
    }
}

struct RecommendationCard: View {
    let recommendation: ScheduleRecommendation
    let onAccept: () -> Void
    let onReject: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            VStack(alignment: .leading, spacing: 4) {
                Text(recommendation.taskTitle)
                    .font(.headline)

                Text(recommendation.reasoning)
                    .font(.caption)
                    .foregroundColor(.gray)
                    .lineLimit(2)
            }

            HStack(spacing: 8) {
                Image(systemName: "calendar")
                    .foregroundColor(.blue)

                Text(formatDateTime(recommendation.recommendedStartTime))
                    .font(.caption)

                Spacer()

                Text("\(confidence)%")
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundColor(.green)
            }

            HStack(spacing: 8) {
                Button(action: onReject) {
                    Text("Dismiss")
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 8)
                        .background(Color(.systemGray6))
                        .cornerRadius(6)
                }

                Button(action: onAccept) {
                    Text("Schedule")
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 8)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(6)
                }
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(8)
    }

    private var confidence: Int {
        Int(recommendation.confidenceScore * 100)
    }

    private func formatDateTime(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, h:mm a"
        return formatter.string(from: date)
    }
}

#Preview {
    RecommendationsView()
        .environmentObject(TaskListViewModel())
        .environmentObject(SchedulingViewModel())
}
