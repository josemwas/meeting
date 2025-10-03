# Architecture Overview

## Application Type

**This is a Command-Line Interface (CLI) application - it does NOT have a frontend/GUI.**

## What This Means

The Meeting Minutes Management System is a **terminal-based application** that:

- ✅ Runs in your command line/terminal
- ✅ Outputs text to the console
- ✅ Saves data to JSON files
- ✅ Uses CLI commands like `jac run main.jac`
- ❌ Does NOT have a web interface (HTML/CSS/JavaScript)
- ❌ Does NOT have a GUI (Graphical User Interface)
- ❌ Does NOT run in a web browser
- ❌ Does NOT have a web server

## Application Architecture

```
┌─────────────────────────────────────────────────────────┐
│                  User's Terminal                         │
│                                                          │
│  $ jac run main.jac                                     │
│  $ jac run example.jac                                  │
│  $ jac run ai_example.jac                               │
└─────────────────────────────────────────────────────────┘
                         ↓
┌─────────────────────────────────────────────────────────┐
│           Jaclang Runtime Environment                    │
│                                                          │
│  ┌─────────────────────────────────────────────┐       │
│  │  Core Application Logic (.jac files)        │       │
│  │  - main.jac (core functionality)            │       │
│  │  - example.jac (demo workflows)              │       │
│  │  - ai_assistant.jac (AI integration)        │       │
│  │  - ai_example.jac (AI-enhanced demo)        │       │
│  └─────────────────────────────────────────────┘       │
│                         ↓                                │
│  ┌─────────────────────────────────────────────┐       │
│  │  Data Models (Objects)                       │       │
│  │  - Meeting, AgendaItem, Task, CalendarEvent │       │
│  └─────────────────────────────────────────────┘       │
└─────────────────────────────────────────────────────────┘
                         ↓
┌─────────────────────────────────────────────────────────┐
│            External Services & Storage                   │
│                                                          │
│  ├─ AI/LLM APIs (OpenAI, Anthropic) [Optional]         │
│  └─ JSON Files (meeting_data.json)                      │
└─────────────────────────────────────────────────────────┘
```

## Technology Stack

### Core Technologies
- **Jaclang**: The programming language used to build the application
- **Python**: Underlying runtime (Jaclang runs on Python)
- **CLI**: Command-line interface for all interactions

### Optional AI Features
- **ByLLM**: AI/LLM integration library
- **LiteLLM**: Unified interface for multiple LLM providers
- **OpenAI API**: GPT models for AI features
- **Anthropic API**: Claude models for AI features

### Data Storage
- **JSON**: Simple file-based storage (no database)
- Files created: `meeting_data.json`, `meeting_ai_example.json`

## How Users Interact

Users interact with this application **exclusively through the terminal**:

```bash
# Example 1: Run the main application
$ jac run main.jac
=== Meeting Minutes Management System ===
Built with Jaclang
Created meeting: Q1 Planning Meeting
...

# Example 2: Run a demo workflow
$ jac run example.jac

# Example 3: Use AI features
$ export OPENAI_API_KEY='your-key'
$ jac run ai_example.jac
```

All output appears as **text in the terminal**. There is no graphical interface, no web page, and no browser-based UI.

## Future Possibilities

The README.md Contributing section mentions potential future enhancements:

- ✨ Create a web interface (would require new implementation)
- ✨ Add database persistence (currently uses JSON files)
- ✨ Implement user authentication (not currently needed for CLI)

**These are suggestions for future contributors, not current features.**

## Comparison

| Feature | CLI App (Current) | Web App (Not Implemented) |
|---------|------------------|---------------------------|
| Interface | Terminal/Command Line | Web Browser |
| User Input | CLI commands | HTML Forms, Buttons |
| Output | Text to console | HTML pages |
| Installation | `pip install` packages | Web server setup |
| Access | Local machine only | Can be remote/cloud |
| Dependencies | Python, Jaclang | Additional: Flask/FastAPI/React/etc |

## Summary

This is a **pure CLI application**. If you're looking for a web interface or GUI, you would need to:

1. Build a separate web frontend (e.g., React, Vue, HTML)
2. Add a web backend/API (e.g., FastAPI, Flask)
3. Connect the frontend to the existing business logic

The current application is designed for **developers and power users** who are comfortable working in the terminal.
