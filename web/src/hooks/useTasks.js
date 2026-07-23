import { useState, useEffect, useCallback } from 'react'

const STORAGE_KEY = 'ai-scheduling-tasks'

function loadTasks() {
  try {
    const raw = localStorage.getItem(STORAGE_KEY)
    return raw ? JSON.parse(raw) : []
  } catch {
    return []
  }
}

export function useTasks() {
  const [tasks, setTasks] = useState(loadTasks)

  useEffect(() => {
    localStorage.setItem(STORAGE_KEY, JSON.stringify(tasks))
  }, [tasks])

  const addTask = useCallback((task) => {
    setTasks((prev) => [
      ...prev,
      {
        id: crypto.randomUUID(),
        title: task.title,
        description: task.description || '',
        priority: task.priority || 'Medium',
        dueDate: task.dueDate || null,
        estimatedDuration: task.estimatedDuration || 30,
        scheduledDate: null,
        isCompleted: false,
        createdAt: new Date().toISOString(),
      },
    ])
  }, [])

  const updateTask = useCallback((id, patch) => {
    setTasks((prev) => prev.map((t) => (t.id === id ? { ...t, ...patch } : t)))
  }, [])

  const deleteTask = useCallback((id) => {
    setTasks((prev) => prev.filter((t) => t.id !== id))
  }, [])

  const toggleComplete = useCallback((id) => {
    setTasks((prev) =>
      prev.map((t) => (t.id === id ? { ...t, isCompleted: !t.isCompleted } : t)),
    )
  }, [])

  return { tasks, addTask, updateTask, deleteTask, toggleComplete }
}
