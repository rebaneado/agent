# AI Scheduling Tasks - iOS App

A modern iOS application that leverages AI to intelligently schedule and manage your tasks. Built with SwiftUI and designed for seamless task management with smart scheduling recommendations.

## Features

- **AI-Powered Task Scheduling**: Intelligent scheduling recommendations based on task complexity, priority, and your calendar
- **Task Management**: Create, edit, and track tasks with custom priorities and deadlines
- **Smart Suggestions**: AI provides optimal scheduling suggestions to maximize productivity
- **Persistent Storage**: Local Core Data storage for offline access
- **Clean UI**: Modern SwiftUI interface with intuitive navigation
- **Dark Mode Support**: Full light and dark mode support

## Requirements

- iOS 14.0+
- Xcode 13.0+
- Swift 5.5+

## Project Structure

```
AISchedulingApp/
├── App/
│   ├── AISchedulingApp.swift          # Main app entry point
│   └── AppDelegate.swift               # App lifecycle management
├── Models/
│   ├── Task.swift                      # Core task model
│   ├── ScheduleRecommendation.swift    # AI scheduling recommendations
│   └── AIResponse.swift                # API response models
├── Views/
│   ├── ContentView.swift               # Main navigation view
│   ├── TaskListView.swift              # List of tasks
│   ├── TaskDetailView.swift            # Task details and editing
│   ├── TaskCreationView.swift          # New task creation form
│   └── RecommendationsView.swift       # AI scheduling suggestions
├── Services/
│   ├── TaskService.swift               # Core Data operations
│   ├── AISchedulingService.swift       # AI scheduling logic
│   ├── APIService.swift                # API communication
│   └── NotificationService.swift       # Local notifications
├── ViewModels/
│   ├── TaskListViewModel.swift         # Task list state management
│   ├── TaskDetailViewModel.swift       # Task detail state management
│   └── SchedulingViewModel.swift       # Scheduling state management
└── Utilities/
    ├── Constants.swift                 # App constants
    ├── Extensions.swift                # Swift extensions
    └── DateFormatter+Extensions.swift   # Date formatting utilities
```

## Installation

1. Clone the repository:
```bash
git clone <repository-url>
cd AISchedulingApp
```

2. Open the Xcode project:
```bash
open AISchedulingApp.xcodeproj
```

3. Build and run on your device or simulator:
```
Cmd + R
```

## Configuration

### API Configuration

Create a `.env` file in the root directory:

```
API_BASE_URL=https://your-api-endpoint.com
API_KEY=your-api-key-here
AI_MODEL=gpt-4
```

## Usage

1. **Create a Task**: Tap the "+" button to create a new task with title, description, priority, and deadline
2. **Get Scheduling Recommendations**: Tap "Get Suggestions" to receive AI-powered scheduling recommendations
3. **Edit Tasks**: Swipe to edit or delete existing tasks
4. **View Schedule**: See your optimized schedule based on AI recommendations

## Development

### Running Tests

```bash
xcodebuild test -scheme AISchedulingApp
```

### Code Style

This project follows Swift standard conventions and includes SwiftUI best practices.

## Architecture

- **MVVM Pattern**: Clean separation between Views, ViewModels, and Models
- **Reactive Programming**: Combines @State, @ObservedObject for reactive updates
- **Async/Await**: Modern concurrency patterns for API calls
- **Core Data**: Persistent storage with proper lifecycle management

## API Integration

The app integrates with an AI scheduling service that provides:
- Task analysis and categorization
- Optimal time slot recommendations
- Workload balancing suggestions
- Priority adjustments based on deadlines

## License

MIT License - See LICENSE file for details

## Support

For issues or feature requests, please open an issue on GitHub.
