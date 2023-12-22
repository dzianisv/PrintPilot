# Simple Telegram Print Server Bot

This repository contains a simple Telegram bot that functions as a print server, allowing you to print documents via Telegram messages.

## Installation

To install the bot as a service on macOS, follow these steps:

1. Set the `TELEGRAM_BOT_TOKEN` environment variable with your Telegram Bot Token.
2. Run the `install.sh` script provided in this repository.

```bash
export TELEGRAM_BOT_TOKEN="your_telegram_bot_token_here"
./install.sh
```

The installation script will set up a virtual environment, install the required dependencies, and register the bot as a macOS service using Launch Agents.
Usage

Once installed, you can send files to your Telegram bot, and it will handle the print job for you. Ensure your system is configured with the correct printer settings.
