import { useState } from 'react'

export default function TaskForm({ onAdd, onClose }) {
  const [title, setTitle] = useState('')
  const [description, setDescription] = useState('')
  const [priority, setPriority] = useState('Medium')
  const [dueDate, setDueDate] = useState('')
  const [estimatedDuration, setEstimatedDuration] = useState(30)

  const handleSubmit = (e) => {
    e.preventDefault()
    if (!title.trim()) return
    onAdd({
      title: title.trim(),
      description: description.trim(),
      priority,
      dueDate: dueDate || null,
      estimatedDuration: Number(estimatedDuration),
    })
    onClose()
  }

  return (
    <form className="card" onSubmit={handleSubmit}>
      <div className="form-group">
        <label>Title</label>
        <input
          type="text"
          value={title}
          onChange={(e) => setTitle(e.target.value)}
          placeholder="Task title"
          autoFocus
        />
      </div>
      <div className="form-group">
        <label>Description (optional)</label>
        <textarea
          value={description}
          onChange={(e) => setDescription(e.target.value)}
          placeholder="Details about this task"
        />
      </div>
      <div className="form-group">
        <label>Priority</label>
        <select value={priority} onChange={(e) => setPriority(e.target.value)}>
          <option>Low</option>
          <option>Medium</option>
          <option>High</option>
          <option>Urgent</option>
        </select>
      </div>
      <div className="form-group">
        <label>Estimated duration (minutes)</label>
        <input
          type="number"
          min="5"
          step="5"
          value={estimatedDuration}
          onChange={(e) => setEstimatedDuration(e.target.value)}
        />
      </div>
      <div className="form-group">
        <label>Due date (optional)</label>
        <input type="date" value={dueDate} onChange={(e) => setDueDate(e.target.value)} />
      </div>
      <button type="submit" className="primary" disabled={!title.trim()}>
        Create Task
      </button>
    </form>
  )
}
