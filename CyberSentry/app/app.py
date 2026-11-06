# ==========================================
# CyberSentry - Flask Web Application
# ==========================================

from flask import Flask, render_template, request, jsonify
from pathlib import Path
import json

from prolog_bridge import analyzer
from gemini_service import chat_with_gemini


# ------------------------------------------
# APPLICATION CONFIGURATION
# ------------------------------------------

BASE_DIR = Path(__file__).resolve().parent.parent
TEMPLATE_DIR = BASE_DIR / "templates"

app = Flask(
    __name__,
    template_folder=str(TEMPLATE_DIR)
)

app.config["MAX_CONTENT_LENGTH"] = 32 * 1024


# ------------------------------------------
# HOME PAGE
# ------------------------------------------

@app.route("/")
def home():
    return render_template("index.html")

@app.route("/chatbot")
def chatbot():
    return render_template("chat.html")


# ------------------------------------------
# MESSAGE ANALYSIS API (PROLOG)
# ------------------------------------------

@app.route("/analyze", methods=["POST"])
def analyze():

    try:
        data = request.get_json(silent=True) or {}
        message = data.get("message", "")

        if not isinstance(message, str) or not message.strip():
            return jsonify({
                "success": False,
                "error": "Please enter a valid message."
            }), 400

        result = analyzer.analyze(message)

        return jsonify({
            "success": True,
            "result": result
        })

    except ValueError as error:

        return jsonify({
            "success": False,
            "error": str(error)
        }), 400

    except Exception:

        app.logger.exception("Message analysis failed")

        return jsonify({
            "success": False,
            "error": "An internal error occurred during analysis."
        }), 500


# ------------------------------------------
# AI CHAT API (GEMINI + PROLOG)
# ------------------------------------------

@app.route("/chat", methods=["POST"])
def chat():

    try:
        data = request.get_json(silent=True) or {}

        message = data.get("message", "")
        history = data.get("history", [])

        # Validate message
        if not isinstance(message, str) or not message.strip():
            return jsonify({
                "success": False,
                "error": "Please enter a message."
            }), 400

        if len(message) > 5000:
            return jsonify({
                "success": False,
                "error": "Message is too long. Maximum 5000 characters."
            }), 400

        # Validate conversation history
        if not isinstance(history, list):
            return jsonify({
                "success": False,
                "error": "Invalid conversation history."
            }), 400

        # Limit history size and validate individual messages
        history = [
            item for item in history[-12:]
            if isinstance(item, dict)
            and item.get("role") in ("user", "model")
            and isinstance(item.get("content"), str)
            and len(item["content"]) <= 5000
        ]

        # Analyze the current message using Prolog
        security_analysis = None
        analysis_result = analyzer.analyze(message)

        # Only attach findings when Prolog detects indicators
        if analysis_result["indicators"]:

            security_analysis = json.dumps(
                analysis_result,
                ensure_ascii=False
            )

        # Generate conversational response using Gemini
        reply = chat_with_gemini(
            message=message,
            history=history,
            security_analysis=security_analysis
        )

        return jsonify({
            "success": True,
            "reply": reply,
            "analysis": analysis_result
            if analysis_result["indicators"] else None
        })

    except ValueError as error:

        return jsonify({
            "success": False,
            "error": str(error)
        }), 400

    except Exception:

        app.logger.exception("Chat request failed")

        return jsonify({
            "success": False,
            "error": "CyberSentry could not process your message. Please try again."
        }), 500


# ------------------------------------------
# START APPLICATION
# ------------------------------------------

if __name__ == "__main__":

    app.run(
        host="127.0.0.1",
        port=5000,
        debug=True
    )
