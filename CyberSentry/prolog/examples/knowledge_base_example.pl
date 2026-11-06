% ==========================================
% CyberSentry
% Intelligent Cybersecurity Expert System
% ==========================================

% ------------------------------------------
% SECTION 1: CYBERSECURITY FACTS
% ------------------------------------------

% Suspicious message indicators

suspicious_indicator(requests_pin).

suspicious_indicator(requests_password).

suspicious_indicator(unexpected_reward).

suspicious_indicator(urgent_action).

suspicious_indicator(suspicious_payment).

suspicious_indicator(threatening_language).

% ------------------------------------------
% SECTION 2: BASIC DETECTION RULES
% ------------------------------------------

% A message is dangerous if it requests
% confidential credentials.

high_risk(Message) :-
    has_indicator(Message, requests_pin).

high_risk(Message) :-
    has_indicator(Message, requests_password).

% A message is suspicious if it promises
% an unexpected reward and creates urgency.

suspicious(Message) :-
    has_indicator(Message, unexpected_reward),
    has_indicator(Message, urgent_action).

% ------------------------------------------
% SECTION 3: MESSAGE INDICATORS
% ------------------------------------------

% Example message indicators for testing

has_indicator(message1, requests_pin).
has_indicator(message1, unexpected_reward).
has_indicator(message1, urgent_action).
