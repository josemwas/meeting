import './CalendarView.css'

function CalendarView({ events }) {
  // Group events by date
  const eventsByDate = events.reduce((acc, event) => {
    const date = event.date
    if (!acc[date]) {
      acc[date] = []
    }
    acc[date].push(event)
    return acc
  }, {})

  // Sort dates
  const sortedDates = Object.keys(eventsByDate).sort()

  const getEventTypeIcon = (type) => {
    switch (type) {
      case 'meeting':
        return '📅'
      case 'follow-up':
        return '🔔'
      default:
        return '📌'
    }
  }

  const getEventTypeColor = (type) => {
    switch (type) {
      case 'meeting':
        return 'meeting'
      case 'follow-up':
        return 'follow-up'
      default:
        return 'other'
    }
  }

  if (events.length === 0) {
    return (
      <div className="empty-state">
        <div className="empty-icon">🗓️</div>
        <h3>No calendar events yet</h3>
        <p>Schedule meetings to see them appear here</p>
      </div>
    )
  }

  return (
    <div className="calendar-view">
      <div className="calendar-stats">
        <div className="stat">
          <span className="stat-label">Total Events</span>
          <span className="stat-value">{events.length}</span>
        </div>
        <div className="stat">
          <span className="stat-label">Meetings</span>
          <span className="stat-value">
            {events.filter(e => e.event_type === 'meeting').length}
          </span>
        </div>
        <div className="stat">
          <span className="stat-label">Follow-ups</span>
          <span className="stat-value">
            {events.filter(e => e.event_type === 'follow-up').length}
          </span>
        </div>
      </div>

      <div className="timeline">
        {sortedDates.map(date => (
          <div key={date} className="date-group">
            <div className="date-header">
              <div className="date-badge">
                {new Date(date).toLocaleDateString('en-US', { 
                  weekday: 'short', 
                  year: 'numeric', 
                  month: 'short', 
                  day: 'numeric' 
                })}
              </div>
            </div>

            <div className="events-for-date">
              {eventsByDate[date].map(event => (
                <div 
                  key={event.id} 
                  className={`event-card ${getEventTypeColor(event.event_type)}`}
                >
                  <div className="event-icon">
                    {getEventTypeIcon(event.event_type)}
                  </div>
                  <div className="event-details">
                    <h4>{event.title}</h4>
                    <div className="event-meta">
                      <span className="duration">
                        ⏱️ {event.duration} minutes
                      </span>
                      <span className={`type-badge ${getEventTypeColor(event.event_type)}`}>
                        {event.event_type}
                      </span>
                    </div>
                    {event.notes && (
                      <p className="event-notes">{event.notes}</p>
                    )}
                  </div>
                </div>
              ))}
            </div>
          </div>
        ))}
      </div>
    </div>
  )
}

export default CalendarView
