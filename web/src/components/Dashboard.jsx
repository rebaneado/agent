export default function Dashboard({ tasks }) {
  const total = tasks.length
  const completed = tasks.filter((t) => t.isCompleted).length
  const urgent = tasks.filter((t) => t.priority === 'Urgent' && !t.isCompleted).length
  const now = new Date()
  const overdue = tasks.filter(
    (t) => !t.isCompleted && t.dueDate && new Date(t.dueDate) < now,
  ).length
  const completionRate = total === 0 ? 0 : Math.round((completed / total) * 100)

  return (
    <div>
      <h2 style={{ marginTop: 0, fontSize: 18 }}>Dashboard</h2>
      <div className="stat-grid">
        <div className="stat-card">
          <div className="stat-value">{total}</div>
          <div className="stat-label">Total Tasks</div>
        </div>
        <div className="stat-card">
          <div className="stat-value">{urgent}</div>
          <div className="stat-label">Urgent</div>
        </div>
        <div className="stat-card">
          <div className="stat-value">{overdue}</div>
          <div className="stat-label">Overdue</div>
        </div>
        <div className="stat-card">
          <div className="stat-value">{completionRate}%</div>
          <div className="stat-label">Completion</div>
        </div>
      </div>
    </div>
  )
}
