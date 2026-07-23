import { useState } from 'react'
import { getScheduleRecommendations } from '../lib/api.js'

function formatDateTime(iso) {
  try {
    return new Date(iso).toLocaleString(undefined, {
      weekday: 'short',
      month: 'short',
      day: 'numeric',
      hour: 'numeric',
      minute: '2-digit',
    })
  } catch {
    return iso
  }
}

export default function ScheduleView({ tasks, updateTask }) {
  const [recommendations, setRecommendations] = useState([])
  const [loading, setLoading] = useState(false)
  const [error, setError] = useState(null)

  const incompleteTasks = tasks.filter((t) => !t.isCompleted)

  const fetchRecommendations = async () => {
    setLoading(true)
    setError(null)
    try {
      const data = await getScheduleRecommendations(incompleteTasks)
      setRecommendations(data.recommendations || [])
    } catch (err) {
      setError(err.message)
    } finally {
      setLoading(false)
    }
  }

  const accept = (rec) => {
    updateTask(rec.taskId, { scheduledDate: rec.recommendedStart })
    setRecommendations((prev) => prev.filter((r) => r.taskId !== rec.taskId))
  }

  const dismiss = (rec) => {
    setRecommendations((prev) => prev.filter((r) => r.taskId !== rec.taskId))
  }

  const taskTitle = (id) => tasks.find((t) => t.id === id)?.title || 'Task'

  return (
    <div>
      <h2 style={{ marginTop: 0, fontSize: 18 }}>AI Schedule</h2>

      {error && <div className="error-banner">{error}</div>}

      {recommendations.length === 0 && !loading && (
        <div className="card" style={{ textAlign: 'center' }}>
          <p style={{ color: 'var(--muted)', marginBottom: 16 }}>
            Let AI analyze your open tasks and suggest an optimal schedule.
          </p>
          <button className="primary" onClick={fetchRecommendations} disabled={incompleteTasks.length === 0}>
            Get Suggestions
          </button>
          {incompleteTasks.length === 0 && (
            <p style={{ fontSize: 12, color: 'var(--muted)', marginTop: 10 }}>
              Add a task first — there's nothing open to schedule.
            </p>
          )}
        </div>
      )}

      {loading && <div className="spinner">Thinking through your schedule…</div>}

      {recommendations.map((rec) => (
        <div key={rec.taskId} className="recommendation-card">
          <div className="task-title">{taskTitle(rec.taskId)}</div>
          <p style={{ fontSize: 13, color: 'var(--muted)', margin: '6px 0' }}>{rec.reasoning}</p>
          <div style={{ fontSize: 13 }}>
            {formatDateTime(rec.recommendedStart)} · {Math.round(rec.confidence * 100)}% confidence
          </div>
          <div className="rec-actions">
            <button className="dismiss" onClick={() => dismiss(rec)}>
              Dismiss
            </button>
            <button className="accept" onClick={() => accept(rec)}>
              Schedule
            </button>
          </div>
        </div>
      ))}
    </div>
  )
}
