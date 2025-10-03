"""
Meeting Minutes Management System
A comprehensive app for taking minutes, scheduling, and tracking progress
Built with Jaclang
"""

import datetime;
import json;
import time;

# Data Models

obj Meeting {
    has id: str;
    has title: str;
    has date: str;
    has attendees: list;
    has agenda_items: list;
    has notes: str;
}

obj AgendaItem {
    has id: str;
    has title: str;
    has description: str;
    has duration: int;
    has meeting_id: str;
    has status: str;
    has tasks: list;
    has scheduled_date: str;
}

obj Task {
    has id: str;
    has title: str;
    has assignee: str;
    has deadline: str;
    has agenda_item_id: str;
    has status: str;
    has progress: int;
    has notes: str;
}

obj CalendarEvent {
    has id: str;
    has title: str;
    has date: str;
    has duration: int;
    has event_type: str;
    has related_id: str;
    has notes: str;
}

# Helper functions

def create_meeting(title: str, date: str, attendees: list) -> Meeting {
    meeting = Meeting(
        id = "meeting_" + str(time.time()),
        title = title,
        date = date,
        attendees = attendees,
        agenda_items = [],
        notes = ""
    );
    return meeting;
}

def create_agenda_item(title: str, description: str, duration: int, meeting_id: str) -> AgendaItem {
    item = AgendaItem(
        id = "agenda_" + str(time.time()),
        title = title,
        description = description,
        duration = duration,
        meeting_id = meeting_id,
        status = "pending",
        tasks = [],
        scheduled_date = ""
    );
    return item;
}

def create_task(title: str, assignee: str, deadline: str, agenda_item_id: str) -> Task {
    task = Task(
        id = "task_" + str(time.time()),
        title = title,
        assignee = assignee,
        deadline = deadline,
        agenda_item_id = agenda_item_id,
        status = "todo",
        progress = 0,
        notes = ""
    );
    return task;
}

def create_calendar_event(title: str, date: str, duration: int, event_type: str, related_id: str) -> CalendarEvent {
    event = CalendarEvent(
        id = "event_" + str(time.time()),
        title = title,
        date = date,
        duration = duration,
        event_type = event_type,
        related_id = related_id,
        notes = ""
    );
    return event;
}

def update_task_progress(task: Task, new_progress: int) {
    task.progress = new_progress;
    if new_progress >= 100 {
        task.status = "completed";
    } elif new_progress > 0 {
        task.status = "in_progress";
    }
}

def schedule_agenda_item(item: AgendaItem, date: str) {
    item.scheduled_date = date;
    item.status = "scheduled";
}

def get_all_tasks(meetings: list) -> list {
    all_tasks = [];
    for meeting in meetings {
        for item in meeting.agenda_items {
            all_tasks.extend(item.tasks);
        }
    }
    return all_tasks;
}

def get_tasks_by_status(meetings: list, status: str) -> list {
    all_tasks = get_all_tasks(meetings);
    return [task for task in all_tasks if task.status == status];
}

def get_tasks_by_assignee(meetings: list, assignee: str) -> list {
    all_tasks = get_all_tasks(meetings);
    return [task for task in all_tasks if task.assignee == assignee];
}

def get_calendar_events_by_date(events: list, date: str) -> list {
    return [event for event in events if event.date == date];
}

def generate_progress_report(meetings: list) -> dict {
    all_tasks = get_all_tasks(meetings);
    total_tasks = len(all_tasks);
    
    if total_tasks == 0 {
        return {
            "total_tasks": 0,
            "completed": 0,
            "in_progress": 0,
            "todo": 0,
            "completion_percentage": 0
        };
    }
    
    completed = len([t for t in all_tasks if t.status == "completed"]);
    in_progress = len([t for t in all_tasks if t.status == "in_progress"]);
    todo = len([t for t in all_tasks if t.status == "todo"]);
    
    return {
        "total_tasks": total_tasks,
        "completed": completed,
        "in_progress": in_progress,
        "todo": todo,
        "completion_percentage": (completed / total_tasks) * 100
    };
}

def auto_schedule_agenda_items(meeting: Meeting, calendar_events: list, start_date: str) {
    current_date = datetime.datetime.strptime(start_date, "%Y-%m-%d");
    
    for item in meeting.agenda_items {
        item_date = current_date.strftime("%Y-%m-%d");
        schedule_agenda_item(item, item_date);
        
        event = create_calendar_event(
            "Follow-up: " + item.title,
            item_date,
            item.duration,
            "agenda_item",
            item.id
        );
        calendar_events.append(event);
        
        current_date = current_date + datetime.timedelta(days=1);
    }
}

