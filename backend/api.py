"""
FastAPI REST API Backend for Meeting Minutes Management System
Exposes the Jaclang functionality through HTTP endpoints
"""

from fastapi import FastAPI, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel
from typing import List, Optional
import subprocess
import json
import os
from pathlib import Path

app = FastAPI(
    title="Meeting Minutes Management API",
    description="REST API for managing meeting minutes, tasks, and calendar events",
    version="1.0.0"
)

# Configure CORS to allow requests from the frontend
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # In production, specify actual frontend URLs
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Data file path
DATA_FILE = Path(__file__).parent.parent / "meeting_web_data.json"

# Pydantic models for request/response validation
class MeetingCreate(BaseModel):
    title: str
    date: str
    attendees: List[str]

class Meeting(BaseModel):
    id: str
    title: str
    date: str
    attendees: List[str]
    agenda_items: List[dict] = []
    notes: str = ""

class AgendaItemCreate(BaseModel):
    title: str
    description: str
    duration: int
    meeting_id: str

class AgendaItem(BaseModel):
    id: str
    title: str
    description: str
    duration: int
    meeting_id: str
    status: str
    tasks: List[dict] = []
    scheduled_date: str = ""

class TaskCreate(BaseModel):
    title: str
    assignee: str
    deadline: str
    agenda_item_id: str

class Task(BaseModel):
    id: str
    title: str
    assignee: str
    deadline: str
    agenda_item_id: str
    status: str
    progress: int
    notes: str = ""

class TaskUpdate(BaseModel):
    status: Optional[str] = None
    progress: Optional[int] = None
    notes: Optional[str] = None

class CalendarEvent(BaseModel):
    id: str
    title: str
    date: str
    duration: int
    event_type: str
    related_id: str
    notes: str = ""

# Helper functions to interact with data
def load_data():
    """Load data from JSON file"""
    if DATA_FILE.exists():
        with open(DATA_FILE, 'r') as f:
            return json.load(f)
    return {"meetings": [], "calendar_events": [], "tasks": []}

def save_data(data):
    """Save data to JSON file"""
    with open(DATA_FILE, 'w') as f:
        json.dump(data, f, indent=2)

def generate_id(prefix: str):
    """Generate a unique ID"""
    import time
    return f"{prefix}_{int(time.time() * 1000)}"

# API Endpoints

@app.get("/")
def read_root():
    """Root endpoint"""
    return {
        "message": "Meeting Minutes Management API",
        "version": "1.0.0",
        "docs": "/docs"
    }

@app.get("/api/meetings", response_model=List[Meeting])
def get_meetings():
    """Get all meetings"""
    data = load_data()
    return data.get("meetings", [])

@app.post("/api/meetings", response_model=Meeting)
def create_meeting(meeting: MeetingCreate):
    """Create a new meeting"""
    data = load_data()
    
    new_meeting = {
        "id": generate_id("meeting"),
        "title": meeting.title,
        "date": meeting.date,
        "attendees": meeting.attendees,
        "agenda_items": [],
        "notes": ""
    }
    
    data["meetings"].append(new_meeting)
    save_data(data)
    
    return new_meeting

@app.get("/api/meetings/{meeting_id}", response_model=Meeting)
def get_meeting(meeting_id: str):
    """Get a specific meeting by ID"""
    data = load_data()
    
    for meeting in data.get("meetings", []):
        if meeting["id"] == meeting_id:
            return meeting
    
    raise HTTPException(status_code=404, detail="Meeting not found")

@app.delete("/api/meetings/{meeting_id}")
def delete_meeting(meeting_id: str):
    """Delete a meeting"""
    data = load_data()
    
    meetings = data.get("meetings", [])
    for i, meeting in enumerate(meetings):
        if meeting["id"] == meeting_id:
            del meetings[i]
            save_data(data)
            return {"message": "Meeting deleted successfully"}
    
    raise HTTPException(status_code=404, detail="Meeting not found")

@app.post("/api/agenda-items", response_model=AgendaItem)
def create_agenda_item(item: AgendaItemCreate):
    """Create a new agenda item"""
    data = load_data()
    
    # Find the meeting
    meeting_found = False
    for meeting in data.get("meetings", []):
        if meeting["id"] == item.meeting_id:
            meeting_found = True
            new_item = {
                "id": generate_id("agenda"),
                "title": item.title,
                "description": item.description,
                "duration": item.duration,
                "meeting_id": item.meeting_id,
                "status": "pending",
                "tasks": [],
                "scheduled_date": ""
            }
            
            meeting["agenda_items"].append(new_item)
            save_data(data)
            return new_item
    
    if not meeting_found:
        raise HTTPException(status_code=404, detail="Meeting not found")

@app.get("/api/agenda-items")
def get_agenda_items(meeting_id: Optional[str] = None):
    """Get all agenda items, optionally filtered by meeting_id"""
    data = load_data()
    all_items = []
    
    for meeting in data.get("meetings", []):
        if meeting_id is None or meeting["id"] == meeting_id:
            all_items.extend(meeting.get("agenda_items", []))
    
    return all_items

