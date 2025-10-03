"""
AI Assistant for Meeting Management
Provides intelligent automation and assistance features using ByLLM/LiteLLM

This module integrates with ByLLM (via LiteLLM) to provide AI-powered features for meeting management:
- Auto-summarize meeting notes
- Extract action items automatically
- Suggest agenda items based on meeting purpose
- Recommend task priorities
- Enhance and structure notes

To use these features, set your API key in environment variables:
- export OPENAI_API_KEY='your-key-here' (for OpenAI models)
- export ANTHROPIC_API_KEY='your-key-here' (for Anthropic models)
"""

import os;
import json;

# Helper function to check if AI is available
def is_ai_available() -> bool {
    return "OPENAI_API_KEY" in os.environ or "ANTHROPIC_API_KEY" in os.environ;
}

# Helper function to get model name
def get_model_name() -> str {
    if "OPENAI_API_KEY" in os.environ {
        return "gpt-4o-mini";
    } elif "ANTHROPIC_API_KEY" in os.environ {
        return "claude-3-sonnet-20240229";
    }
    return "";
}

# Helper function to call the LLM
def call_llm(prompt: str) -> str {
    import litellm;
    
    model_name = get_model_name();
    response = litellm.completion(
        model=model_name,
        messages=[{"role": "user", "content": prompt}]
    );
    return response.choices[0].message.content;
}

# AI-powered meeting summary generation
def generate_meeting_summary(meeting_title: str, notes: str) -> str {
    if not is_ai_available() {
        return "AI Summary for '" + meeting_title + "':\n[AI features disabled - set OPENAI_API_KEY or ANTHROPIC_API_KEY to enable]\nOriginal notes: " + notes[:100] + "...";
    }
    
    prompt = "Generate a concise summary of the meeting titled '" + meeting_title + "' based on these notes: " + notes + ". Include key discussion points, decisions made, and action items.";
    return call_llm(prompt);
}

# AI-powered task extraction from notes
def extract_tasks_from_notes(notes: str) -> list {
    if not is_ai_available() {
        # Simple keyword-based fallback
        tasks = [];
        keywords = ["will", "needs to", "should", "must", "has to", "responsible for"];
        
        for line in notes.split('.') {
            line_lower = line.lower();
            for keyword in keywords {
                if keyword in line_lower {
                    task = line.strip();
                    if len(task) > 0 {
                        tasks.append(task);
                    }
                    break;
                }
            }
        }
        
        if len(tasks) == 0 {
            tasks.append("[AI features disabled - set OPENAI_API_KEY or ANTHROPIC_API_KEY to enable]");
        }
        
        return tasks;
    }
    
    prompt = "Extract all action items and tasks from these meeting notes: " + notes + ". Return ONLY a valid JSON array of task strings, with no additional text or explanation. If no tasks are found, return an empty array [].";
    result = call_llm(prompt);
    
    # Handle JSON response
    try {
        # Try to parse as JSON
        tasks = json.loads(result);
        if isinstance(tasks, list) {
            return tasks;
        }
    } except Exception {
        # If JSON parsing fails, try to extract lines
        result = result;
    }
    
    # Fallback to line splitting
    lines = [line.strip() for line in result.split('\n') if line.strip() and not line.strip().startswith('[') and not line.strip().startswith(']')];
    if len(lines) > 0 {
        return lines;
    }
    
    return ["Unable to extract tasks"];
}

# AI-powered agenda suggestion
def suggest_agenda_items(meeting_title: str, meeting_purpose: str) -> list {
    if not is_ai_available() {
        # Simple fallback
        suggestions = [
            "Welcome and introductions",
            "Review of " + meeting_purpose,
            "Discussion points",
            "Action items and next steps",
            "Q&A session",
            "Closing remarks"
        ];
        return suggestions;
    }
    
    prompt = "Suggest 5-7 agenda items for a meeting titled '" + meeting_title + "' with the purpose: " + meeting_purpose + ". Return ONLY a valid JSON array of agenda item strings, with no additional text or explanation.";
    result = call_llm(prompt);
    
    # Handle JSON response
    try {
        agenda = json.loads(result);
        if isinstance(agenda, list) {
            return agenda;
        }
    } except Exception {
        result = result;
    }
    
    # Fallback to line splitting
    lines = [line.strip() for line in result.split('\n') if line.strip() and not line.strip().startswith('[') and not line.strip().startswith(']')];
    if len(lines) > 0 {
        return lines;
    }
    
    return ["Unable to suggest agenda items"];
}

