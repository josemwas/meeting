# API Documentation

This document provides detailed information about all the functions available in the Meeting Minutes Management System.

## Table of Contents
- [Core Functions (main.jac)](#core-functions-mainjac)
- [AI Assistant Functions (ai_assistant.jac)](#ai-assistant-functions-ai_assistantjac)
- [Data Models](#data-models)
- [Usage Examples](#usage-examples)

## Core Functions (main.jac)

### Meeting Management

#### `create_meeting(title: str, date: str, attendees: list) -> Meeting`
Creates a new meeting object.

**Parameters:**
- `title` (str): The title/name of the meeting
- `date` (str): Meeting date in format "YYYY-MM-DD"
- `attendees` (list): List of attendee names (strings)

**Returns:** Meeting object

**Example:**
```jaclang
meeting = create_meeting(
    "Sprint Planning",
    "2024-02-15",
    ["Alice", "Bob", "Charlie"]
);
```

---

#### `create_agenda_item(title: str, description: str, duration: int, meeting_id: str) -> AgendaItem`
Creates an agenda item for a meeting.

**Parameters:**
- `title` (str): Agenda item title
- `description` (str): Detailed description
- `duration` (int): Duration in minutes
- `meeting_id` (str): ID of the parent meeting

**Returns:** AgendaItem object

**Example:**
```jaclang
item = create_agenda_item(
    "Sprint Goals",
    "Define objectives for the sprint",
    30,
    meeting.id
);
```

---

#### `create_task(title: str, assignee: str, deadline: str, agenda_item_id: str) -> Task`
Creates a task associated with an agenda item.

**Parameters:**
- `title` (str): Task title
- `assignee` (str): Person responsible for the task
- `deadline` (str): Deadline in format "YYYY-MM-DD"
- `agenda_item_id` (str): ID of the parent agenda item

**Returns:** Task object

**Example:**
```jaclang
task = create_task(
    "Prepare user stories",
    "Alice",
    "2024-02-20",
    item.id
);
```

---

#### `create_calendar_event(title: str, date: str, duration: int, event_type: str, related_id: str) -> CalendarEvent`
Creates a calendar event.

**Parameters:**
- `title` (str): Event title
- `date` (str): Event date in format "YYYY-MM-DD"
- `duration` (int): Duration in minutes
- `event_type` (str): Type of event ("meeting", "agenda_item", etc.)
- `related_id` (str): ID of related object

**Returns:** CalendarEvent object

---

### Task Management

#### `update_task_progress(task: Task, new_progress: int)`
Updates a task's progress and automatically updates its status.

**Parameters:**
- `task` (Task): The task object to update
- `new_progress` (int): Progress percentage (0-100)

**Side effects:**
- Sets status to "completed" if progress >= 100
- Sets status to "in_progress" if 0 < progress < 100
- Keeps status as "todo" if progress == 0

**Example:**
```jaclang
update_task_progress(task, 75);  # Task is now "in_progress" at 75%
```

---

#### `get_all_tasks(meetings: list) -> list`
Retrieves all tasks across all meetings.

**Parameters:**
- `meetings` (list): List of Meeting objects

**Returns:** List of all Task objects

---

#### `get_tasks_by_status(meetings: list, status: str) -> list`
Filters tasks by their status.

**Parameters:**
- `meetings` (list): List of Meeting objects
- `status` (str): Status to filter by ("todo", "in_progress", "completed")

**Returns:** List of matching Task objects

---

#### `get_tasks_by_assignee(meetings: list, assignee: str) -> list`
Filters tasks by assignee.

**Parameters:**
- `meetings` (list): List of Meeting objects
- `assignee` (str): Name of the assignee

**Returns:** List of Task objects assigned to the specified person

---

### Calendar Functions

#### `auto_schedule_agenda_items(meeting: Meeting, calendar_events: list, start_date: str)`
Automatically schedules all agenda items from a meeting on consecutive days.

**Parameters:**
- `meeting` (Meeting): The meeting containing agenda items
- `calendar_events` (list): List to append new calendar events to
- `start_date` (str): Starting date in format "YYYY-MM-DD"

**Side effects:**
- Creates calendar events for each agenda item
- Updates agenda item status to "scheduled"
- Sets the scheduled_date for each agenda item

---

#### `get_calendar_events_by_date(events: list, date: str) -> list`
Retrieves all calendar events for a specific date.

**Parameters:**
- `events` (list): List of CalendarEvent objects
- `date` (str): Date in format "YYYY-MM-DD"

**Returns:** List of CalendarEvent objects for that date

---

### Reporting Functions

#### `generate_progress_report(meetings: list) -> dict`
Generates statistics about task completion.

**Parameters:**
- `meetings` (list): List of Meeting objects

**Returns:** Dictionary with keys:
- `total_tasks` (int): Total number of tasks
- `completed` (int): Number of completed tasks
- `in_progress` (int): Number of in-progress tasks
- `todo` (int): Number of todo tasks
- `completion_percentage` (float): Percentage of completed tasks

---

#### `print_summary(meetings: list, events: list)`
Prints a formatted summary to console.

**Parameters:**
- `meetings` (list): List of Meeting objects
- `events` (list): List of CalendarEvent objects

**Output:** Prints meeting count, calendar events, tasks, and progress report

---

### Persistence Functions

#### `save_to_file(meetings: list, events: list, filename: str)`
Saves all data to a JSON file.

**Parameters:**
- `meetings` (list): List of Meeting objects
- `events` (list): List of CalendarEvent objects
- `filename` (str): Path to save file

**Example:**
```jaclang
save_to_file(meetings, calendar_events, "meeting_data.json");
```

---

## AI Assistant Functions (ai_assistant.jac)

### Utility Functions

#### `is_ai_available() -> bool`
Checks if an AI API key is configured.

**Returns:** `True` if OPENAI_API_KEY or ANTHROPIC_API_KEY is set

---

#### `get_model_name() -> str`
Gets the configured AI model name.

**Returns:** 
- "gpt-4o-mini" if OpenAI key is set
- "claude-3-sonnet-20240229" if Anthropic key is set
- "" if no key is set

---

### AI-Powered Functions

#### `generate_meeting_summary(meeting_title: str, notes: str) -> str`
Generates an AI summary of a meeting.

**Parameters:**
- `meeting_title` (str): Title of the meeting
- `notes` (str): Meeting notes to summarize

**Returns:** Summary string

**Behavior:**
- With AI: Generates concise AI summary with key points
- Without AI: Returns placeholder message

**Example:**
```jaclang
summary = generate_meeting_summary(
    "Q1 Planning",
    "We discussed budget, timeline, and resources..."
);
print(summary);
```

---

#### `extract_tasks_from_notes(notes: str) -> list`
Extracts action items and tasks from meeting notes.

**Parameters:**
- `notes` (str): Meeting notes text

**Returns:** List of task strings

**Behavior:**
- With AI: Uses LLM to intelligently extract tasks
- Without AI: Uses keyword matching ("will", "needs to", "should", etc.)

**Example:**
```jaclang
notes = "Alice will prepare the report. Bob needs to review the code.";
tasks = extract_tasks_from_notes(notes);
for task in tasks {
    print("- " + task);
}
```

---

#### `suggest_agenda_items(meeting_title: str, meeting_purpose: str) -> list`
Suggests agenda items for a meeting.

**Parameters:**
- `meeting_title` (str): Title of the meeting
- `meeting_purpose` (str): Purpose or goal of the meeting

**Returns:** List of suggested agenda item strings (5-7 items)

**Behavior:**
- With AI: Generates context-aware suggestions
- Without AI: Returns template-based suggestions

**Example:**
```jaclang
agenda = suggest_agenda_items(
    "Sprint Planning",
    "plan next sprint and estimate stories"
);
```

---

#### `suggest_task_priority(task_title: str, task_description: str, deadline: str) -> str`
Recommends a priority level for a task.

**Parameters:**
- `task_title` (str): Title of the task
- `task_description` (str): Description of what needs to be done
- `deadline` (str): Task deadline

**Returns:** One of "High", "Medium", or "Low"

**Behavior:**
- With AI: Considers context, urgency, and complexity
- Without AI: Uses keyword-based heuristics

**Example:**
```jaclang
priority = suggest_task_priority(
    "Fix critical bug",
    "Production system is down",
    "2024-02-16"
);
print("Priority: " + priority);  # Likely "High"
```

---

#### `enhance_meeting_notes(raw_notes: str) -> str`
Enhances and structures meeting notes.

**Parameters:**
- `raw_notes` (str): Raw, unformatted notes

**Returns:** Formatted and structured notes

**Behavior:**
- With AI: Reorganizes into sections with bullet points
- Without AI: Adds basic formatting

---

## Data Models

### Meeting
```jaclang
obj Meeting {
    has id: str;              # Unique identifier
    has title: str;           # Meeting title
    has date: str;            # Date (YYYY-MM-DD)
    has attendees: list;      # List of attendee names
    has agenda_items: list;   # List of AgendaItem objects
    has notes: str;           # General meeting notes
}
```

### AgendaItem
```jaclang
obj AgendaItem {
    has id: str;              # Unique identifier
    has title: str;           # Item title
    has description: str;     # Item description
    has duration: int;        # Duration in minutes
    has meeting_id: str;      # Parent meeting ID
    has status: str;          # "pending" or "scheduled"
    has tasks: list;          # List of Task objects
    has scheduled_date: str;  # Date when scheduled
}
```

### Task
```jaclang
obj Task {
    has id: str;              # Unique identifier
    has title: str;           # Task title
    has assignee: str;        # Person responsible
    has deadline: str;        # Deadline (YYYY-MM-DD)
    has agenda_item_id: str;  # Parent agenda item ID
    has status: str;          # "todo", "in_progress", "completed"
    has progress: int;        # Progress percentage (0-100)
    has notes: str;           # Additional notes
}
```

### CalendarEvent
```jaclang
obj CalendarEvent {
    has id: str;              # Unique identifier
    has title: str;           # Event title
    has date: str;            # Event date (YYYY-MM-DD)
    has duration: int;        # Duration in minutes
    has event_type: str;      # Type ("meeting", "agenda_item")
    has related_id: str;      # ID of related object
    has notes: str;           # Additional notes
}
```

## Usage Examples

### Example 1: Create a Complete Meeting

```jaclang
import main;

with entry {
    meetings = [];
    calendar_events = [];
    
    # Create meeting
    meeting = main.create_meeting(
        "Team Sync",
        "2024-02-15",
        ["Alice", "Bob", "Charlie"]
    );
    meetings.append(meeting);
    
    # Add agenda item
    item = main.create_agenda_item(
        "Sprint Review",
        "Review completed work",
        45,
        meeting.id
    );
    meeting.agenda_items.append(item);
    
    # Add task
    task = main.create_task(
        "Prepare demo",
        "Alice",
        "2024-02-14",
        item.id
    );
    item.tasks.append(task);
    
    # Update progress
    main.update_task_progress(task, 50);
    
    # Generate report
    main.print_summary(meetings, calendar_events);
}
```

### Example 2: Use AI Features

```jaclang
import ai_assistant;

with entry {
    # Extract tasks from notes
    notes = "Alice will create the slides. Bob needs to book the room.";
    tasks = ai_assistant.extract_tasks_from_notes(notes);
    
    # Suggest agenda
    agenda = ai_assistant.suggest_agenda_items(
        "Planning Meeting",
        "plan Q2 objectives"
    );
    
    # Get priority
    priority = ai_assistant.suggest_task_priority(
        "Update documentation",
        "Technical docs need updating",
        "2024-03-01"
    );
}
```

### Example 3: Filter and Report

```jaclang
import main;

with entry {
    # Assuming meetings is populated...
    
    # Get all incomplete tasks
    todo = main.get_tasks_by_status(meetings, "todo");
    in_progress = main.get_tasks_by_status(meetings, "in_progress");
    
    # Get tasks by person
    alice_tasks = main.get_tasks_by_assignee(meetings, "Alice");
    
    # Generate metrics
    report = main.generate_progress_report(meetings);
    print("Completion: " + str(report["completion_percentage"]) + "%");
}
```

## Notes

- All date fields use ISO 8601 format: "YYYY-MM-DD"
- Task progress is 0-100 (integer)
- IDs are auto-generated using timestamps
- AI functions gracefully degrade to fallback implementations when no API key is present
- All functions handle empty lists safely
