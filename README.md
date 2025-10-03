# Meeting Minutes Management System

A comprehensive meeting management application built with **Jaclang** that helps you:
- Take and organize meeting minutes
- Automatically schedule agenda items on a calendar
- Track progress of all action items
- Manage a traceable to-do list
- Integrate AI assistance for automation (optional)

## Features

### 1. Meeting Management
- Create meetings with title, date, and attendees
- Add agenda items with descriptions and durations
- Automatically track meeting notes
- Save meeting data in structured JSON format

### 2. Calendar Integration
- Automatic calendar event creation for meetings
- Auto-schedule follow-up items from agenda
- View all calendar events by date
- Track event duration and type

### 3. Task Tracking & To-Do Lists
- Create tasks with assignees and deadlines
- Track task progress with percentage completion
- Filter tasks by status (todo, in_progress, completed)
- Filter tasks by assignee
- Add notes to tasks

### 4. AI Assistant (Optional)
- Auto-extract tasks from meeting notes
- Generate meeting summaries
- Suggest agenda items based on meeting purpose
- Recommend task priorities
- Enhance and structure notes

## Installation

### Prerequisites
- Python 3.12+
- Jaclang 0.8.7+

### Setup

1. Install Jaclang:
```bash
pip install jaclang
```

2. (Optional) For AI features, install ByLLM and set API key:
```bash
pip install byllm
export OPENAI_API_KEY='your-key-here'
# or
export ANTHROPIC_API_KEY='your-key-here'
```

## Usage

### Running the Main Application

```bash
jac run main.jac
```

This will:
1. Create a sample meeting with agenda items
2. Add tasks to agenda items
3. Auto-schedule items on the calendar
4. Track progress and generate reports
5. Save data to `meeting_data.json`

### Example Output

```
=== Meeting Minutes Management System ===
Built with Jaclang

Created meeting: Q1 Planning Meeting
Added 3 agenda items
Added 4 tasks
Auto-scheduled agenda items on calendar

=== Meeting Management System Summary ===
Total Meetings: 1
Total Calendar Events: 4
Total Tasks: 4

Progress Report:
  Completed: 1
  In Progress: 2
  To Do: 1
  Completion: 25.0%

=== Calendar Events ===
- 2024-01-15: Meeting: Q1 Planning Meeting (60 min)
- 2024-01-16: Follow-up: Budget Review (60 min)
- 2024-01-17: Follow-up: Project Timeline (45 min)
- 2024-01-18: Follow-up: Resource Allocation (30 min)
```

### Running the AI Assistant

```bash
jac run ai_assistant.jac
```

This demonstrates AI-powered features including:
- Task extraction from notes
- Agenda item suggestions
- Task priority recommendations

## Project Structure

```
meeting/
├── main.jac              # Main application with core functionality
├── ai_assistant.jac      # AI integration module (optional)
├── meeting_data.json     # Generated data file (created on first run)
└── README.md            # This file
```

## Core Data Models

### Meeting
- `id`: Unique meeting identifier
- `title`: Meeting title
- `date`: Meeting date (YYYY-MM-DD)
- `attendees`: List of attendee names
- `agenda_items`: List of agenda items
- `notes`: General meeting notes

### AgendaItem
- `id`: Unique item identifier
- `title`: Item title
- `description`: Item description
- `duration`: Duration in minutes
- `status`: Status (pending, scheduled)
- `scheduled_date`: Date scheduled on calendar
- `tasks`: Associated tasks

### Task
- `id`: Unique task identifier
- `title`: Task title
- `assignee`: Person responsible
- `deadline`: Task deadline (YYYY-MM-DD)
- `status`: Status (todo, in_progress, completed)
- `progress`: Progress percentage (0-100)
- `notes`: Task notes

### CalendarEvent
- `id`: Unique event identifier
- `title`: Event title
- `date`: Event date (YYYY-MM-DD)
- `duration`: Duration in minutes
- `event_type`: Type (meeting, agenda_item)
- `related_id`: ID of related meeting/item

## Key Functions

### Meeting Management
- `create_meeting(title, date, attendees)` - Create a new meeting
- `create_agenda_item(title, description, duration, meeting_id)` - Add agenda item
- `create_task(title, assignee, deadline, agenda_item_id)` - Create task

### Task Tracking
- `update_task_progress(task, progress)` - Update task progress
- `get_all_tasks(meetings)` - Get all tasks across meetings
- `get_tasks_by_status(meetings, status)` - Filter tasks by status
- `get_tasks_by_assignee(meetings, assignee)` - Filter by assignee

### Calendar
- `auto_schedule_agenda_items(meeting, calendar_events, start_date)` - Auto-schedule items
- `get_calendar_events_by_date(events, date)` - Get events for specific date

### Reporting
- `generate_progress_report(meetings)` - Generate progress statistics
- `print_summary(meetings, events)` - Print full summary
- `save_to_file(meetings, events, filename)` - Save to JSON

## AI Integration

The AI assistant module (`ai_assistant.jac`) provides intelligent automation:

### Available AI Functions
- `generate_meeting_summary(title, notes)` - Auto-summarize meetings
- `extract_tasks_from_notes(notes)` - Extract action items
- `suggest_agenda_items(title, purpose)` - Suggest agenda
- `suggest_task_priority(title, description, deadline)` - Recommend priority
- `enhance_meeting_notes(notes)` - Structure and enhance notes

### Enabling AI Features

Currently running in demo mode with placeholder implementations. To enable full AI:

1. Install ByLLM: `pip install byllm`
2. Set API key: `export OPENAI_API_KEY='your-key'`
3. Update `ai_assistant.jac` to integrate ByLLM calls

## Example: Creating a Custom Meeting

```jaclang
import main;

with entry {
    meetings = [];
    calendar_events = [];
    
    # Create meeting
    meeting = create_meeting(
        "Sprint Planning",
        "2024-02-01",
        ["Alice", "Bob", "Charlie", "Diana"]
    );
    meetings.append(meeting);
    
    # Add agenda items
    item1 = create_agenda_item(
        "Sprint Goals",
        "Define sprint objectives",
        30,
        meeting.id
    );
    meeting.agenda_items.append(item1);
    
    # Add tasks
    task1 = create_task(
        "Create user stories",
        "Alice",
        "2024-02-05",
        item1.id
    );
    item1.tasks.append(task1);
    
    # Schedule and track
    auto_schedule_agenda_items(meeting, calendar_events, "2024-02-02");
    update_task_progress(task1, 50);
    
    # Generate report
    print_summary(meetings, calendar_events);
}
```

## Data Persistence

All meeting data is saved to `meeting_data.json` in a structured format:

```json
{
  "meetings": [
    {
      "id": "meeting_...",
      "title": "Q1 Planning Meeting",
      "date": "2024-01-15",
      "attendees": ["Alice", "Bob", "Charlie"],
      "agenda_items": [...],
      "notes": ""
    }
  ],
  "calendar_events": [...]
}
```

## Technologies Used

- **Jaclang** - Modern programming language for AI applications
- **ByLLM** (Optional) - AI/LLM integration library
- **Python** - Standard library for date/time, JSON

## Contributing

This is a demonstration project showcasing Jaclang capabilities. Feel free to:
- Add new features
- Enhance AI integration
- Create a web interface
- Add database persistence
- Implement user authentication

## License

MIT License - Feel free to use and modify

## Support

For Jaclang documentation: https://www.jac-lang.org
For issues: Open an issue on GitHub
