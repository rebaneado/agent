# Installation Guide

## Prerequisites

- Xcode 13.0 or later
- iOS 14.0 or later deployment target
- Swift 5.5 or later

## Setup Instructions

### 1. Clone the Repository

```bash
git clone https://github.com/yourusername/AISchedulingApp.git
cd AISchedulingApp
```

### 2. Open in Xcode

```bash
open AISchedulingApp.xcodeproj
```

### 3. Configure API Keys

Create a `.env` file in the project root by copying the example:

```bash
cp .env.example .env
```

Edit `.env` with your API credentials:

```
API_BASE_URL=https://your-api-endpoint.com
API_KEY=your-actual-api-key
AI_MODEL=gpt-4
```

### 4. Build & Run

1. Select your target device/simulator in Xcode
2. Press `Cmd + R` to build and run
3. The app should launch on your selected device

## Project Structure

```
AISchedulingApp/
├── App/
│   └── AISchedulingApp.swift         # Entry point
├── Models/
│   ├── Task.swift                    # Task data model
│   └── ScheduleRecommendation.swift  # AI recommendations
├── Views/
│   ├── ContentView.swift             # Main navigation
│   ├── TaskListView.swift            # Task list
│   ├── TaskCreationView.swift        # New task form
│   └── RecommendationsView.swift     # Schedule suggestions
├── ViewModels/
│   ├── TaskListViewModel.swift       # Task list state
│   └── SchedulingViewModel.swift     # Scheduling state
├── Services/
│   ├── TaskService.swift             # Core Data
│   ├── AISchedulingService.swift     # AI logic
│   └── APIService.swift              # API calls
├── CoreData/
│   └── AISchedulingApp.xcdatamodel/  # Core Data model
└── Utilities/
    ├── Constants.swift               # Constants
    └── Extensions.swift              # Extensions
```

## Core Features

### Task Management
- Create, edit, and delete tasks
- Set priority levels (Low, Medium, High, Urgent)
- Define estimated duration (5-480 minutes)
- Set due dates and track completion

### AI Scheduling
- Get AI-powered scheduling recommendations
- View alternative time slots
- Accept or reject suggestions
- See confidence scores for recommendations

### Dashboard
- View task statistics
- Monitor urgent tasks and overdue items
- Track completion rate
- See today's tasks at a glance

## Testing

### Run Unit Tests

```bash
xcodebuild test -scheme AISchedulingApp
```

### Manual Testing Checklist

- [ ] Create a new task
- [ ] Set task priority and due date
- [ ] Get scheduling recommendations
- [ ] Accept a recommendation
- [ ] Mark task as complete
- [ ] View dashboard statistics

## Troubleshooting

### Build Errors

1. **Clean build folder**: `Cmd + Shift + K`
2. **Delete derived data**: `rm -rf ~/Library/Developer/Xcode/DerivedData/*`
3. **Update pods** (if using CocoaPods): `pod update`

### API Connection Issues

1. Verify `.env` file is properly configured
2. Check API endpoint URL is accessible
3. Confirm API key is valid
4. Review network connectivity

### Core Data Issues

1. Delete app from simulator
2. Clean build folder
3. Rebuild and run

## Performance Optimization Tips

1. Use the dashboard to monitor task volume
2. Archive completed tasks regularly
3. Limit concurrent tasks to avoid context switching
4. Review AI recommendations for workload balancing

## Support

For issues or questions, please create an issue on GitHub or contact support.
