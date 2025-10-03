import { useState } from 'react'
import './MeetingForm.css'

function MeetingForm({ onSubmit, onCancel }) {
  const [formData, setFormData] = useState({
    title: '',
    date: '',
    attendees: ''
  })

  const handleChange = (e) => {
    setFormData({
      ...formData,
      [e.target.name]: e.target.value
    })
  }

  const handleSubmit = (e) => {
    e.preventDefault()
    
    // Convert comma-separated attendees to array
    const attendeesArray = formData.attendees
      .split(',')
      .map(a => a.trim())
      .filter(a => a.length > 0)
    
    onSubmit({
      title: formData.title,
      date: formData.date,
      attendees: attendeesArray
    })
  }

  return (
    <form className="meeting-form" onSubmit={handleSubmit}>
      <h3>Create New Meeting</h3>
      
      <div className="form-group">
        <label htmlFor="title">Meeting Title *</label>
        <input
          type="text"
          id="title"
          name="title"
          value={formData.title}
          onChange={handleChange}
          required
          placeholder="e.g., Q1 Planning Meeting"
        />
      </div>

      <div className="form-group">
        <label htmlFor="date">Date *</label>
        <input
          type="date"
          id="date"
          name="date"
          value={formData.date}
          onChange={handleChange}
          required
        />
      </div>

      <div className="form-group">
        <label htmlFor="attendees">Attendees *</label>
        <input
          type="text"
          id="attendees"
          name="attendees"
          value={formData.attendees}
          onChange={handleChange}
          required
          placeholder="Alice, Bob, Charlie (comma-separated)"
        />
        <small>Enter names separated by commas</small>
      </div>

      <div className="form-actions">
        <button type="submit" className="btn btn-primary">
          Create Meeting
        </button>
        <button type="button" className="btn btn-secondary" onClick={onCancel}>
          Cancel
        </button>
      </div>
    </form>
  )
}

export default MeetingForm
