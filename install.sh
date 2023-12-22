#!/bin/bash

# Define the paths
VENV_PATH="$HOME/.virtualenvs/printpilot"
SCRIPT_PATH="$HOME/.local/bin/PrintPilot.py"
PLIST_PATH="$HOME/Library/LaunchAgents/PrintPilot.plist"
MAIN_PY_PATH="./main.py" # Adjust this to the path where your main.py is located
REQUIREMENTS_PATH="./requirements.txt" # Adjust this to the path of your requirements.txt

# Check if Python3 is installed
if ! command -v python3 &>/dev/null; then
    echo "Python3 is not installed. Please install Python3 before continuing."
    exit 1
fi

# Create a virtual environment
echo "Creating a virtual environment..."
mkdir -p "$(dirname "$VENV_PATH")" # Create the directory if it doesn't exist
python3 -m venv "$VENV_PATH"

# Activate the virtual environment
echo "Activating the virtual environment..."
source "$VENV_PATH/bin/activate"

# Install dependencies from requirements.txt
if [ -f "$REQUIREMENTS_PATH" ]; then
    echo "Installing dependencies from requirements.txt..."
    pip install -r "$REQUIREMENTS_PATH"
else
    echo "requirements.txt not found. Skipping dependency installation."
fi

# Copy the main.py script to the local bin directory
echo "Installing the script to $SCRIPT_PATH..."
mkdir -p "$(dirname "$SCRIPT_PATH")" # Create the directory if it doesn't exist
cp "$MAIN_PY_PATH" "$SCRIPT_PATH"
chmod +x "$SCRIPT_PATH"

# Create the plist file for the daemon
echo "Creating the daemon plist file..."
mkdir -p "$(dirname "$PLIST_PATH")"
cat > "$PLIST_PATH" << EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
  <key>Label</key>
  <string>com.yourcompany.printpilot</string>
  <key>ProgramArguments</key>
  <array>
    <string>$SCRIPT_PATH</string>
  </array>
  <key>EnvironmentVariables</key>
  <dict>
    <key>TELEGRAM_BOT_TOKEN</key>
    <string>${TELEGRAM_BOT_TOKEN:?TELEGRAM_BOT_TOKEN is not set</string>
  </dict>
  <key>RunAtLoad</key>
  <true/>
  <key>KeepAlive</key>
  <false/>
</dict>
</plist>
EOF

# Load the daemon
launchctl load "$PLIST_PATH"

echo "Script installation complete."