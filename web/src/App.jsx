import { useState } from 'react'
import { useTasks } from './hooks/useTasks.js'
import TaskList from './components/TaskList.jsx'
import ScheduleView from './components/ScheduleView.jsx'
import Dashboard from './components/Dashboard.jsx'

export default function App() {
  const [tab, setTab] = useState('tasks')
  const { tasks, addTask, updateTask, deleteTask, toggleComplete } = useTasks()

  return (
    <>
      <div className="app-header">
        <h1>AI Scheduling</h1>
        <p>Smart task management with AI-powered scheduling</p>
      </div>

      <div className="tabs">
        <button className={`tab ${tab === 'tasks' ? 'active' : ''}`} onClick={() => setTab('tasks')}>
          Tasks
        </button>
        <button className={`tab ${tab === 'schedule' ? 'active' : ''}`} onClick={() => setTab('schedule')}>
          Schedule
        </button>
        <button className={`tab ${tab === 'dashboard' ? 'active' : ''}`} onClick={() => setTab('dashboard')}>
          Dashboard
        </button>
      </div>

      <main>
        {tab === 'tasks' && (
          <TaskList
            tasks={tasks}
            addTask={addTask}
            toggleComplete={toggleComplete}
            deleteTask={deleteTask}
          />
        )}
        {tab === 'schedule' && <ScheduleView tasks={tasks} updateTask={updateTask} />}
        {tab === 'dashboard' && <Dashboard tasks={tasks} />}
      </main>
    </>
  )
}
