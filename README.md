# Personal Projects

A collection of my personal and academic software projects. Each project lives in its own folder with its own README, setup instructions, and source code.

## Projects

| # | Project | Description | Stack |
|---|---------|-------------|-------|
| 1 | [CyberSentry](./CyberSentry) | Prolog-based cybersecurity expert system that analyses suspicious messages, classifies risk, explains findings, and provides an AI assistant. | SWI-Prolog, PySwip, Python, Flask, Gemini |

## Repository layout

```
personal-projects/
├── README.md
├── .gitignore
└── CyberSentry/
    ├── README.md
    ├── requirements.txt
    ├── .env.example
    ├── docs/
    ├── app/
    ├── prolog/
    ├── templates/
    ├── tests/
    ├── static/
    └── database/
```

## Adding a new project

1. Create a new folder at the repository root.
2. Add a `README.md` inside it.
3. Add the project to the table above.
4. Commit.

## Notes

- Each project is self-contained and documents its own setup.
- Secrets (`.env`) are never committed. Use the provided `.env.example` files.
- `venv/`, `__pycache__/`, and other generated files are ignored.
