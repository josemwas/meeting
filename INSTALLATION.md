# Installation Guide

This guide provides detailed instructions for installing and setting up the Meeting Minutes Management System with AI features.

## Table of Contents
- [System Requirements](#system-requirements)
- [Installation Steps](#installation-steps)
- [Setting Up AI Features](#setting-up-ai-features)
- [Troubleshooting](#troubleshooting)
- [Next Steps](#next-steps)

## System Requirements

### Minimum Requirements
- **Python**: 3.12 or higher
- **Operating System**: Linux, macOS, or Windows
- **RAM**: 2GB minimum (4GB recommended for AI features)
- **Disk Space**: 500MB for dependencies

### Optional Requirements (for AI Features)
- **OpenAI API Key** OR **Anthropic API Key**
- **Internet connection** (for AI API calls)

## Installation Steps

### Step 1: Check Python Version

First, verify that you have Python 3.12 or higher installed:

```bash
python --version
# or
python3 --version
```

If you don't have Python 3.12+, download it from [python.org](https://www.python.org/downloads/)

### Step 2: Get the Code

**Option A: Clone with Git (recommended)**

```bash
git clone https://github.com/josemwas/meeting.git
cd meeting
```

**Option B: Download ZIP**

1. Go to https://github.com/josemwas/meeting
2. Click "Code" → "Download ZIP"
3. Extract the ZIP file
4. Open terminal/command prompt in the extracted folder

### Step 3: Install Dependencies

We recommend using a virtual environment to keep dependencies isolated:

**On Linux/macOS:**

```bash
# Create virtual environment
python3 -m venv venv

# Activate virtual environment
source venv/bin/activate

# Install dependencies
pip install -r requirements.txt
```

**On Windows:**

```cmd
# Create virtual environment
python -m venv venv

# Activate virtual environment
venv\Scripts\activate

# Install dependencies
pip install -r requirements.txt
```

**Without virtual environment (not recommended):**

```bash
pip install -r requirements.txt
# or
pip install --user -r requirements.txt
```

### Step 4: Verify Installation

Test that everything is installed correctly:

```bash
# Check Jaclang version
jac --version

# Run the main application
jac run main.jac
```

You should see output showing a sample meeting being created with tasks and calendar events.

## Setting Up AI Features

The application works perfectly fine without AI features enabled (it uses intelligent fallbacks). However, to unlock the full potential of AI-powered assistance, you'll need to set up an API key.

### Choosing Your AI Provider

You need **ONE** of the following:

#### Option 1: OpenAI (GPT Models)

**Pros:**
- Fast response times
- Cost-effective with GPT-4o-mini
- Excellent at structured tasks

**Cons:**
- Requires paid API access
- Data sent to OpenAI servers

**Cost:** ~$0.15 per million input tokens (GPT-4o-mini)

#### Option 2: Anthropic (Claude Models)

**Pros:**
- High-quality responses
- Strong reasoning capabilities
- Privacy-focused

**Cons:**
- Slightly higher cost
- May be slower than GPT-4o-mini

**Cost:** ~$3 per million input tokens (Claude 3 Sonnet)

### Getting an API Key

#### OpenAI

1. Go to [OpenAI Platform](https://platform.openai.com/)
2. Sign up or log in
3. Navigate to [API Keys](https://platform.openai.com/api-keys)
4. Click "Create new secret key"
5. Copy the key (starts with `sk-...`)
6. **Important:** Store it safely - you won't be able to see it again!

#### Anthropic

1. Go to [Anthropic Console](https://console.anthropic.com/)
2. Sign up or log in
3. Navigate to API Keys section
4. Create a new API key
5. Copy the key (starts with `sk-ant-...`)

### Setting the API Key

#### Linux/macOS

**Temporary (current session only):**

```bash
# For OpenAI
export OPENAI_API_KEY='sk-your-actual-key-here'

# OR for Anthropic
export ANTHROPIC_API_KEY='sk-ant-your-actual-key-here'
```

**Permanent (recommended):**

Add to your shell configuration file (`~/.bashrc`, `~/.zshrc`, or `~/.bash_profile`):

```bash
# Open the file
nano ~/.bashrc  # or ~/.zshrc

# Add this line at the end:
export OPENAI_API_KEY='sk-your-actual-key-here'

# Save and reload
source ~/.bashrc  # or source ~/.zshrc
```

#### Windows

**Temporary (current session only):**

```cmd
# For OpenAI
set OPENAI_API_KEY=sk-your-actual-key-here

# OR for Anthropic
set ANTHROPIC_API_KEY=sk-ant-your-actual-key-here
```

**Permanent (recommended):**

1. Press `Windows + R`
2. Type `sysdm.cpl` and press Enter
3. Go to "Advanced" tab
4. Click "Environment Variables"
5. Under "User variables", click "New"
6. Variable name: `OPENAI_API_KEY` (or `ANTHROPIC_API_KEY`)
7. Variable value: your API key
8. Click OK

Restart your terminal/command prompt for changes to take effect.

### Verify AI Setup

Test that AI features are working:

```bash
jac run ai_assistant.jac
```

If successful, you should see:
```
✅ AI features are ENABLED
   Using model: gpt-4o-mini
```

If not:
```
❌ AI features are NOT enabled
```

## Troubleshooting

### Issue: "jac: command not found"

**Cause:** Jaclang is not in your PATH

**Solution:**
```bash
# Make sure you activated your virtual environment
source venv/bin/activate  # Linux/macOS
# or
venv\Scripts\activate  # Windows

# Or reinstall jaclang
pip install --upgrade jaclang
```

### Issue: "No module named 'byllm'"

**Cause:** ByLLM is not installed

**Solution:**
```bash
pip install byllm
```

### Issue: AI features not working despite setting API key

**Possible causes and solutions:**

1. **Key not set in current session**
   ```bash
   # Check if key is set
   echo $OPENAI_API_KEY  # Linux/macOS
   echo %OPENAI_API_KEY%  # Windows
   ```

2. **Typo in API key**
   - Verify the key is correct
   - Make sure there are no extra spaces
   - Check that quotes are properly closed

3. **API key expired or invalid**
   - Generate a new key from your provider's dashboard
   - Check your account status

4. **Network issues**
   - Check internet connection
   - Verify firewall settings
   - Try a different network

### Issue: "ImportError" or "ModuleNotFoundError"

**Solution:** Reinstall dependencies
```bash
pip uninstall -y jaclang byllm
pip install -r requirements.txt
```

### Issue: Permission denied errors

**On Linux/macOS:**
```bash
# Use virtual environment (recommended)
python3 -m venv venv
source venv/bin/activate
pip install -r requirements.txt

# OR install with --user flag
pip install --user -r requirements.txt
```

### Issue: Rate limit errors from AI provider

**Cause:** Too many API requests

**Solutions:**
1. Wait a few minutes before trying again
2. Check your API usage limits
3. Upgrade your API plan if needed
4. Use the fallback mode (without API key)

## Next Steps

After successful installation:

1. **Try the examples:**
   ```bash
   jac run example.jac          # Sprint planning example
   jac run ai_example.jac       # AI-enhanced meeting example
   ```

2. **Create your own meetings:**
   - Modify the examples
   - Import modules in your own `.jac` files
   - See the README for API documentation

3. **Explore AI features:**
   - Experiment with different prompts
   - Try different meeting scenarios
   - Integrate AI into your workflow

4. **Customize the AI model:**
   - Edit `ai_assistant.jac`
   - Change the model in `get_model_name()` function
   - Try different OpenAI or Anthropic models

## Support

If you encounter issues not covered here:

1. Check the [GitHub Issues](https://github.com/josemwas/meeting/issues)
2. Review the [README.md](README.md) for additional documentation
3. Open a new issue with:
   - Your operating system
   - Python version
   - Error messages
   - Steps to reproduce

## Security Notes

- **Never commit API keys to Git**
- **Never share your API keys publicly**
- **Rotate keys regularly**
- **Use environment variables, not hardcoded values**
- **Monitor your API usage to avoid unexpected charges**
