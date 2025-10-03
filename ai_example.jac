"""
AI-Enhanced Meeting Example
Demonstrates how to integrate AI features into the meeting management system

This example shows how to use AI assistant functions alongside the core meeting
management functionality.

Note: Requires OPENAI_API_KEY or ANTHROPIC_API_KEY to be set for full functionality.
Without an API key, fallback implementations will be used.
"""

import main;
import ai_assistant;

with entry {
    print("=== AI-Enhanced Meeting Management Example ===\n");
    
    # Check if AI is available
    if ai_assistant.is_ai_available() {
        print("✅ AI features are ENABLED");
        print("   Using model: " + ai_assistant.get_model_name() + "\n");
    } else {
        print("ℹ️  AI features are DISABLED (using fallbacks)");
        print("   Set OPENAI_API_KEY or ANTHROPIC_API_KEY to enable AI\n");
    }
    
    # Initialize data structures
    meetings = [];
    calendar_events = [];
    
    # Step 1: Create a meeting
    print("Step 1: Creating a new meeting...");
    meeting = main.create_meeting(
        "Product Roadmap Planning",
        "2024-02-15",
        ["Alice", "Bob", "Charlie", "Diana"]
    );
    meetings.append(meeting);
    print("✓ Created meeting: " + meeting.title);
    
    # Step 2: Use AI to suggest agenda items
    print("\nStep 2: Using AI to suggest agenda items...");
    meeting_purpose = "planning next quarter product roadmap and prioritizing features";
    suggested_agenda = ai_assistant.suggest_agenda_items(meeting.title, meeting_purpose);
    
    print("AI suggested " + str(len(suggested_agenda)) + " agenda items:");
    idx = 1;
    for suggestion in suggested_agenda {
        print("  " + str(idx) + ". " + suggestion);
        idx = idx + 1;
    }
    
    # Add some of the suggested items to the meeting
    print("\nAdding first 3 suggestions as agenda items...");
    for i in range(min(3, len(suggested_agenda))) {
        item = main.create_agenda_item(
            suggested_agenda[i],
            "Discussion and planning for " + suggested_agenda[i],
            30 if i == 0 else 20,
            meeting.id
        );
        meeting.agenda_items.append(item);
    }
    print("✓ Added " + str(len(meeting.agenda_items)) + " agenda items");
    
    # Step 3: Add meeting notes
    print("\nStep 3: Adding meeting notes...");
    meeting.notes = """
    We started with a review of the current product state and market feedback. 
    Alice will lead the feature prioritization exercise using the RICE framework. 
    Bob needs to prepare technical feasibility assessments for the top 5 features by next Monday. 
    Charlie must coordinate with the design team to create mockups for the new dashboard.
    Diana will gather customer feedback through surveys and should present findings by end of week.
    We also discussed resource allocation and agreed to hire two more developers.
    The team must complete the roadmap draft before the board meeting on March 1st.
    """;
    print("✓ Added meeting notes (" + str(len(meeting.notes)) + " characters)");
    
    # Step 4: Use AI to extract tasks from notes
    print("\nStep 4: Using AI to extract tasks from meeting notes...");
    extracted_tasks = ai_assistant.extract_tasks_from_notes(meeting.notes);
    print("AI extracted " + str(len(extracted_tasks)) + " tasks:");
    for task_desc in extracted_tasks {
        print("  - " + task_desc);
    }
    
    # Step 5: Create tasks from AI extraction
    print("\nStep 5: Creating task objects from extracted tasks...");
    
    # Manually assign some tasks to team members based on the extraction
    if len(extracted_tasks) > 0 {
        # Task 1: Alice - Feature prioritization
        task1 = main.create_task(
            "Lead feature prioritization exercise",
            "Alice",
            "2024-02-20",
            meeting.agenda_items[0].id if len(meeting.agenda_items) > 0 else ""
        );
        priority1 = ai_assistant.suggest_task_priority(
            task1.title,
            "Use RICE framework for prioritization",
            task1.deadline
        );
        task1.notes = "Priority: " + priority1;
        if len(meeting.agenda_items) > 0 {
            meeting.agenda_items[0].tasks.append(task1);
        }
        print("  ✓ Task for Alice (Priority: " + priority1 + ")");
        
        # Task 2: Bob - Technical assessments
        task2 = main.create_task(
            "Prepare technical feasibility assessments",
            "Bob",
            "2024-02-19",
            meeting.agenda_items[0].id if len(meeting.agenda_items) > 0 else ""
        );
        priority2 = ai_assistant.suggest_task_priority(
            task2.title,
            "Assess top 5 features for technical feasibility",
            task2.deadline
        );
        task2.notes = "Priority: " + priority2 + " - Focus on top 5 features";
        if len(meeting.agenda_items) > 0 {
            meeting.agenda_items[0].tasks.append(task2);
        }
        print("  ✓ Task for Bob (Priority: " + priority2 + ")");
        
        # Task 3: Charlie - Design mockups
        task3 = main.create_task(
            "Coordinate dashboard mockups with design team",
            "Charlie",
            "2024-02-22",
            meeting.agenda_items[1].id if len(meeting.agenda_items) > 1 else ""
        );
        priority3 = ai_assistant.suggest_task_priority(
            task3.title,
            "Create mockups for new dashboard feature",
            task3.deadline
        );
        task3.notes = "Priority: " + priority3;
        if len(meeting.agenda_items) > 1 {
            meeting.agenda_items[1].tasks.append(task3);
        }
        print("  ✓ Task for Charlie (Priority: " + priority3 + ")");
        
        # Task 4: Diana - Customer feedback
        task4 = main.create_task(
            "Gather and present customer feedback",
            "Diana",
            "2024-02-16",
            meeting.agenda_items[1].id if len(meeting.agenda_items) > 1 else ""
        );
        priority4 = ai_assistant.suggest_task_priority(
            task4.title,
            "Conduct surveys and present findings by end of week",
            task4.deadline
        );
        task4.notes = "Priority: " + priority4 + " - Present by end of week";
        if len(meeting.agenda_items) > 1 {
            meeting.agenda_items[1].tasks.append(task4);
        }
        print("  ✓ Task for Diana (Priority: " + priority4 + ")");
    }
    
    # Step 6: Auto-schedule agenda items
    print("\nStep 6: Auto-scheduling agenda items on calendar...");
    main.auto_schedule_agenda_items(meeting, calendar_events, "2024-02-16");
    print("✓ Scheduled " + str(len(calendar_events)) + " calendar events");
    
    # Step 7: Generate AI summary
    print("\nStep 7: Generating AI summary of the meeting...");
    summary = ai_assistant.generate_meeting_summary(meeting.title, meeting.notes);
    print("\n" + "=" * 60);
    print("MEETING SUMMARY");
    print("=" * 60);
    print(summary);
    print("=" * 60);
    
    # Step 8: Generate progress report
    print("\nStep 8: Generating progress report...");
    main.print_summary(meetings, calendar_events);
    
    # Step 9: Display task assignments
    print("\n=== Task Assignments by Team Member ===");
    team_members = ["Alice", "Bob", "Charlie", "Diana"];
    for member in team_members {
        tasks = main.get_tasks_by_assignee(meetings, member);
        if len(tasks) > 0 {
            print("\n" + member + ":");
            for task in tasks {
                priority_note = "";
                if "Priority:" in task.notes {
                    priority_note = " [" + task.notes + "]";
                }
                print("  - " + task.title + " (Due: " + task.deadline + ")" + priority_note);
            }
        }
    }
    
    # Step 10: Save to file
    print("\n\nStep 10: Saving data to file...");
    main.save_to_file(meetings, calendar_events, "meeting_ai_example.json");
    print("✓ Data saved to meeting_ai_example.json");
    
    print("\n" + "=" * 60);
    print("AI-Enhanced Meeting Example Complete!");
    print("=" * 60);
    print("\nThis example demonstrated:");
    print("  ✓ AI-powered agenda item suggestions");
    print("  ✓ Automatic task extraction from notes");
    print("  ✓ Intelligent task priority recommendations");
    print("  ✓ AI-generated meeting summaries");
    print("  ✓ Integration with core meeting management features");
}
