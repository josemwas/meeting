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
- Git (optional, for cloning the repository)

### Step-by-Step Setup Guide

1. **Clone or download this repository:**
```bash
git clone https://github.com/josemwas/meeting.git
cd meeting
```

Or download and extract the ZIP file from GitHub.

2. **Install dependencies:**

   **Option A: Using pip with requirements.txt (recommended)**
```bash
pip install -r requirements.txt
```

   **Option B: Manual installation**
```bash
# Install Jaclang
pip install jaclang

# Install ByLLM for AI features
pip install byllm
```

3. **Configure AI features (optional but recommended):**

   To enable AI-powered features, you need to set up an API key from either OpenAI or Anthropic.

   **For OpenAI (GPT models):**
```bash
export OPENAI_API_KEY='your-openai-api-key-here'
```

   **For Anthropic (Claude models):**
```bash
export ANTHROPIC_API_KEY='your-anthropic-api-key-here'
```

   **Note:** You only need ONE of the above API keys. The system will automatically detect which one is available.

   **To get an API key:**
   - OpenAI: Visit https://platform.openai.com/api-keys
   - Anthropic: Visit https://console.anthropic.com/

   **Windows users:** Use `set` instead of `export`:
```cmd
set OPENAI_API_KEY=your-openai-api-key-here
```

   **To make the key permanent (Linux/Mac):**
   Add the export command to your `~/.bashrc` or `~/.zshrc` file.

4. **Verify installation:**
```bash
# Test if Jaclang is installed
jac --version

# Test the main application
jac run main.jac

# Test the AI assistant (with or without API key)
jac run ai_assistant.jac
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

### Running the Example Workflow

```bash
jac run example.jac
```

This demonstrates a realistic Sprint Planning meeting with:
- Multiple agenda items with durations
- Task assignments to team members
- Progress tracking and status updates
- Detailed reporting by assignee and agenda

### Running the AI Assistant

```bash
jac run ai_assistant.jac
```

This demonstrates AI-powered features including:
- Task extraction from notes
- Agenda item suggestions
- Task priority recommendations

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
├── example.jac           # Example workflow (Sprint Planning demo)
├── meeting_data.json     # Generated data file (created on first run)
├── .gitignore           # Git ignore rules
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

The AI assistant module (`ai_assistant.jac`) provides intelligent automation using ByLLM:

### Available AI Functions
- `generate_meeting_summary(title, notes)` - Auto-summarize meetings
- `extract_tasks_from_notes(notes)` - Extract action items from notes
- `suggest_agenda_items(title, purpose)` - Suggest agenda based on meeting purpose
- `suggest_task_priority(title, description, deadline)` - Recommend task priority
- `enhance_meeting_notes(notes)` - Structure and enhance notes

### How It Works

The AI assistant uses ByLLM (https://github.com/Jaseci-Labs/byllm), which provides a unified interface to multiple LLM providers through LiteLLM.

**Supported Models:**
- OpenAI: GPT-4, GPT-4o-mini (default), GPT-3.5-turbo
- Anthropic: Claude 3 Sonnet, Claude 3 Opus, Claude 3 Haiku
- And many more through LiteLLM

**Current Configuration:**
- With `OPENAI_API_KEY`: Uses `gpt-4o-mini` (fast, cost-effective)
- With `ANTHROPIC_API_KEY`: Uses `claude-3-sonnet-20240229` (powerful, balanced)

### Using AI Features

The system automatically detects if an API key is set and enables AI features accordingly.

**Without API key:**
- Functions use simple heuristic-based fallbacks
- Task extraction uses keyword matching
- Agenda suggestions use templates
- Priority assignment uses rule-based logic

**With API key:**
- Full AI-powered intelligent assistance
- Context-aware task extraction
- Smart agenda suggestions
- Intelligent priority recommendations

**Example Usage:**
```bash
# Set your API key (choose one)
export OPENAI_API_KEY='sk-...'  # For OpenAI
# OR
export ANTHROPIC_API_KEY='sk-ant-...'  # For Anthropic

# Run the AI assistant demo
jac run ai_assistant.jac

# The demo will show:
# - Task extraction from meeting notes
# - Agenda item suggestions
# - Meeting summary generation
# - Task priority recommendations
```

### Customizing the AI Model

To use a different model, edit `ai_assistant.jac` and modify the `get_model_name()` function:

```jaclang
def get_model_name() -> str {
    if "OPENAI_API_KEY" in os.environ {
        return "gpt-4";  # Change to your preferred OpenAI model
    } elif "ANTHROPIC_API_KEY" in os.environ {
        return "claude-3-opus-20240229";  # Change to your preferred Anthropic model
    }
    return "";
}
```

### Integration Example

You can easily integrate AI features into the main meeting management workflow:

```jaclang
import ai_assistant;
import main;

with entry {
    # Create a meeting
    meeting = main.create_meeting("Sprint Planning", "2024-02-01", ["Alice", "Bob"]);
    
    # Add meeting notes
    meeting.notes = "We discussed the sprint goals. Alice will create user stories. Bob will set up the development environment.";
    
    # Use AI to extract tasks
    tasks = ai_assistant.extract_tasks_from_notes(meeting.notes);
    print("AI-extracted tasks:");
    for task in tasks {
        print("  - " + task);
    }
    
    # Use AI to suggest agenda
    agenda = ai_assistant.suggest_agenda_items(meeting.title, "sprint planning");
    for item in agenda {
        print("  - " + item);
    }
}
```

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
