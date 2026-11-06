
# ==========================================
# CyberSentry - Gemini AI Service
# ==========================================

import os
import time
from pathlib import Path

from dotenv import load_dotenv
from google import genai
from google.genai import types


# ------------------------------------------
# CONFIGURATION
# ------------------------------------------

BASE_DIR = Path(__file__).resolve().parent.parent

load_dotenv(BASE_DIR / ".env")

API_KEY = os.getenv("GEMINI_API_KEY")

if not API_KEY:
    raise ValueError(
        "GEMINI_API_KEY was not found in the .env file."
    )


# ------------------------------------------
# GEMINI INITIALIZATION
# ------------------------------------------

client = genai.Client(api_key=API_KEY)

MODEL = "gemini-3.5-flash-lite"


# ------------------------------------------
# CYBERSENTRY SYSTEM INSTRUCTIONS
# ------------------------------------------

SYSTEM_INSTRUCTION = """
You are CyberSentry, a professional cybersecurity assistant
focused on protecting users, especially in Uganda.

Your responsibilities:
- Explain cybersecurity threats and online scams.
- Help users recognize phishing and social engineering.
- Explain suspicious messages and security warnings.
- Give practical cybersecurity recommendations.
- Maintain natural conversations using the provided history.

Focus especially on:
- Mobile money fraud.
- Fake job advertisements.
- Impersonation scams.
- Phishing and account takeover.
- Online fraud affecting users in Uganda.

RESPONSE STYLE:
- Be concise, clear, friendly and professional.
- Use simple language.
- Keep responses under 100 words whenever possible.
- Avoid long introductions and repetitive headings.
- Use short paragraphs and simple bullet points.
- Do not repeat information unnecessarily.
- Do not begin responses with strange labels or letters.
- Answer ordinary questions naturally.

SECURITY RULES:
- Never ask users for PINs, passwords or OTP codes.
- Never encourage sharing sensitive credentials.
- Never claim a link is safe without verification.
- Explain uncertainty honestly.

PROLOG INTEGRATION:
- Prolog is responsible for rule-based threat detection
  and risk classification.
- When Prolog findings are provided, explain them accurately.
- Never invent indicators or security findings.
- Do not override the Prolog risk classification.
"""


# ------------------------------------------
# GENERATION SETTINGS
# ------------------------------------------

def generation_config():

    return types.GenerateContentConfig(
        system_instruction=SYSTEM_INSTRUCTION,
        temperature=0.3,
        max_output_tokens=200,
    )


# ------------------------------------------
# RESPONSE TIME LOGGER
# ------------------------------------------

def log_response_time(start_time):

    elapsed = time.perf_counter() - start_time

    print(
        f"[CyberSentry] Gemini response time: "
        f"{elapsed:.2f} seconds",
        flush=True
    )


# ------------------------------------------
# STANDALONE AI RESPONSE
# ------------------------------------------

def ask_gemini(message):

    if not isinstance(message, str) or not message.strip():
        raise ValueError("Message cannot be empty.")

    start_time = time.perf_counter()

    try:

        response = client.models.generate_content(
            model=MODEL,
            contents=message,
            config=generation_config(),
        )

        if not response.text:
            raise RuntimeError(
                "Gemini returned an empty response."
            )

        return response.text.strip()

    finally:
        log_response_time(start_time)


# ------------------------------------------
# CONVERSATIONAL AI ASSISTANT
# ------------------------------------------

def chat_with_gemini(
    message,
    history=None,
    security_analysis=None
):
    """
    Generate a conversational response using Gemini.

    Args:
        message: Current user message.
        history: Previous conversation messages.
        security_analysis: Optional findings from Prolog.

    Returns:
        Gemini's response as a string.
    """

    if not isinstance(message, str) or not message.strip():
        raise ValueError("Message cannot be empty.")

    contents = []

    # --------------------------------------
    # ADD RECENT CONVERSATION HISTORY
    # --------------------------------------

    if isinstance(history, list):

        for item in history[-12:]:

            if not isinstance(item, dict):
                continue

            role = item.get("role")
            content = item.get("content")

            if role not in ("user", "model"):
                continue

            if isinstance(content, str) and content.strip():

                contents.append({
                    "role": role,
                    "parts": [
                        {"text": content}
                    ]
                })

    # --------------------------------------
    # ADD PROLOG SECURITY FINDINGS
    # --------------------------------------

    current_message = message

    if security_analysis:

        current_message += (
            "\n\n"
            "CYBERSENTRY PROLOG SECURITY FINDINGS:\n"
            f"{security_analysis}\n\n"
            "Explain these findings accurately. "
            "Keep your response concise. "
            "Do not invent additional findings."
        )

    # --------------------------------------
    # ADD CURRENT USER MESSAGE
    # --------------------------------------

    contents.append({
        "role": "user",
        "parts": [
            {"text": current_message}
        ]
    })

    # --------------------------------------
    # GENERATE GEMINI RESPONSE
    # --------------------------------------

    start_time = time.perf_counter()

    try:

        response = client.models.generate_content(
            model=MODEL,
            contents=contents,
            config=generation_config(),
        )

        if not response.text:
            raise RuntimeError(
                "Gemini returned an empty response."
            )

        return response.text.strip()

    finally:
        log_response_time(start_time)