def save_to_file(meetings: list, events: list, filename: str) {
    def meeting_to_dict(m: Meeting) -> dict {
        return {
            "id": m.id,
            "title": m.title,
            "date": m.date,
            "attendees": m.attendees,
            "notes": m.notes,
            "agenda_items": [agenda_to_dict(item) for item in m.agenda_items]
        };
    }
    
    def agenda_to_dict(item: AgendaItem) -> dict {
        return {
            "id": item.id,
            "title": item.title,
            "description": item.description,
            "duration": item.duration,
            "meeting_id": item.meeting_id,
            "status": item.status,
            "scheduled_date": item.scheduled_date,
            "tasks": [task_to_dict(task) for task in item.tasks]
        };
    }
    
    def task_to_dict(t: Task) -> dict {
        return {
            "id": t.id,
            "title": t.title,
            "assignee": t.assignee,
            "deadline": t.deadline,
            "agenda_item_id": t.agenda_item_id,
            "status": t.status,
            "progress": t.progress,
            "notes": t.notes
        };
    }
    
    def event_to_dict(e: CalendarEvent) -> dict {
        return {
            "id": e.id,
            "title": e.title,
            "date": e.date,
            "duration": e.duration,
            "event_type": e.event_type,
            "related_id": e.related_id,
            "notes": e.notes
        };
    }
    
    data = {
        "meetings": [meeting_to_dict(m) for m in meetings],
        "calendar_events": [event_to_dict(e) for e in events]
    };
    
    with open(filename, 'w') as f {
        json.dump(data, f, indent=2);
    }
}

def print_summary(meetings: list, events: list) {
    print("\n=== Meeting Management System Summary ===");
    print("Total Meetings: " + str(len(meetings)));
    print("Total Calendar Events: " + str(len(events)));
    
    all_tasks = get_all_tasks(meetings);
    print("Total Tasks: " + str(len(all_tasks)));
    
    progress_report = generate_progress_report(meetings);
    print("\nProgress Report:");
    print("  Completed: " + str(progress_report["completed"]));
    print("  In Progress: " + str(progress_report["in_progress"]));
    print("  To Do: " + str(progress_report["todo"]));
    print("  Completion: " + str(round(progress_report["completion_percentage"], 1)) + "%");
    print("=" * 40);
}

# Example Usage
with entry {
    print("=== Meeting Minutes Management System ===");
    print("Built with Jaclang\n");
    
    # Data storage
    meetings = [];
    calendar_events = [];
    
    # Create a meeting
    meeting = create_meeting(
        "Q1 Planning Meeting",
        "2024-01-15",
        ["Alice", "Bob", "Charlie"]
    );
    meetings.append(meeting);
    
    # Auto-schedule meeting on calendar
    event = create_calendar_event(
        "Meeting: " + meeting.title,
        meeting.date,
        60,
        "meeting",
        meeting.id
    );
    calendar_events.append(event);
    
    print("Created meeting: " + meeting.title);
    
    # Add agenda items
    time.sleep(0.01);
    item1 = create_agenda_item(
        "Budget Review",
        "Review and approve Q1 budget allocation",
        60,
        meeting.id
    );
    meeting.agenda_items.append(item1);
    
    time.sleep(0.01);
    item2 = create_agenda_item(
        "Project Timeline",
        "Discuss project milestones and deadlines",
        45,
        meeting.id
    );
    meeting.agenda_items.append(item2);
    
    time.sleep(0.01);
    item3 = create_agenda_item(
        "Resource Allocation",
        "Assign team members to projects",
        30,
        meeting.id
    );
    meeting.agenda_items.append(item3);
    
    print("Added " + str(len(meeting.agenda_items)) + " agenda items");
    
    # Add tasks to agenda items
    time.sleep(0.01);
    task1 = create_task(
        "Prepare budget spreadsheet",
        "Alice",
        "2024-01-20",
        item1.id
    );
    item1.tasks.append(task1);
    
    time.sleep(0.01);
    task2 = create_task(
        "Create project timeline",
        "Bob",
        "2024-01-22",
        item2.id
    );
    item2.tasks.append(task2);
    
    time.sleep(0.01);
    task3 = create_task(
        "Review milestone dependencies",
        "Charlie",
        "2024-01-25",
        item2.id
    );
    item2.tasks.append(task3);
    
    time.sleep(0.01);
    task4 = create_task(
        "Update resource matrix",
        "Alice",
        "2024-01-18",
        item3.id
    );
    item3.tasks.append(task4);
    
    print("Added " + str(len(get_all_tasks(meetings))) + " tasks");
    
    # Auto-schedule agenda items on calendar
    auto_schedule_agenda_items(meeting, calendar_events, "2024-01-16");
    print("Auto-scheduled agenda items on calendar");
    
    # Update task progress
    update_task_progress(task1, 100);
    update_task_progress(task2, 50);
    update_task_progress(task3, 25);
    
    # Print summary
    print_summary(meetings, calendar_events);
    
    # Print to-do list
    print("\n=== To-Do List (Pending Tasks) ===");
    todo_tasks = get_tasks_by_status(meetings, "todo");
    for task in todo_tasks {
        print("- [" + task.status + "] " + task.title + " (Assignee: " + task.assignee + ", Due: " + task.deadline + ")");
    }
    
    print("\n=== In Progress Tasks ===");
    in_progress_tasks = get_tasks_by_status(meetings, "in_progress");
    for task in in_progress_tasks {
        print("- [" + str(task.progress) + "%] " + task.title + " (Assignee: " + task.assignee + ", Due: " + task.deadline + ")");
    }
    
    print("\n=== Completed Tasks ===");
    completed_tasks = get_tasks_by_status(meetings, "completed");
    for task in completed_tasks {
        print("- [✓] " + task.title + " (Assignee: " + task.assignee + ")");
    }
    
    # Print calendar events
    print("\n=== Calendar Events ===");
    for event in calendar_events {
        print("- " + event.date + ": " + event.title + " (" + str(event.duration) + " min)");
    }
    
    # Save to file
    save_to_file(meetings, calendar_events, "meeting_data.json");
    print("\n✓ Data saved to meeting_data.json");
}