@app.post("/api/tasks", response_model=Task)
def create_task(task: TaskCreate):
    """Create a new task"""
    data = load_data()
    
    # Find the agenda item
    item_found = False
    for meeting in data.get("meetings", []):
        for agenda_item in meeting.get("agenda_items", []):
            if agenda_item["id"] == task.agenda_item_id:
                item_found = True
                new_task = {
                    "id": generate_id("task"),
                    "title": task.title,
                    "assignee": task.assignee,
                    "deadline": task.deadline,
                    "agenda_item_id": task.agenda_item_id,
                    "status": "todo",
                    "progress": 0,
                    "notes": ""
                }
                
                agenda_item["tasks"].append(new_task)
                
                # Also add to global tasks list
                if "tasks" not in data:
                    data["tasks"] = []
                data["tasks"].append(new_task)
                
                save_data(data)
                return new_task
    
    if not item_found:
        raise HTTPException(status_code=404, detail="Agenda item not found")

@app.get("/api/tasks", response_model=List[Task])
def get_tasks(status: Optional[str] = None, assignee: Optional[str] = None):
    """Get all tasks, optionally filtered by status or assignee"""
    data = load_data()
    all_tasks = []
    
    # Collect all tasks from agenda items
    for meeting in data.get("meetings", []):
        for agenda_item in meeting.get("agenda_items", []):
            all_tasks.extend(agenda_item.get("tasks", []))
    
    # Apply filters
    if status:
        all_tasks = [t for t in all_tasks if t["status"] == status]
    if assignee:
        all_tasks = [t for t in all_tasks if t["assignee"] == assignee]
    
    return all_tasks

@app.patch("/api/tasks/{task_id}", response_model=Task)
def update_task(task_id: str, update: TaskUpdate):
    """Update a task's status, progress, or notes"""
    data = load_data()
    
    # Find and update the task
    for meeting in data.get("meetings", []):
        for agenda_item in meeting.get("agenda_items", []):
            for task in agenda_item.get("tasks", []):
                if task["id"] == task_id:
                    if update.status is not None:
                        task["status"] = update.status
                    if update.progress is not None:
                        task["progress"] = update.progress
                    if update.notes is not None:
                        task["notes"] = update.notes
                    
                    save_data(data)
                    return task
    
    raise HTTPException(status_code=404, detail="Task not found")

@app.get("/api/calendar-events", response_model=List[CalendarEvent])
def get_calendar_events():
    """Get all calendar events"""
    data = load_data()
    return data.get("calendar_events", [])

@app.post("/api/calendar-events/auto-schedule/{meeting_id}")
def auto_schedule_meeting(meeting_id: str):
    """Auto-schedule agenda items for a meeting"""
    data = load_data()
    
    # Find the meeting
    meeting = None
    for m in data.get("meetings", []):
        if m["id"] == meeting_id:
            meeting = m
            break
    
    if not meeting:
        raise HTTPException(status_code=404, detail="Meeting not found")
    
    # Create calendar events
    if "calendar_events" not in data:
        data["calendar_events"] = []
    
    # Add meeting event
    meeting_event = {
        "id": generate_id("event"),
        "title": f"Meeting: {meeting['title']}",
        "date": meeting["date"],
        "duration": sum(item.get("duration", 0) for item in meeting.get("agenda_items", [])),
        "event_type": "meeting",
        "related_id": meeting_id,
        "notes": ""
    }
    data["calendar_events"].append(meeting_event)
    
    # Add follow-up events for agenda items
    from datetime import datetime, timedelta
    base_date = datetime.strptime(meeting["date"], "%Y-%m-%d")
    
    for i, item in enumerate(meeting.get("agenda_items", []), 1):
        follow_up_date = (base_date + timedelta(days=i)).strftime("%Y-%m-%d")
        item["scheduled_date"] = follow_up_date
        
        event = {
            "id": generate_id("event"),
            "title": f"Follow-up: {item['title']}",
            "date": follow_up_date,
            "duration": item.get("duration", 30),
            "event_type": "follow-up",
            "related_id": item["id"],
            "notes": ""
        }
        data["calendar_events"].append(event)
    
    save_data(data)
    
    return {"message": "Meeting scheduled successfully", "events": len(data["calendar_events"])}

@app.get("/api/summary")
def get_summary():
    """Get summary statistics"""
    data = load_data()
    
    # Collect all tasks
    all_tasks = []
    for meeting in data.get("meetings", []):
        for agenda_item in meeting.get("agenda_items", []):
            all_tasks.extend(agenda_item.get("tasks", []))
    
    # Calculate statistics
    total_tasks = len(all_tasks)
    completed = sum(1 for t in all_tasks if t["status"] == "completed")
    in_progress = sum(1 for t in all_tasks if t["status"] == "in_progress")
    todo = sum(1 for t in all_tasks if t["status"] == "todo")
    
    completion_rate = (completed / total_tasks * 100) if total_tasks > 0 else 0
    
    return {
        "total_meetings": len(data.get("meetings", [])),
        "total_calendar_events": len(data.get("calendar_events", [])),
        "total_tasks": total_tasks,
        "tasks_completed": completed,
        "tasks_in_progress": in_progress,
        "tasks_todo": todo,
        "completion_rate": round(completion_rate, 1)
    }

if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=8000)
