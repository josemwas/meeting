import { useState } from 'react'
import axios from 'axios'
import './MeetingList.css'

function MeetingList({ meetings, onDelete, onAutoSchedule, onRefresh }) {
  const [expandedMeeting, setExpandedMeeting] = useState(null)
  const [showAgendaForm, setShowAgendaForm] = useState(null)
  const [agendaData, setAgendaData] = useState({
    title: '',
    description: '',
    duration: 30
  })

  const handleAddAgendaItem = async (meetingId) => {
    try {
      await axios.post('/api/agenda-items', {
        ...agendaData,
        meeting_id: meetingId
      })
      setAgendaData({ title: '', description: '', duration: 30 })
      setShowAgendaForm(null)
      onRefresh()
    } catch (error) {
      console.error('Error adding agenda item:', error)
      alert('Failed to add agenda item')
    }
  }

  const toggleExpand = (meetingId) => {
    setExpandedMeeting(expandedMeeting === meetingId ? null : meetingId)
  }

  if (meetings.length === 0) {
    return (
      <div className="empty-state">
        <div className="empty-icon">📅</div>
        <h3>No meetings yet</h3>
        <p>Click "New Meeting" to create your first meeting</p>
      </div>
    )
  }

  return (
    <div className="meeting-list">
      {meetings.map(meeting => (
        <div key={meeting.id} className="meeting-card">
          <div className="meeting-header" onClick={() => toggleExpand(meeting.id)}>
            <div className="meeting-info">
              <h3>{meeting.title}</h3>
              <div className="meeting-meta">
                <span className="meta-item">
                  📅 {new Date(meeting.date).toLocaleDateString()}
                </span>
                <span className="meta-item">
                  👥 {meeting.attendees.length} attendees
                </span>
                <span className="meta-item">
                  📝 {meeting.agenda_items?.length || 0} agenda items
                </span>
              </div>
            </div>
            <div className="expand-icon">
              {expandedMeeting === meeting.id ? '▼' : '▶'}
            </div>
          </div>

          {expandedMeeting === meeting.id && (
            <div className="meeting-details">
              <div className="attendees-section">
                <h4>Attendees:</h4>
                <div className="attendee-tags">
                  {meeting.attendees.map((attendee, idx) => (
                    <span key={idx} className="attendee-tag">
                      👤 {attendee}
                    </span>
                  ))}
                </div>
              </div>

              <div className="agenda-section">
                <div className="section-header-small">
                  <h4>Agenda Items</h4>
                  <button
                    className="btn btn-small btn-primary"
                    onClick={() => setShowAgendaForm(
                      showAgendaForm === meeting.id ? null : meeting.id
                    )}
                  >
                    {showAgendaForm === meeting.id ? '❌' : '➕ Add Item'}
                  </button>
                </div>

                {showAgendaForm === meeting.id && (
                  <div className="agenda-form">
                    <input
                      type="text"
                      placeholder="Agenda title"
                      value={agendaData.title}
                      onChange={(e) => setAgendaData({ ...agendaData, title: e.target.value })}
                    />
                    <textarea
                      placeholder="Description"
                      value={agendaData.description}
                      onChange={(e) => setAgendaData({ ...agendaData, description: e.target.value })}
                      rows="2"
                    />
                    <input
                      type="number"
                      placeholder="Duration (minutes)"
                      value={agendaData.duration}
                      onChange={(e) => setAgendaData({ ...agendaData, duration: parseInt(e.target.value) })}
                    />
                    <button
                      className="btn btn-small btn-success"
                      onClick={() => handleAddAgendaItem(meeting.id)}
                    >
                      Save Agenda Item
                    </button>
                  </div>
                )}

                {meeting.agenda_items && meeting.agenda_items.length > 0 ? (
                  <div className="agenda-items">
                    {meeting.agenda_items.map(item => (
                      <div key={item.id} className="agenda-item">
                        <div className="agenda-item-header">
                          <strong>{item.title}</strong>
                          <span className="duration-badge">{item.duration} min</span>
                        </div>
                        <p className="agenda-description">{item.description}</p>
                        {item.scheduled_date && (
                          <span className="scheduled-badge">
                            📅 Scheduled: {new Date(item.scheduled_date).toLocaleDateString()}
                          </span>
                        )}
                      </div>
                    ))}
                  </div>
                ) : (
                  <p className="no-items">No agenda items yet</p>
                )}
              </div>

              <div className="meeting-actions">
                <button
                  className="btn btn-small btn-primary"
                  onClick={() => onAutoSchedule(meeting.id)}
                >
                  🗓️ Auto-Schedule
                </button>
                <button
                  className="btn btn-small btn-danger"
                  onClick={() => onDelete(meeting.id)}
                >
                  🗑️ Delete Meeting
                </button>
              </div>
            </div>
          )}
        </div>
      ))}
    </div>
  )
}

export default MeetingList