# AI-powered priority assignment
def suggest_task_priority(task_title: str, task_description: str, deadline: str) -> str {
    if not is_ai_available() {
        # Simple heuristic-based fallback
        task_lower = task_title.lower() + " " + task_description.lower();
        
        if "urgent" in task_lower or "asap" in task_lower or "critical" in task_lower {
            return "High";
        } elif "low priority" in task_lower or "when possible" in task_lower {
            return "Low";
        } else {
            return "Medium";
        }
    }
    
    prompt = "Based on the task title '" + task_title + "', description '" + task_description + "', and deadline '" + deadline + "', suggest a priority level. Return ONLY one word: High, Medium, or Low.";
    result = call_llm(prompt).strip();
    
    # Clean up the response to ensure it's just one word
    words = result.split();
    if len(words) > 0 {
        result = words[0].capitalize();
    }
    
    if result not in ["High", "Medium", "Low"] {
        result = "Medium";
    }
    return result;
}

# AI-powered meeting notes enhancement
def enhance_meeting_notes(raw_notes: str) -> str {
    if not is_ai_available() {
        # Simple formatting fallback
        enhanced = "MEETING NOTES\n";
        enhanced = enhanced + "=" * 50 + "\n\n";
        enhanced = enhanced + raw_notes;
        enhanced = enhanced + "\n\n" + "=" * 50;
        return enhanced;
    }
    
    prompt = "Enhance and structure these meeting notes for better readability: " + raw_notes + ". Format them with clear sections, bullet points, and proper organization.";
    return call_llm(prompt);
}

# Demo function to show AI capabilities
with entry {
    print("=== AI Assistant for Meeting Management ===\n");
    print("This module provides AI-powered features using ByLLM:");
    print("1. Generate meeting summaries");
    print("2. Extract tasks from notes automatically");
    print("3. Suggest agenda items based on meeting purpose");
    print("4. Suggest task priorities");
    print("5. Enhance and structure meeting notes\n");
    
    # Check if AI is available
    if not is_ai_available() {
        print("❌ AI features are NOT enabled");
        print("\nTo enable AI features:");
        print("  1. Install ByLLM: pip install byllm");
        print("  2. Set your API key:");
        print("     - For OpenAI: export OPENAI_API_KEY='your-key-here'");
        print("     - For Anthropic: export ANTHROPIC_API_KEY='your-key-here'");
        print("\nRunning in demo mode with placeholder responses.\n");
        
        # Show placeholder output
        test_notes = "We discussed the Q1 budget. Alice will prepare the spreadsheet by next week. Bob needs to create the project timeline. We also talked about resource allocation.";
        print("Sample meeting notes:");
        print(test_notes);
        print("\nExtracting tasks with fallback mode...");
        tasks = extract_tasks_from_notes(test_notes);
        print("\nExtracted tasks:");
        for task in tasks {
            print("  - " + str(task));
        }
    } else {
        model_name = get_model_name();
        print("✅ AI features are ENABLED");
        print("   Using model: " + model_name + "\n");
        
        # Test the AI features
        print("Testing AI features with real LLM...\n");
        
        test_notes = "We discussed the Q1 budget. Alice will prepare the spreadsheet by next week. Bob needs to create the project timeline. We also talked about resource allocation.";
        
        print("Sample meeting notes:");
        print(test_notes);
        print("\n" + "-" * 50);
        
        print("\n1. Extracting tasks from notes...");
        try {
            tasks = extract_tasks_from_notes(test_notes);
            print("\nExtracted tasks:");
            if isinstance(tasks, list) {
                for task in tasks {
                    print("  - " + str(task));
                }
            } else {
                print("  " + str(tasks));
            }
        } except Exception as e {
            print("  Error: " + str(e));
        }
        
        print("\n" + "-" * 50);
        print("\n2. Suggesting agenda items...");
        try {
            agenda = suggest_agenda_items("Team Planning", "quarterly planning");
            print("\nSuggested agenda:");
            if isinstance(agenda, list) {
                idx = 1;
                for item in agenda {
                    print("  " + str(idx) + ". " + str(item));
                    idx = idx + 1;
                }
            } else {
                print("  " + str(agenda));
            }
        } except Exception as e {
            print("  Error: " + str(e));
        }
        
        print("\n" + "-" * 50);
        print("\n3. Generating meeting summary...");
        try {
            summary = generate_meeting_summary("Q1 Planning Meeting", test_notes);
            print("\nSummary:");
            print(summary);
        } except Exception as e {
            print("  Error: " + str(e));
        }
        
        print("\n" + "-" * 50);
        print("\n4. Suggesting task priority...");
        try {
            priority = suggest_task_priority(
                "Update budget spreadsheet",
                "Prepare and update Q1 budget with latest figures",
                "2024-02-15"
            );
            print("Suggested priority: " + str(priority));
        } except Exception as e {
            print("  Error: " + str(e));
        }
    }
    
    print("\n" + "=" * 50);
    print("AI Assistant demonstration complete!");
}
