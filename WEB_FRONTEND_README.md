# Meeting Management System - Web Frontend

A modern, responsive web interface for the Meeting Minutes Management System.

## 🌟 Features

### Dashboard
- **Summary Statistics**: View total meetings, calendar events, tasks, and completion rates
- **Task Progress Breakdown**: Visual representation of tasks by status (To Do, In Progress, Completed)
- **Quick Overview**: Get insights into your meeting management at a glance

### Meetings Management
- **Create Meetings**: Add new meetings with title, date, and attendees
- **View Meeting Details**: Expandable cards showing full meeting information
- **Manage Agenda Items**: Add agenda items with titles, descriptions, and durations
- **Auto-Schedule**: Automatically create calendar events for meetings and follow-ups
- **Delete Meetings**: Remove meetings you no longer need

### Task Tracking
- **View All Tasks**: See all tasks across all meetings
- **Filter by Status**: Filter tasks by To Do, In Progress, or Completed
- **Update Task Status**: Change task status with dropdown selection
- **Track Progress**: Visual progress bars and sliders for each task
- **Task Details**: View assignee, deadline, and notes for each task

### Calendar View
- **Timeline Visualization**: Beautiful timeline view of all calendar events
- **Event Grouping**: Events grouped by date for easy navigation
- **Event Types**: Distinguished icons and colors for meetings vs follow-ups
- **Event Details**: See event duration, type, and notes

## 🚀 Getting Started

### Prerequisites

- Node.js 16+ and npm
- Python 3.12+
- All dependencies from the main project

### Installation

1. **Install Backend Dependencies**

```bash
# From the project root
pip install -r requirements.txt
cd backend
pip install -r requirements.txt
```

2. **Install Frontend Dependencies**

```bash
cd frontend
npm install
```

### Running the Application

You need to run both the backend API and the frontend development server:

**Terminal 1 - Backend API:**
```bash
# From the project root
cd backend
python api.py
```

The backend API will start on `http://localhost:8000`

**Terminal 2 - Frontend Dev Server:**
```bash
# From the project root
cd frontend
npm run dev
```

The frontend will start on `http://localhost:3000`

**Access the application:**
Open your browser and navigate to `http://localhost:3000`

## 📁 Project Structure

```
frontend/
├── public/              # Static assets
├── src/
│   ├── components/      # React components
│   │   ├── Dashboard.jsx       # Dashboard with statistics
│   │   ├── Dashboard.css
│   │   ├── MeetingList.jsx     # Meeting list and details
│   │   ├── MeetingList.css
│   │   ├── MeetingForm.jsx     # Create meeting form
│   │   ├── MeetingForm.css
│   │   ├── TaskList.jsx        # Task management
│   │   ├── TaskList.css
│   │   ├── CalendarView.jsx    # Calendar timeline
│   │   └── CalendarView.css
│   ├── App.jsx          # Main application component
│   ├── App.css          # Main application styles
│   ├── main.jsx         # React entry point
│   └── index.css        # Global styles
├── index.html           # HTML template
├── package.json         # Dependencies and scripts
└── vite.config.js       # Vite configuration

backend/
├── api.py               # FastAPI backend server
└── requirements.txt     # Backend dependencies
```

## 🎨 Design Features

- **Modern UI**: Gradient backgrounds, smooth animations, and clean design
- **Responsive**: Works on desktop, tablet, and mobile devices
- **Interactive**: Expandable cards, drag-to-update progress, smooth transitions
- **Color-Coded**: Different colors for task statuses and event types
- **Accessible**: Clear labels, good contrast, keyboard navigation

## 🔧 API Integration

The frontend communicates with the FastAPI backend through these endpoints:

- `GET /api/meetings` - Get all meetings
- `POST /api/meetings` - Create a new meeting
- `GET /api/meetings/{id}` - Get a specific meeting
- `DELETE /api/meetings/{id}` - Delete a meeting
- `POST /api/agenda-items` - Create an agenda item
- `GET /api/tasks` - Get all tasks
- `PATCH /api/tasks/{id}` - Update a task
- `GET /api/calendar-events` - Get all calendar events
- `POST /api/calendar-events/auto-schedule/{meeting_id}` - Auto-schedule a meeting
- `GET /api/summary` - Get summary statistics

## 📝 Usage Examples

### Creating a Meeting

1. Click on the "Meetings" tab
2. Click "New Meeting" button
3. Fill in the form:
   - Meeting Title (e.g., "Q1 Planning Meeting")
   - Date
   - Attendees (comma-separated, e.g., "Alice, Bob, Charlie")
4. Click "Create Meeting"

### Adding Agenda Items

1. In the Meetings tab, click on a meeting to expand it
2. Click "Add Item" in the Agenda Items section
3. Fill in:
   - Agenda title
   - Description
   - Duration in minutes
4. Click "Save Agenda Item"

### Auto-Scheduling

1. Expand a meeting that has agenda items
2. Click "Auto-Schedule" button
3. The system will create calendar events for:
   - The main meeting
   - Follow-up events for each agenda item

### Managing Tasks

1. Click on the "Tasks" tab
2. Use filter buttons to view tasks by status
3. Change task status using the dropdown
4. Drag the progress slider to update completion percentage
5. Status automatically updates based on progress

## 🛠️ Development

### Available Scripts

- `npm run dev` - Start development server
- `npm run build` - Build for production
- `npm run preview` - Preview production build

### Building for Production

```bash
cd frontend
npm run build
```

The built files will be in the `frontend/dist` directory.

### Environment Configuration

The frontend uses Vite's proxy configuration to communicate with the backend. If you need to change the API URL, edit `vite.config.js`:

```javascript
export default defineConfig({
  server: {
    proxy: {
      '/api': {
        target: 'http://your-backend-url:8000',
        changeOrigin: true
      }
    }
  }
})
```

## 🚢 Deployment

### Frontend Deployment

Deploy the built frontend to:
- **Vercel**: `vercel deploy`
- **Netlify**: `netlify deploy`
- **GitHub Pages**: Configure with GitHub Actions
- **Any static hosting**: Upload `dist/` folder

### Backend Deployment

Deploy the FastAPI backend to:
- **Heroku**: Use `Procfile` with `uvicorn`
- **AWS Lambda**: Use Mangum adapter
- **DigitalOcean**: Deploy as a droplet
- **Railway**: One-click deploy

**Important**: Update CORS settings in `backend/api.py` to allow requests from your production frontend URL.

## 🔒 Security Considerations

For production deployment:

1. **Update CORS**: In `backend/api.py`, change:
   ```python
   allow_origins=["*"]  # Change to specific frontend URL
   ```

2. **Add Authentication**: Implement user authentication and authorization

3. **Secure API**: Add API keys or JWT tokens for API access

4. **HTTPS**: Use HTTPS for both frontend and backend

5. **Environment Variables**: Store sensitive data in environment variables

## 🤝 Contributing

Contributions are welcome! Areas for improvement:

- Add user authentication and multi-user support
- Implement database persistence (PostgreSQL, MongoDB)
- Add real-time updates with WebSockets
- Enhance calendar with month/week views
- Add export features (PDF, Excel)
- Integrate AI features from the CLI app
- Add drag-and-drop task management
- Implement dark mode

## 📄 License

MIT License - Feel free to use and modify

## 🙏 Acknowledgments

- Built with React and FastAPI
- Uses Vite for fast development
- Styled with modern CSS gradients and animations
- Integrates with the Jaclang-based backend logic
