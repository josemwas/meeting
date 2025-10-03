# Frequently Asked Questions (FAQ)

## General Questions

### Does this app have a frontend?

**No, this application does NOT have a frontend.** 

This is a **Command-Line Interface (CLI) application** that runs entirely in your terminal. There is:
- ❌ No web interface (HTML/CSS/JavaScript)
- ❌ No GUI (Graphical User Interface)
- ❌ No web browser-based UI
- ❌ No web server

For more details, see [ARCHITECTURE.md](ARCHITECTURE.md).

### What type of application is this?

This is a **terminal-based CLI application** written in Jaclang. You interact with it by running commands like:

```bash
jac run main.jac
jac run example.jac
jac run ai_example.jac
```

All output is displayed as text in your terminal/console.

### Can I use this in a web browser?

Not currently. The application is CLI-only. To use it in a web browser, you would need to:

1. Build a web frontend (React, Vue, HTML, etc.)
2. Create a REST API backend (FastAPI, Flask, etc.)
3. Connect the frontend to the existing business logic

This is mentioned as a potential contribution in the README's Contributing section.

### How do I interact with the application?

All interaction happens through **terminal commands**:

```bash
# Run the main application
jac run main.jac

# Run examples
jac run example.jac
jac run ai_example.jac

# With AI features enabled
export OPENAI_API_KEY='your-key'
jac run ai_example.jac
```

The application outputs results as text to your console.

## Technical Questions

### What programming language is this written in?

The application is written in **Jaclang**, a modern programming language designed for AI applications. Jaclang runs on Python.

### Where is the data stored?

Data is stored in **JSON files** on your local filesystem:
- `meeting_data.json` - Main application data
- `meeting_ai_example.json` - AI example data

There is no database system currently used.

### Do I need a web server to run this?

**No.** This is a CLI application that runs directly on your machine. No web server is needed.

### Can I access this remotely?

Not as designed. It's a local CLI application. For remote access, you would need to:
- Add a web interface
- Deploy to a server
- Implement authentication

These are potential future enhancements mentioned in the Contributing section.

### What are the system requirements?

- Python 3.12 or higher
- Terminal/Command Line access
- Operating System: Linux, macOS, or Windows
- See [INSTALLATION.md](INSTALLATION.md) for detailed requirements

## Features Questions

### Can I use this without AI features?

**Yes!** All core functionality works without AI:
- Meeting management
- Task tracking
- Calendar scheduling
- Progress reporting
- Data persistence

AI features are **optional** and require an API key from OpenAI or Anthropic.

### What AI features are available?

When configured with an API key:
- Generate meeting summaries
- Extract tasks from meeting notes
- Suggest agenda items
- Recommend task priorities
- Enhance and structure notes

See [AI Integration section in README](README.md#ai-integration) for details.

### How much does it cost to use AI features?

The core application is **free**. AI features require:
- An API key from OpenAI (gpt-4o-mini) or Anthropic (Claude)
- These services charge per API call
- Typical cost: pennies per request
- See provider pricing pages for exact rates

Without an API key, the AI functions use fallback heuristics (keyword-based, template-based).

## Usage Questions

### How do I create a meeting?

The application uses Jaclang code. Example:

```jaclang
import main;

with entry {
    # Create a meeting
    meeting = main.Meeting(
        id="meet_001",
        title="Team Standup",
        date="2024-01-15",
        attendees=["Alice", "Bob"],
        agenda_items=[],
        notes=""
    );
    
    # Add to meetings list and save
    meetings = [meeting];
    main.save_to_json(meetings, [], [], "my_meeting.json");
}
```

See [example.jac](example.jac) and [main.jac](main.jac) for complete examples.

### Can I integrate this with my existing tools?

Yes! The application:
- Uses standard JSON for data storage
- Can be imported as a Jaclang module
- Has well-documented API functions
- Can be extended with new functionality

See [API.md](API.md) for the complete API reference.

### How do I see my meeting data?

The data is saved in JSON format. You can:

```bash
# View the JSON file
cat meeting_data.json

# Pretty print with jq (if installed)
cat meeting_data.json | jq .

# Open in a text editor
nano meeting_data.json
```

## Development Questions

### Can I contribute to this project?

Yes! This is an open-source demonstration project. Contributions welcome for:
- New features
- AI enhancements
- **Creating a web interface**
- Adding database support
- Bug fixes
- Documentation improvements

See the Contributing section in [README.md](README.md#contributing).

### What would it take to add a web interface?

To add a web frontend, you would need to:

1. **Choose a frontend framework**: React, Vue, Svelte, or plain HTML/CSS/JS
2. **Create a backend API**: FastAPI or Flask to expose the Jaclang functions
3. **Connect the two**: Use REST API or GraphQL
4. **Add authentication**: If you want multi-user support
5. **Deploy**: Set up hosting (Heroku, AWS, etc.)

This would be a significant enhancement and is explicitly mentioned as a welcome contribution.

### Is there a roadmap for adding a GUI?

Currently, there is no official roadmap for a GUI. The application is designed as a CLI tool to demonstrate Jaclang capabilities. 

A web interface is listed in the Contributing section as a potential enhancement that community members could implement.

### Can I use this as a backend for my own frontend?

**Yes!** You could:
1. Create an API layer (FastAPI/Flask) that calls the Jaclang functions
2. Build your own frontend (web, mobile, desktop)
3. Connect your frontend to the API

The business logic in the `.jac` files is well-structured and modular.

## Troubleshooting

### I don't see any graphical interface when I run the app

That's expected! This is a CLI application. The output appears as text in your terminal window where you ran the `jac run` command.

### How do I know if it's working?

When you run `jac run main.jac`, you should see text output like:

```
=== Meeting Minutes Management System ===
Built with Jaclang
Created meeting: Q1 Planning Meeting
...
```

If you see this text output, it's working correctly!

### I want a visual interface. What should I do?

You have two options:

1. **Use the CLI**: Learn to work with the terminal-based interface
2. **Build a frontend**: Contribute by creating a web interface (see Contributing section)

The application is currently designed for developers comfortable with CLI tools.

## Getting Help

### Where can I find more documentation?

- [README.md](README.md) - Overview and quick start
- [ARCHITECTURE.md](ARCHITECTURE.md) - Application architecture details
- [INSTALLATION.md](INSTALLATION.md) - Installation guide
- [API.md](API.md) - Complete API reference
- [CHANGELOG.md](CHANGELOG.md) - Version history

### Where can I report issues or ask questions?

- GitHub Issues: https://github.com/josemwas/meeting/issues
- Jaclang Documentation: https://www.jac-lang.org

### I'm new to CLI applications. Where should I start?

1. Follow the [INSTALLATION.md](INSTALLATION.md) guide
2. Run the examples: `jac run main.jac`, `jac run example.jac`
3. Read the output in your terminal
4. Review the [API.md](API.md) to understand available functions
5. Modify the example files to experiment

The examples are designed to be educational and demonstrate all features.
