import { useState, useEffect } from 'react'
import axios from 'axios'
import './App.css'
import Dashboard from './components/Dashboard'
import MeetingList from './components/MeetingList'
import MeetingForm from './components/MeetingForm'
import TaskList from './components/TaskList'
import CalendarView from './components/CalendarView'

const API_URL = '/api'

function App() {
  const [activeTab, setActiveTab] = useState('dashboard')
  const [meetings, setMeetings] = useState([])
  const [tasks, setTasks] = useState([])
  const [calendarEvents, setCalendarEvents] = useState([])
  const [summary, setSummary] = useState({})
  const [loading, setLoading] = useState(true)
  const [showMeetingForm, setShowMeetingForm] = useState(false)

  // Fetch data
  const fetchData = async () => {
    try {
      setLoading(true)
      const [meetingsRes, tasksRes, eventsRes, summaryRes] = await Promise.all([
        axios.get(`${API_URL}/meetings`),
        axios.get(`${API_URL}/tasks`),
        axios.get(`${API_URL}/calendar-events`),
        axios.get(`${API_URL}/summary`)
      ])
      
      setMeetings(meetingsRes.data)
      setTasks(tasksRes.data)
      setCalendarEvents(eventsRes.data)
      setSummary(summaryRes.data)
    } catch (error) {
      console.error('Error fetching data:', error)
    } finally {
      setLoading(false)
    }
  }

  useEffect(() => {
    fetchData()
  }, [])

  const handleCreateMeeting = async (meetingData) => {
    try {
      await axios.post(`${API_URL}/meetings`, meetingData)
      await fetchData()
      setShowMeetingForm(false)
    } catch (error) {
      console.error('Error creating meeting:', error)
      alert('Failed to create meeting')
    }
  }

  const handleUpdateTask = async (taskId, updates) => {
    try {
      await axios.patch(`${API_URL}/tasks/${taskId}`, updates)
      await fetchData()
    } catch (error) {
      console.error('Error updating task:', error)
      alert('Failed to update task')
    }
  }

  const handleDeleteMeeting = async (meetingId) => {
    if (window.confirm('Are you sure you want to delete this meeting?')) {
      try {
        await axios.delete(`${API_URL}/meetings/${meetingId}`)
        await fetchData()
      } catch (error) {
        console.error('Error deleting meeting:', error)
        alert('Failed to delete meeting')
      }
    }
  }

  const handleAutoSchedule = async (meetingId) => {
    try {
      await axios.post(`${API_URL}/calendar-events/auto-schedule/${meetingId}`)
      await fetchData()
      alert('Meeting scheduled successfully!')
    } catch (error) {
      console.error('Error scheduling meeting:', error)
      alert('Failed to schedule meeting')
    }
  }

  if (loading) {
    return (
      <div className="loading">
        <div className="spinner"></div>
        <p>Loading...</p>
      </div>
    )
  }

  return (
    <div className="app">
      <header className="header">
        <h1>📋 Meeting Management System</h1>
        <p>Modern web interface for managing meetings, tasks, and calendar events</p>
      </header>

      <nav className="nav-tabs">
        <button 
          className={activeTab === 'dashboard' ? 'tab active' : 'tab'}
          onClick={() => setActiveTab('dashboard')}
        >
          📊 Dashboard
        </button>
        <button 
          className={activeTab === 'meetings' ? 'tab active' : 'tab'}
          onClick={() => setActiveTab('meetings')}
        >
          📅 Meetings
        </button>
        <button 
          className={activeTab === 'tasks' ? 'tab active' : 'tab'}
          onClick={() => setActiveTab('tasks')}
        >
          ✅ Tasks
        </button>
        <button 
          className={activeTab === 'calendar' ? 'tab active' : 'tab'}
          onClick={() => setActiveTab('calendar')}
        >
          🗓️ Calendar
        </button>
      </nav>

      <main className="main-content">
        {activeTab === 'dashboard' && (
          <Dashboard summary={summary} />
        )}

        {activeTab === 'meetings' && (
          <>
            <div className="section-header">
              <h2>Meetings</h2>
              <button 
                className="btn btn-primary"
                onClick={() => setShowMeetingForm(!showMeetingForm)}
              >
                {showMeetingForm ? '❌ Cancel' : '➕ New Meeting'}
              </button>
            </div>

            {showMeetingForm && (
              <MeetingForm 
                onSubmit={handleCreateMeeting}
                onCancel={() => setShowMeetingForm(false)}
              />
            )}

            <MeetingList 
              meetings={meetings}
              onDelete={handleDeleteMeeting}
              onAutoSchedule={handleAutoSchedule}
              onRefresh={fetchData}
            />
          </>
        )}

        {activeTab === 'tasks' && (
          <>
            <div className="section-header">
              <h2>All Tasks</h2>
            </div>
            <TaskList 
              tasks={tasks}
              onUpdateTask={handleUpdateTask}
            />
          </>
        )}

        {activeTab === 'calendar' && (
          <>
            <div className="section-header">
              <h2>Calendar Events</h2>
            </div>
            <CalendarView events={calendarEvents} />
          </>
        )}
      </main>

      <footer className="footer">
        <p>Built with ❤️ using React, FastAPI, and Jaclang</p>
      </footer>
    </div>
  )
}

export default App
