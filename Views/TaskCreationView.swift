import SwiftUI

struct TaskCreationView: View {
    @EnvironmentObject var taskViewModel: TaskListViewModel
    @Binding var isPresented: Bool

    @State private var title = ""
    @State private var description = ""
    @State private var priority: TaskPriority = .medium
    @State private var dueDate = Date()
    @State private var estimatedDuration = 30
    @State private var showingDatePicker = false

    var isValid: Bool {
        !title.trimmingCharacters(in: .whitespaces).isEmpty
    }

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Task Details")) {
                    TextField("Task Title", text: $title)
                        .textFieldStyle(.roundedBorder)

                    TextField("Description (optional)", text: $description, axis: .vertical)
                        .lineLimit(3...5)
                        .textFieldStyle(.roundedBorder)
                }

                Section(header: Text("Priority & Duration")) {
                    Picker("Priority", selection: $priority) {
                        ForEach(TaskPriority.allCases, id: \.self) { priority in
                            Label(priority.rawValue, systemImage: "flag")
                                .tag(priority)
                        }
                    }

                    HStack {
                        Text("Estimated Duration")
                        Spacer()
                        Stepper(
                            value: $estimatedDuration,
                            in: 5...480,
                            step: 5
                        ) {
                            Text("\(estimatedDuration) min")
                        }
                    }
                }

                Section(header: Text("Due Date")) {
                    Toggle("Set Due Date", isOn: $showingDatePicker)

                    if showingDatePicker {
                        DatePicker(
                            "Due Date",
                            selection: $dueDate,
                            displayedComponents: .date
                        )
                    }
                }

                Section {
                    Button(action: createTask) {
                        HStack {
                            Spacer()
                            Text("Create Task")
                                .fontWeight(.semibold)
                            Spacer()
                        }
                        .foregroundColor(.white)
                    }
                    .listRowBackground(Color.blue)
                    .disabled(!isValid)
                }
            }
            .navigationTitle("New Task")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        isPresented = false
                    }
                }
            }
        }
    }

    private func createTask() {
        let task = Task(
            title: title.trimmingCharacters(in: .whitespaces),
            description: description.isEmpty ? nil : description,
            priority: priority,
            dueDate: showingDatePicker ? dueDate : nil,
            estimatedDuration: estimatedDuration
        )

        taskViewModel.addTask(task)
        isPresented = false
    }
}

#Preview {
    TaskCreationView(isPresented: .constant(true))
        .environmentObject(TaskListViewModel())
}
