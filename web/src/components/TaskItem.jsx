export default function TaskItem({ task, onToggle, onDelete }) {
  return (
    <div className={`card task-item ${task.isCompleted ? 'completed' : ''}`}>
      <button
        className={`checkbox ${task.isCompleted ? 'checked' : ''}`}
        onClick={() => onToggle(task.id)}
        aria-label="Toggle complete"
      />
      <div className="task-body">
        <div className="task-title">{task.title}</div>
        {task.description && <div className="task-desc">{task.description}</div>}
        <div className="task-meta">
          <span className={`priority-badge priority-${task.priority}`}>{task.priority}</span>
          <span>{task.estimatedDuration}m</span>
          {task.dueDate && <span>Due {task.dueDate}</span>}
        </div>
      </div>
      <button className="delete-btn" onClick={() => onDelete(task.id)} aria-label="Delete task">
        &times;
      </button>
    </div>
  )
}
