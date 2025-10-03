import './Dashboard.css'

function Dashboard({ summary }) {
  const {
    total_meetings = 0,
    total_calendar_events = 0,
    total_tasks = 0,
    tasks_completed = 0,
    tasks_in_progress = 0,
    tasks_todo = 0,
    completion_rate = 0
  } = summary

  return (
    <div className="dashboard">
      <div className="stats-grid">
        <div className="stat-card purple">
          <div className="stat-icon">📅</div>
          <div className="stat-content">
            <h3>Total Meetings</h3>
            <p className="stat-number">{total_meetings}</p>
          </div>
        </div>

        <div className="stat-card blue">
          <div className="stat-icon">🗓️</div>
          <div className="stat-content">
            <h3>Calendar Events</h3>
            <p className="stat-number">{total_calendar_events}</p>
          </div>
        </div>

        <div className="stat-card green">
          <div className="stat-icon">✅</div>
          <div className="stat-content">
            <h3>Total Tasks</h3>
            <p className="stat-number">{total_tasks}</p>
          </div>
        </div>

        <div className="stat-card orange">
          <div className="stat-icon">📊</div>
          <div className="stat-content">
            <h3>Completion Rate</h3>
            <p className="stat-number">{completion_rate}%</p>
          </div>
        </div>
      </div>

      <div className="progress-section">
        <h3>Task Progress Breakdown</h3>
        <div className="progress-cards">
          <div className="progress-card">
            <div className="progress-label">
              <span className="status-badge todo">To Do</span>
              <span className="count">{tasks_todo}</span>
            </div>
            <div className="progress-bar">
              <div 
                className="progress-fill todo"
                style={{ width: total_tasks > 0 ? `${(tasks_todo / total_tasks) * 100}%` : '0%' }}
              ></div>
            </div>
          </div>

          <div className="progress-card">
            <div className="progress-label">
              <span className="status-badge in-progress">In Progress</span>
              <span className="count">{tasks_in_progress}</span>
            </div>
            <div className="progress-bar">
              <div 
                className="progress-fill in-progress"
                style={{ width: total_tasks > 0 ? `${(tasks_in_progress / total_tasks) * 100}%` : '0%' }}
              ></div>
            </div>
          </div>

          <div className="progress-card">
            <div className="progress-label">
              <span className="status-badge completed">Completed</span>
              <span className="count">{tasks_completed}</span>
            </div>
            <div className="progress-bar">
              <div 
                className="progress-fill completed"
                style={{ width: total_tasks > 0 ? `${(tasks_completed / total_tasks) * 100}%` : '0%' }}
              ></div>
            </div>
          </div>
        </div>
      </div>

      <div className="welcome-message">
        <h2>Welcome to Meeting Management System!</h2>
        <p>Organize your meetings, track tasks, and manage your calendar all in one place.</p>
        <div className="features">
          <div className="feature">
            <span className="feature-icon">📝</span>
            <span>Create and manage meetings</span>
          </div>
          <div className="feature">
            <span className="feature-icon">✨</span>
            <span>Track agenda items</span>
          </div>
          <div className="feature">
            <span className="feature-icon">🎯</span>
            <span>Monitor task progress</span>
          </div>
          <div className="feature">
            <span className="feature-icon">📆</span>
            <span>Auto-schedule events</span>
          </div>
        </div>
      </div>
    </div>
  )
}

export default Dashboard
