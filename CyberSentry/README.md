# CyberSentry

An intelligent cybersecurity expert system that analyses suspicious messages using Prolog rules and explains the findings with Gemini AI.

CyberSentry is designed with Ugandan users in mind, focusing on threats such as mobile money fraud, fake job offers, impersonation, phishing, and account takeover.

## Features

- Detects suspicious indicators in free-text messages.
- Uses 194 phrase patterns across 19 indicator types.
- Maps indicators to 14 threat categories.
- Calculates a weighted risk score and classifies messages as LOW, MEDIUM, or HIGH risk.
- Explains every detected indicator (evidence facility).
- Provides general and category-specific safety advice.
- Includes an AI security assistant powered by Gemini.
- Renders AI output safely to prevent cross-site scripting (XSS).

## How it works

1. The user submits a message through the web interface.
2. Flask validates the input.
3. The Python–Prolog bridge sends the message to SWI-Prolog.
4. Prolog normalises the text, matches indicators, maps categories, scores risk, and produces evidence and advice.
5. The bridge converts the Prolog result into JSON.
6. The message scanner displays the result, or the AI assistant passes the findings to Gemini for a conversational explanation.

Prolog is the authority for detection and risk classification. Gemini only explains the findings and is instructed not to invent or override them.

## Tech stack

- **SWI-Prolog** — knowledge base and inference engine
- **PySwip** — Python ↔ Prolog bridge
- **Python 3** — application logic
- **Flask** — web server and REST API
- **Gemini (`google-genai`)** — conversational AI
- **python-dotenv** — environment configuration
- **HTML / CSS / JavaScript** — frontend

## Project structure

```
CyberSentry/
├── app/
│   ├── app.py                 # Flask application and API routes
│   ├── prolog_bridge.py       # Python ↔ Prolog bridge
│   └── gemini_service.py      # Gemini AI integration
├── prolog/
│   ├── message_analyzer.pl    # Active knowledge base and inference engine
│   └── examples/
│       └── knowledge_base_example.pl
├── templates/
│   ├── index.html             # Message scanner dashboard
│   └── chat.html              # AI assistant chat interface
├── docs/
│   └── CyberSentry_Project_Guide.md
├── static/
├── database/
├── tests/
├── requirements.txt
└── .env.example
```

## Prerequisites

- Python 3.x
- SWI-Prolog

On Debian/Ubuntu:

```bash
sudo apt install swi-prolog
```

## Setup

```bash
cd CyberSentry

python3 -m venv venv
source venv/bin/activate

pip install -r requirements.txt

cp .env.example .env
# Open .env and add your Gemini API key
```

Your `.env` should contain:

```
GEMINI_API_KEY=your_gemini_api_key_here
```

Never commit the real `.env` file.

## Run

```bash
python app/app.py
```

Then open:

- Message Scanner: <http://127.0.0.1:5000/>
- AI Assistant: <http://127.0.0.1:5000/chatbot>

## API endpoints

| Route | Method | Purpose |
|-------|--------|---------|
| `/` | GET | Message scanner dashboard |
| `/chatbot` | GET | AI assistant page |
| `/analyze` | POST | Run Prolog analysis only |
| `/chat` | POST | Run Prolog analysis and get a Gemini reply |

### Example request

```bash
curl -X POST http://127.0.0.1:5000/analyze \
  -H "Content-Type: application/json" \
  -d '{"message": "You have won a prize! Send your PIN immediately."}'
```

### Example response

```json
{
  "success": true,
  "result": {
    "message": "You have won a prize! Send your PIN immediately.",
    "indicators": ["requests_pin", "unexpected_reward", "urgent_action"],
    "risk": "high",
    "score": 14,
    "categories": ["credential_theft", "reward_scam", "social_engineering"],
    "evidence": [
      {
        "indicator": "requests_pin",
        "explanation": "The message requests a confidential PIN..."
      }
    ],
    "advice": "HIGH RISK: ...",
    "category_advice": ["Credential safety: ..."]
  }
}
```

## Documentation

- [Project Guide and Presentation Notes](docs/CyberSentry_Project_Guide.md) — full explanation of the workflow, architecture, Prolog concepts, demo script, and likely presentation questions.
- [Project Guide (PDF)](docs/CyberSentry_Project_Guide.pdf) — printable version for presentations.

## Security notes

- The message is JSON-encoded before being sent to Prolog to prevent query injection.
- The frontend uses `textContent` instead of raw HTML, preventing XSS from AI output.
- Input is limited to 5,000 characters and 32 KB per request.
- `.env` is excluded from version control.
- The development server uses `debug=True`; disable it before public deployment.

## Limitations

- Detection is phrase-based, so paraphrased or obfuscated scams may be missed.
- The rules are English-focused.
- False positives and false negatives are possible.
- Chat history is kept in browser memory only and resets on refresh.
- No database, authentication, or rate limiting yet.

## Future work

- Expand patterns and add synonyms/typos.
- Add URL and domain analysis.
- Add multilingual support, including Luganda.
- Add a database for chat history and saved reports.
- Add automated tests for the Prolog engine and Python bridge.
- Add authentication, rate limiting, and production deployment.
