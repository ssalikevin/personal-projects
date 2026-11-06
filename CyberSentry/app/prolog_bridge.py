
# ============================================================
# CyberSentry
# Python-Prolog Integration Bridge
# Version 2.2
# ============================================================

import ast
import json
import re
from pathlib import Path

from pyswip import Prolog


class PrologBridge:
    """
    Connects the Python application to the CyberSentry
    Prolog cybersecurity expert system.
    """

    def __init__(self):
        self.prolog = Prolog()

        # Locate the project root and Prolog analyzer.
        project_root = Path(__file__).resolve().parent.parent
        analyzer_path = project_root / "prolog" / "message_analyzer.pl"

        if not analyzer_path.exists():
            raise FileNotFoundError(
                f"Prolog analyzer not found: {analyzer_path}"
            )

        # Load the Prolog knowledge base and reasoning rules.
        self.prolog.consult(str(analyzer_path))

        print("[CyberSentry] Prolog threat engine initialized.")

    # --------------------------------------------------------
    # INPUT VALIDATION
    # --------------------------------------------------------

    def _validate_message(self, message):
        if not isinstance(message, str):
            raise ValueError("The message must be text.")

        message = message.strip()

        if not message:
            raise ValueError("Please provide a message to analyze.")

        if len(message) > 5000:
            raise ValueError(
                "The message is too long. Maximum length is 5000 characters."
            )

        return message

    # --------------------------------------------------------
    # PROLOG VALUE CONVERSION
    # --------------------------------------------------------

    def _decode(self, value):
        """Convert PySwip values into Python-compatible values."""

        if isinstance(value, bytes):
            return value.decode("utf-8", errors="replace")

        if isinstance(value, list):
            return [self._decode(item) for item in value]

        if isinstance(value, tuple):
            return [self._decode(item) for item in value]

        return value

    # --------------------------------------------------------
    # EVIDENCE PARSING
    # --------------------------------------------------------

    def _parse_evidence(self, evidence_items):
        """
        Convert Prolog evidence terms into clean dictionaries.

        Example output:
        {
            "indicator": "requests_pin",
            "explanation": "The message requests a confidential PIN."
        }
        """

        parsed = []

        pattern = re.compile(
            r"^evidence\(\s*([a-zA-Z0-9_]+)\s*,\s*(.*?)\s*\)$",
            re.DOTALL
        )

        for item in evidence_items:
            item = self._decode(item)

            if not isinstance(item, str):
                continue

            match = pattern.match(item.strip())

            if not match:
                continue

            indicator = match.group(1)
            explanation = match.group(2).strip()

            # Decode the Python bytes/string representation.
            try:
                decoded = ast.literal_eval(explanation)

                if isinstance(decoded, bytes):
                    explanation = decoded.decode(
                        "utf-8",
                        errors="replace"
                    )

                elif isinstance(decoded, str):
                    explanation = decoded

            except (ValueError, SyntaxError):
                # Keep a safe fallback if parsing fails.
                if (
                    len(explanation) >= 2
                    and explanation[0] == explanation[-1]
                    and explanation[0] in ("'", '"')
                ):
                    explanation = explanation[1:-1]

            parsed.append({
                "indicator": indicator,
                "explanation": explanation
            })

        return parsed

    # --------------------------------------------------------
    # COMPLETE CYBERSECURITY ANALYSIS
    # --------------------------------------------------------

    def analyze(self, message):
        """
        Analyze a message using the complete Prolog expert system.

        Returns:
        - Original message
        - Detected indicators
        - Risk classification
        - Risk score
        - Threat categories
        - Evidence and explanations
        - General safety advice
        - Category-specific recommendations
        """

        message = self._validate_message(message)

        # Safely convert the Python message into a Prolog string.
        safe_message = json.dumps(message, ensure_ascii=False)

        # Request the complete analysis from Prolog.
        query = (
            f"analyze_message_full("
            f"{safe_message}, "
            f"I, R, S, C, E, A, CA)"
        )

        try:
            results = list(self.prolog.query(query))

        except Exception as error:
            raise RuntimeError(
                f"Prolog analysis failed: {error}"
            ) from error

        if not results:
            raise RuntimeError(
                "The Prolog engine could not analyze this message."
            )

        result = results[0]

        # Convert the Prolog outputs into Python values.
        indicators = self._decode(result["I"])
        risk = self._decode(result["R"])
        score = self._decode(result["S"])
        categories = self._decode(result["C"])
        raw_evidence = result["E"]
        advice = self._decode(result["A"])
        category_advice = self._decode(result["CA"])

        # Convert raw Prolog evidence into structured data.
        evidence = self._parse_evidence(raw_evidence)

        # Return a predictable structure for Flask and Gemini.
        return {
            "message": message,
            "indicators": indicators,
            "risk": str(risk),
            "score": score,
            "categories": categories,
            "evidence": evidence,
            "advice": advice,
            "category_advice": category_advice
        }


# ============================================================
# SHARED ANALYZER INSTANCE
# ============================================================

analyzer = PrologBridge()
