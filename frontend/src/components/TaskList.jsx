import { useState } from 'react'
import './TaskList.css'

function TaskList({ tasks, onUpdateTask }) {
  const [filter, setFilter] = useState('all')

  const filteredTasks = tasks.filter(task => {
    if (filter === 'all') return true
    return task.status === filter
  })

  const getStatusIcon = (status) => {
    switch (status) {
      case 'completed':
        return '✅'
      case 'in_progress':
        return '🔄'
      case 'todo':
      default:
        return '⏳'
    }
  }

  const getStatusColor = (status) => {
    switch (status) {
      case 'completed':
        return 'completed'
      case 'in_progress':
        return 'in-progress'
      case 'todo':
      default:
        return 'todo'
    }
  }

  const handleStatusChange = (taskId, newStatus) => {
    const progress = newStatus === 'completed' ? 100 : 
                     newStatus === 'in_progress' ? 50 : 0
    onUpdateTask(taskId, { status: newStatus, progress })
  }

  const handleProgressChange = (taskId, newProgress) => {
    const status = newProgress === 100 ? 'completed' :
                   newProgress > 0 ? 'in_progress' : 'todo'
    onUpdateTask(taskId, { progress: newProgress, status })
  }

  if (tasks.length === 0) {
    return (
      <div className="empty-state">
        <div className="empty-icon">✅</div>
        <h3>No tasks yet</h3>
        <p>Tasks will appear here once you add agenda items to meetings</p>
      </div>
    )
  }

  return (
    <div className="task-list-container">
      <div className="filter-buttons">
        <button
          className={`filter-btn ${filter === 'all' ? 'active' : ''}`}
          onClick={() => setFilter('all')}
        >
          All Tasks ({tasks.length})
        </button>
        <button
          className={`filter-btn ${filter === 'todo' ? 'active' : ''}`}
          onClick={() => setFilter('todo')}
        >
          To Do ({tasks.filter(t => t.status === 'todo').length})
        </button>
        <button
          className={`filter-btn ${filter === 'in_progress' ? 'active' : ''}`}
          onClick={() => setFilter('in_progress')}
        >
          In Progress ({tasks.filter(t => t.status === 'in_progress').length})
        </button>
        <button
          className={`filter-btn ${filter === 'completed' ? 'active' : ''}`}
          onClick={() => setFilter('completed')}
        >
          Completed ({tasks.filter(t => t.status === 'completed').length})
        </button>
      </div>

      <div className="task-list">
        {filteredTasks.map(task => (
          <div key={task.id} className={`task-card ${getStatusColor(task.status)}`}>
            <div className="task-header">
              <div className="task-title">
                <span className="task-icon">{getStatusIcon(task.status)}</span>
                <h4>{task.title}</h4>
              </div>
              <select
                className={`status-select ${getStatusColor(task.status)}`}
                value={task.status}
                onChange={(e) => handleStatusChange(task.id, e.target.value)}
              >
                <option value="todo">To Do</option>
                <option value="in_progress">In Progress</option>
                <option value="completed">Completed</option>
              </select>
            </div>

            <div className="task-details">
              <div className="task-meta">
                <span className="meta-item">
                  👤 <strong>Assignee:</strong> {task.assignee}
                </span>
                <span className="meta-item">
                  📅 <strong>Deadline:</strong> {new Date(task.deadline).toLocaleDateString()}
                </span>
              </div>

              <div className="task-progress">
                <div className="progress-header">
                  <span>Progress</span>
                  <span className="progress-percentage">{task.progress}%</span>
                </div>
                <div className="progress-bar-container">
                  <div 
                    className={`progress-bar-fill ${getStatusColor(task.status)}`}
                    style={{ width: `${task.progress}%` }}
                  ></div>
                </div>
                <input
                  type="range"
                  min="0"
                  max="100"
                  value={task.progress}
                  onChange={(e) => handleProgressChange(task.id, parseInt(e.target.value))}
                  className="progress-slider"
                />
              </div>

              {task.notes && (
                <div className="task-notes">
                  <strong>Notes:</strong> {task.notes}
                </div>
              )}
            </div>
          </div>
        ))}
      </div>
    </div>
  )
}

export default TaskList
