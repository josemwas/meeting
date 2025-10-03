"""
Example: Custom Meeting Workflow
This example shows how to create your own meeting workflow
"""

import datetime;
import json;
import time;

# Import the data models and helper functions from main
# (In a real project, you'd organize these in separate modules)

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

# Helper functions (simplified versions)
def create_meeting(title: str, date: str, attendees: list) -> Meeting {
    return Meeting(
        id = "meeting_" + str(time.time()),
        title = title,
        date = date,
        attendees = attendees,
        agenda_items = [],
        notes = ""
    );
}

def create_agenda_item(title: str, description: str, duration: int, meeting_id: str) -> AgendaItem {
    return AgendaItem(
        id = "agenda_" + str(time.time()),
        title = title,
        description = description,
        duration = duration,
        meeting_id = meeting_id,
        status = "pending",
        tasks = [],
        scheduled_date = ""
    );
}

def create_task(title: str, assignee: str, deadline: str, agenda_item_id: str) -> Task {
    return Task(
        id = "task_" + str(time.time()),
        title = title,
        assignee = assignee,
        deadline = deadline,
        agenda_item_id = agenda_item_id,
        status = "todo",
        progress = 0,
        notes = ""
    );
}

# Example workflow
with entry {
    print("=== Custom Meeting Workflow Example ===\n");
    
    # Step 1: Create a Sprint Planning meeting
    print("1. Creating Sprint Planning meeting...");
    meeting = create_meeting(
        "Sprint 23 Planning",
        "2024-02-01",
        ["Alice", "Bob", "Charlie", "Diana", "Eve"]
    );
    
    # Step 2: Add structured agenda items
    print("2. Adding agenda items...");
    
    time.sleep(0.01);
    sprint_goals = create_agenda_item(
        "Sprint Goals & Objectives",
        "Review and define sprint goals based on product roadmap",
        30,
        meeting.id
    );
    meeting.agenda_items.append(sprint_goals);
    
    time.sleep(0.01);
    capacity = create_agenda_item(
        "Team Capacity Planning",
        "Assess team availability and velocity",
        20,
        meeting.id
    );
    meeting.agenda_items.append(capacity);
    
    time.sleep(0.01);
    user_stories = create_agenda_item(
        "User Stories Review",
        "Review and estimate user stories for the sprint",
        60,
        meeting.id
    );
    meeting.agenda_items.append(user_stories);
    
    time.sleep(0.01);
    retrospective = create_agenda_item(
        "Previous Sprint Retrospective",
        "Quick review of what went well and what to improve",
        25,
        meeting.id
    );
    meeting.agenda_items.append(retrospective);
    
    # Step 3: Add actionable tasks
    print("3. Creating action items...");
    
    time.sleep(0.01);
    task1 = create_task(
        "Update sprint backlog in Jira",
        "Alice",
        "2024-02-02",
        sprint_goals.id
    );
    sprint_goals.tasks.append(task1);
    
    time.sleep(0.01);
    task2 = create_task(
        "Create velocity chart",
        "Bob",
        "2024-02-03",
        capacity.id
    );
    capacity.tasks.append(task2);
    
    time.sleep(0.01);
    task3 = create_task(
        "Break down epic into user stories",
        "Charlie",
        "2024-02-05",
        user_stories.id
    );
    user_stories.tasks.append(task3);
    
    time.sleep(0.01);
    task4 = create_task(
        "Document retrospective findings",
        "Diana",
        "2024-02-02",
        retrospective.id
    );
    retrospective.tasks.append(task4);
    
    time.sleep(0.01);
    task5 = create_task(
        "Set up testing environment",
        "Eve",
        "2024-02-04",
        user_stories.id
    );
    user_stories.tasks.append(task5);
    
    # Step 4: Simulate task updates
    print("4. Updating task progress...");
    task1.progress = 100;
    task1.status = "completed";
    
    task2.progress = 75;
    task2.status = "in_progress";
    
    task3.progress = 30;
    task3.status = "in_progress";
    
    # Step 5: Add meeting notes
    meeting.notes = "Sprint Planning went well. Team is aligned on goals. " +
                    "Alice completed backlog update. Bob is making good progress on velocity chart. " +
                    "Charlie started breaking down the epic. Diana will document findings. " +
                    "Eve to focus on testing environment setup.";
    
    # Step 6: Display summary
    print("\n=== Meeting Summary ===");
    print("Title: " + meeting.title);
    print("Date: " + meeting.date);
    print("Attendees: " + str(len(meeting.attendees)));
    print("Agenda Items: " + str(len(meeting.agenda_items)));
    
    total_tasks = 0;
    for item in meeting.agenda_items {
        total_tasks = total_tasks + len(item.tasks);
    }
    print("Total Tasks: " + str(total_tasks));
    
    # Step 7: Show tasks by assignee
    print("\n=== Tasks by Assignee ===");
    assignees = ["Alice", "Bob", "Charlie", "Diana", "Eve"];
    for assignee in assignees {
        assignee_tasks = [];
        for item in meeting.agenda_items {
            for task in item.tasks {
                if task.assignee == assignee {
                    assignee_tasks.append(task);
                }
            }
        }
        
        if len(assignee_tasks) > 0 {
            print("\n" + assignee + ":");
            for task in assignee_tasks {
                status_icon = "✓" if task.status == "completed" else ("⚙" if task.status == "in_progress" else "○");
                print("  " + status_icon + " " + task.title + " (Due: " + task.deadline + ")");
                if task.progress > 0 {
                    print("    Progress: " + str(task.progress) + "%");
                }
            }
        }
    }
    
    # Step 8: Show agenda breakdown
    print("\n=== Agenda Breakdown ===");
    total_duration = 0;
    for item in meeting.agenda_items {
        print("\n" + item.title + " (" + str(item.duration) + " min)");
        print("  " + item.description);
        print("  Tasks: " + str(len(item.tasks)));
        total_duration = total_duration + item.duration;
    }
    print("\nTotal Meeting Duration: " + str(total_duration) + " minutes");
    
    # Step 9: Calculate progress metrics
    print("\n=== Progress Metrics ===");
    completed = 0;
    in_progress = 0;
    todo = 0;
    
    for item in meeting.agenda_items {
        for task in item.tasks {
            if task.status == "completed" {
                completed = completed + 1;
            } elif task.status == "in_progress" {
                in_progress = in_progress + 1;
            } else {
                todo = todo + 1;
            }
        }
    }
    
    if total_tasks > 0 {
        completion_rate = (completed / total_tasks) * 100;
        print("Completed: " + str(completed) + "/" + str(total_tasks) + " (" + str(round(completion_rate, 1)) + "%)");
        print("In Progress: " + str(in_progress));
        print("To Do: " + str(todo));
    }
    
    print("\n" + "=" * 50);
    print("Example workflow complete!");
    print("\nThis example demonstrates:");
    print("- Creating structured meetings");
    print("- Adding detailed agenda items");
    print("- Assigning tasks to team members");
    print("- Tracking progress");
    print("- Generating reports and summaries");
}
