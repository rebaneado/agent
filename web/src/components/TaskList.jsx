import { useState } from 'react'
import TaskItem from './TaskItem.jsx'
import TaskForm from './TaskForm.jsx'

export default function TaskList({ tasks, addTask, toggleComplete, deleteTask }) {
  const [showForm, setShowForm] = useState(false)

  return (
    <div>
      <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', marginBottom: 12 }}>
        <h2 style={{ margin: 0, fontSize: 18 }}>Tasks</h2>
        <button className="primary" style={{ width: 'auto', padding: '8px 16px' }} onClick={() => setShowForm((s) => !s)}>
          {showForm ? 'Cancel' : '+ New Task'}
        </button>
      </div>

      {showForm && <TaskForm onAdd={addTask} onClose={() => setShowForm(false)} />}

      {tasks.length === 0 ? (
        <div className="empty-state">
          <p>No tasks yet. Add one to get started.</p>
        </div>
      ) : (
        tasks
          .slice()
          .sort((a, b) => Number(a.isCompleted) - Number(b.isCompleted))
          .map((task) => (
            <TaskItem key={task.id} task={task} onToggle={toggleComplete} onDelete={deleteTask} />
          ))
      )}
    </div>
  )
}
