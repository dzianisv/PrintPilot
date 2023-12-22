#!/usr/bin/env python3

import os
import telebot
import tempfile
import subprocess
import logging

logging.basicConfig(format='%(asctime)s - %(name)s - %(levelname)s - %(message)s',
                    level=logging.INFO)

logger = logging.getLogger(__name__)

BOT_TOKEN = os.environ['TELEGRAM_BOT_TOKEN']

bot = telebot.TeleBot(BOT_TOKEN)

@bot.message_handler(content_types=['document', 'photo'])
def handle(message):
    logger.info(f"Received file from {message.from_user.first_name}")
    
    file_info = bot.get_file(message.document.file_id)
    downloaded_file = bot.download_file(file_info.file_path)
    
    copies = message.text # number of copies from message text
    
    with tempfile.NamedTemporaryFile(delete=False) as f:
        f.write(downloaded_file)
        tmp_file = f.name
        
    logger.info(f"Printing {copies} copies of {tmp_file}")
    subprocess.run(['lp', '-n', copies, tmp_file])

    os.remove(tmp_file)
    logger.info("Removed temporary file")

if __name__ == "__main__":
    logger.info("Starting bot")
    bot.polling()