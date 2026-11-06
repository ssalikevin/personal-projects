
% ============================================================
% CyberSentry
% Intelligent Cybersecurity Expert System
% Prolog Threat Detection and Risk Reasoning Engine
% Version 2.0
% ============================================================

:- use_module(library(lists)).
:- use_module(library(apply)).

% ============================================================
% SECTION 1: TEXT PROCESSING
% ============================================================

% Normalize text for case-insensitive phrase detection.

normalize_text(Text, Tokens) :-
    string_lower(Text, LowerText),
    split_string(
        LowerText,
        " \t\n\r.,!?;:()[]{}<>/\\|@#$%^&*_+=~`-\"'\u2013\u2014\u2018\u2019\u201C\u201D\u2026\u2022\u00B7\u00A0",
        "",
        Tokens
    ).

% Check whether a sequence of words occurs in another sequence.

phrase_in_tokens(Phrase, Tokens) :-
    append(_, Remaining, Tokens),
    append(Phrase, _, Remaining),
    !.

% Match a known indicator against a normalized message.

contains_indicator(Message, Indicator) :-
    normalize_text(Message, MessageTokens),
    contains_indicator_tokens(MessageTokens, Indicator).

contains_indicator_tokens(MessageTokens, Indicator) :-
    indicator_pattern(Indicator, Pattern),
    normalize_text(Pattern, PatternTokens),
    phrase_in_tokens(PatternTokens, MessageTokens).

% ============================================================
% SECTION 2: CYBERSECURITY INDICATORS
% ============================================================

% A. CREDENTIAL THEFT

indicator_pattern(requests_pin, "your pin").
indicator_pattern(requests_pin, "pin number").
indicator_pattern(requests_pin, "pin code").
indicator_pattern(requests_pin, "send your pin").
indicator_pattern(requests_pin, "send me your pin").
indicator_pattern(requests_pin, "send me the pin").
indicator_pattern(requests_pin, "share your pin").
indicator_pattern(requests_pin, "enter your pin").
indicator_pattern(requests_pin, "provide your pin").
indicator_pattern(requests_pin, "confirm your pin").
indicator_pattern(requests_pin, "verify your pin").
indicator_pattern(requests_pin, "mobile money pin").
indicator_pattern(requests_pin, "account pin").

indicator_pattern(requests_password, "password").
indicator_pattern(requests_password, "passcode").
indicator_pattern(requests_password, "login credentials").
indicator_pattern(requests_password, "account credentials").
indicator_pattern(requests_password, "login password").

indicator_pattern(requests_otp, "your otp").
indicator_pattern(requests_otp, "the otp").
indicator_pattern(requests_otp, "otp code").
indicator_pattern(requests_otp, "send your otp").
indicator_pattern(requests_otp, "send me the otp").
indicator_pattern(requests_otp, "share your otp").
indicator_pattern(requests_otp, "enter your otp").
indicator_pattern(requests_otp, "provide your otp").
indicator_pattern(requests_otp, "confirm your otp").
indicator_pattern(requests_otp, "verify your otp").
indicator_pattern(requests_otp, "one time pin").
indicator_pattern(requests_otp, "one time password").
indicator_pattern(requests_otp, "verification code").
indicator_pattern(requests_otp, "security code").
indicator_pattern(requests_otp, "authentication code").
indicator_pattern(requests_otp, "sms code").

indicator_pattern(requests_secret, "secret key").
indicator_pattern(requests_secret, "recovery phrase").
indicator_pattern(requests_secret, "private key").
indicator_pattern(requests_secret, "backup code").

% B. PHISHING AND SUSPICIOUS LINKS

indicator_pattern(suspicious_link, "click this link").
indicator_pattern(suspicious_link, "click the link").
indicator_pattern(suspicious_link, "open this link").
indicator_pattern(suspicious_link, "visit this link").
indicator_pattern(suspicious_link, "verify your account here").
indicator_pattern(suspicious_link, "login here").
indicator_pattern(suspicious_link, "update your details here").
indicator_pattern(suspicious_link, "confirm your account here").
indicator_pattern(suspicious_link, "suspicious website").
indicator_pattern(suspicious_link, "unknown website").
indicator_pattern(suspicious_link, "shortened link").

% C. URGENCY AND PRESSURE TACTICS

indicator_pattern(urgent_action, "immediately").
indicator_pattern(urgent_action, "urgent").
indicator_pattern(urgent_action, "act now").
indicator_pattern(urgent_action, "within 24 hours").
indicator_pattern(urgent_action, "right away").
indicator_pattern(urgent_action, "limited time").
indicator_pattern(urgent_action, "last chance").
indicator_pattern(urgent_action, "respond quickly").
indicator_pattern(urgent_action, "do not delay").
indicator_pattern(urgent_action, "today only").
indicator_pattern(urgent_action, "final warning").
indicator_pattern(urgent_action, "expires soon").

% D. THREATS AND ACCOUNT SUSPENSION

indicator_pattern(threatening_language, "account suspended").
indicator_pattern(threatening_language, "account has been suspended").
indicator_pattern(threatening_language, "account is suspended").
indicator_pattern(threatening_language, "account will be suspended").
indicator_pattern(threatening_language, "account blocked").
indicator_pattern(threatening_language, "account has been blocked").
indicator_pattern(threatening_language, "account is blocked").
indicator_pattern(threatening_language, "account will be closed").
indicator_pattern(threatening_language, "account has been closed").
indicator_pattern(threatening_language, "legal action").
indicator_pattern(threatening_language, "you will be arrested").
indicator_pattern(threatening_language, "account terminated").
indicator_pattern(threatening_language, "account has been terminated").
indicator_pattern(threatening_language, "account deactivated").
indicator_pattern(threatening_language, "account has been deactivated").
indicator_pattern(threatening_language, "permanent suspension").
indicator_pattern(threatening_language, "your account is at risk").
indicator_pattern(threatening_language, "failure to comply").
indicator_pattern(threatening_language, "police will arrest you").

% E. FINANCIAL FRAUD AND PAYMENT REQUESTS

indicator_pattern(suspicious_payment, "send money").
indicator_pattern(suspicious_payment, "processing fee").
indicator_pattern(suspicious_payment, "transaction fee").
indicator_pattern(suspicious_payment, "pay a fee").
indicator_pattern(suspicious_payment, "make payment").
indicator_pattern(suspicious_payment, "registration fee").
indicator_pattern(suspicious_payment, "activation fee").
indicator_pattern(suspicious_payment, "release fee").
indicator_pattern(suspicious_payment, "clearance fee").
indicator_pattern(suspicious_payment, "deposit money").
indicator_pattern(suspicious_payment, "transfer money").
indicator_pattern(suspicious_payment, "pay to receive").
indicator_pattern(suspicious_payment, "send payment").
indicator_pattern(suspicious_payment, "mobile money transfer").

% F. FAKE PRIZES AND REWARD SCAMS

indicator_pattern(unexpected_reward, "you have won").
indicator_pattern(unexpected_reward, "you won a prize").
indicator_pattern(unexpected_reward, "congratulations winner").
indicator_pattern(unexpected_reward, "claim your prize").
indicator_pattern(unexpected_reward, "claim your reward").
indicator_pattern(unexpected_reward, "unexpected reward").
indicator_pattern(unexpected_reward, "free gift").
indicator_pattern(unexpected_reward, "lottery winner").
indicator_pattern(unexpected_reward, "cash prize").
indicator_pattern(unexpected_reward, "lucky winner").
indicator_pattern(unexpected_reward, "you have been selected").
indicator_pattern(unexpected_reward, "exclusive giveaway").

% G. FAKE JOB AND RECRUITMENT SCAMS

indicator_pattern(fake_job_offer, "guaranteed employment").
indicator_pattern(fake_job_offer, "job offer without interview").
indicator_pattern(fake_job_offer, "work from home and earn").
indicator_pattern(fake_job_offer, "no experience required").
indicator_pattern(fake_job_offer, "pay registration fee for job").
indicator_pattern(fake_job_offer, "job application fee").
indicator_pattern(fake_job_offer, "instant employment").
indicator_pattern(fake_job_offer, "get hired immediately").
indicator_pattern(fake_job_offer, "earn money daily").
indicator_pattern(fake_job_offer, "high salary guaranteed").

% H. INVESTMENT AND FINANCIAL OPPORTUNITY SCAMS

indicator_pattern(investment_scam, "guaranteed returns").
indicator_pattern(investment_scam, "double your money").
indicator_pattern(investment_scam, "risk free investment").
indicator_pattern(investment_scam, "daily profit").
indicator_pattern(investment_scam, "guaranteed profit").
indicator_pattern(investment_scam, "get rich quickly").
indicator_pattern(investment_scam, "unlimited returns").
indicator_pattern(investment_scam, "investment opportunity").
indicator_pattern(investment_scam, "send bitcoin to receive").
indicator_pattern(investment_scam, "crypto investment guarantee").

% I. IMPERSONATION AND SOCIAL ENGINEERING

indicator_pattern(impersonation, "i am from your bank").
indicator_pattern(impersonation, "calling from your bank").
indicator_pattern(impersonation, "calling from mtn").
indicator_pattern(impersonation, "calling from airtel").
indicator_pattern(impersonation, "we are from customer care").
indicator_pattern(impersonation, "official support team").
indicator_pattern(impersonation, "your account manager").
indicator_pattern(impersonation, "we are investigating your account").
indicator_pattern(impersonation, "verify your identity for me").

% J. MOBILE MONEY FRAUD

indicator_pattern(mobile_money_fraud, "mobile money account").
indicator_pattern(mobile_money_fraud, "mobile money reversal").
indicator_pattern(mobile_money_fraud, "wrong transaction reversal").
indicator_pattern(mobile_money_fraud, "reverse the transaction").
indicator_pattern(mobile_money_fraud, "send back the money").
indicator_pattern(mobile_money_fraud, "money was sent by mistake").
indicator_pattern(mobile_money_fraud, "mtn momo").
indicator_pattern(mobile_money_fraud, "airtel money").
indicator_pattern(mobile_money_fraud, "mobile money upgrade").
indicator_pattern(mobile_money_fraud, "momo account verification").

% K. ACCOUNT TAKEOVER AND UNAUTHORIZED ACCESS

indicator_pattern(account_takeover, "someone accessed my account").
indicator_pattern(account_takeover, "unauthorized login").
indicator_pattern(account_takeover, "unknown login").
indicator_pattern(account_takeover, "account hacked").
indicator_pattern(account_takeover, "account compromised").
indicator_pattern(account_takeover, "someone changed my password").
indicator_pattern(account_takeover, "password changed without permission").
indicator_pattern(account_takeover, "unknown device signed in").
indicator_pattern(account_takeover, "suspicious login activity").

% L. MALWARE AND DANGEROUS SOFTWARE

indicator_pattern(malware_threat, "install this application").
indicator_pattern(malware_threat, "download this apk").
indicator_pattern(malware_threat, "install this apk").
indicator_pattern(malware_threat, "disable your antivirus").
indicator_pattern(malware_threat, "disable security protection").
indicator_pattern(malware_threat, "unknown attachment").
indicator_pattern(malware_threat, "run this file").
indicator_pattern(malware_threat, "enable macros").
indicator_pattern(malware_threat, "install remote access software").

% M. REMOTE ACCESS AND DEVICE CONTROL

indicator_pattern(remote_access_request, "install anydesk").
indicator_pattern(remote_access_request, "install teamviewer").
indicator_pattern(remote_access_request, "give me remote access").
indicator_pattern(remote_access_request, "share your screen").
indicator_pattern(remote_access_request, "allow remote control").
indicator_pattern(remote_access_request, "install remote desktop").
indicator_pattern(remote_access_request, "give me control of your phone").

% N. PERSONAL INFORMATION THEFT

indicator_pattern(requests_personal_information, "national id number").
indicator_pattern(requests_personal_information, "identity card number").
indicator_pattern(requests_personal_information, "date of birth").
indicator_pattern(requests_personal_information, "bank account number").
indicator_pattern(requests_personal_information, "card number").
indicator_pattern(requests_personal_information, "cvv").
indicator_pattern(requests_personal_information, "passport number").
indicator_pattern(requests_personal_information, "home address").
indicator_pattern(requests_personal_information, "personal information").
indicator_pattern(requests_personal_information, "send a picture of your id").

% O. DELIVERY AND PACKAGE SCAMS

indicator_pattern(delivery_scam, "package delivery failed").
indicator_pattern(delivery_scam, "pay delivery fee").
indicator_pattern(delivery_scam, "customs clearance fee").
indicator_pattern(delivery_scam, "parcel is being held").
indicator_pattern(delivery_scam, "confirm delivery address").
indicator_pattern(delivery_scam, "unpaid shipping fee").
indicator_pattern(delivery_scam, "release your package").

% P. ROMANCE AND EMOTIONAL MANIPULATION

indicator_pattern(emotional_manipulation, "send me money urgently").
indicator_pattern(emotional_manipulation, "i need money urgently").
indicator_pattern(emotional_manipulation, "i am stranded").
indicator_pattern(emotional_manipulation, "send money for transport").
indicator_pattern(emotional_manipulation, "emergency hospital bill").
indicator_pattern(emotional_manipulation, "keep this secret").
indicator_pattern(emotional_manipulation, "do not tell anyone").

% ============================================================
% SECTION 3: INDICATOR EXPLANATIONS
% ============================================================

indicator_description(requests_pin,
    "The message requests a confidential PIN. A legitimate service provider should never ask you to disclose it.").

indicator_description(requests_password,
    "The message requests a password or login credential. Sharing these details could allow account takeover.").

indicator_description(requests_otp,
    "The message requests a one-time verification code. Criminals can use this code to authorize unauthorized access or transactions.").

indicator_description(requests_secret,
    "The message requests a private key, recovery phrase, or other secret authentication information.").

indicator_description(suspicious_link,
    "The message encourages interaction with a link that may lead to a phishing page or malicious website.").

indicator_description(urgent_action,
    "The message uses urgency or time pressure, a common social engineering technique used to prevent careful verification.").

indicator_description(threatening_language,
    "The message uses threats or account-suspension claims to pressure the recipient into acting.").

indicator_description(suspicious_payment,
    "The message requests money, a fee, or a transfer in circumstances that may indicate financial fraud.").

indicator_description(unexpected_reward,
    "The message advertises an unexpected prize or reward that may be used to lure victims into a scam.").

indicator_description(fake_job_offer,
    "The message contains employment claims or recruitment language commonly associated with fraudulent job offers.").

indicator_description(investment_scam,
    "The message promotes unusually attractive or guaranteed financial returns, which may indicate an investment scam.").

indicator_description(impersonation,
    "The message contains language suggesting someone may be pretending to represent a trusted organization.").

indicator_description(mobile_money_fraud,
    "The message involves mobile money activity or reversal claims that could be used to manipulate a recipient into sending money or revealing credentials.").

indicator_description(account_takeover,
    "The message describes suspicious account access or unauthorized changes that may indicate an account compromise.").

indicator_description(malware_threat,
    "The message encourages downloading, installing, or running software that may expose a device to malware.").

indicator_description(remote_access_request,
    "The message requests remote access or device control, which could expose private information or financial accounts.").

indicator_description(requests_personal_information,
    "The message requests personal or financial information that could be misused for identity theft or fraud.").

indicator_description(delivery_scam,
    "The message contains delivery or customs-fee claims that may be used to obtain money or personal information.").

indicator_description(emotional_manipulation,
    "The message uses emotional pressure, secrecy, or emergency claims that may be intended to manipulate the recipient.").

% ============================================================
% SECTION 4: THREAT CATEGORIES
% ============================================================

threat_category(requests_pin, credential_theft).
threat_category(requests_password, credential_theft).
threat_category(requests_otp, credential_theft).
threat_category(requests_secret, credential_theft).
threat_category(suspicious_link, phishing).
threat_category(urgent_action, social_engineering).
threat_category(threatening_language, social_engineering).
threat_category(suspicious_payment, financial_fraud).
threat_category(unexpected_reward, reward_scam).
threat_category(fake_job_offer, employment_fraud).
threat_category(investment_scam, investment_fraud).
threat_category(impersonation, impersonation_fraud).
threat_category(mobile_money_fraud, mobile_money_fraud).
threat_category(account_takeover, account_compromise).
threat_category(malware_threat, malware).
threat_category(remote_access_request, unauthorized_access).
threat_category(requests_personal_information, identity_theft).
threat_category(delivery_scam, delivery_fraud).
threat_category(emotional_manipulation, social_engineering).

% ============================================================
% SECTION 5: MESSAGE ANALYSIS
% ============================================================

% Collect all distinct indicators detected in a message.

analyze_message(Message, Indicators) :-
    normalize_text(Message, MessageTokens),
    findall(
        Indicator,
        contains_indicator_tokens(MessageTokens, Indicator),
        FoundIndicators
    ),
    sort(FoundIndicators, Indicators).

% Collect threat categories represented by the indicators.

analyze_categories(Indicators, Categories) :-
    findall(
        Category,
        (
            member(Indicator, Indicators),
            threat_category(Indicator, Category)
        ),
        FoundCategories
    ),
    sort(FoundCategories, Categories).

% Produce explanations for detected indicators.

analyze_evidence(Indicators, Evidence) :-
    findall(
        evidence(Indicator, Description),
        (
            member(Indicator, Indicators),
            indicator_description(Indicator, Description)
        ),
        Evidence
    ).

% ============================================================
% SECTION 6: RISK WEIGHTING
% ============================================================

% Critical indicators receive high weights.

indicator_weight(requests_pin, 10).
indicator_weight(requests_password, 10).
indicator_weight(requests_otp, 10).
indicator_weight(requests_secret, 10).
indicator_weight(suspicious_payment, 8).
indicator_weight(account_takeover, 8).
indicator_weight(remote_access_request, 8).
indicator_weight(malware_threat, 8).

% Other indicators contribute to cumulative risk.

indicator_weight(suspicious_link, 4).
indicator_weight(requests_personal_information, 5).
indicator_weight(impersonation, 4).
indicator_weight(mobile_money_fraud, 4).
indicator_weight(investment_scam, 4).
indicator_weight(fake_job_offer, 3).
indicator_weight(delivery_scam, 3).
indicator_weight(threatening_language, 3).
indicator_weight(unexpected_reward, 2).
indicator_weight(urgent_action, 2).
indicator_weight(emotional_manipulation, 2).

% Add the weights of all distinct detected indicators.

calculate_risk_score(Indicators, Score) :-
    findall(
        Weight,
        (
            member(Indicator, Indicators),
            indicator_weight(Indicator, Weight)
        ),
        Weights
    ),
    sum_list(Weights, Score).

% ============================================================
% SECTION 7: RISK CLASSIFICATION
% ============================================================

critical_indicator(Indicator) :-
    member(
        Indicator,
        [
            requests_pin,
            requests_password,
            requests_otp,
            requests_secret,
            suspicious_payment,
            account_takeover,
            remote_access_request,
            malware_threat
        ]
    ).

% Backwards-compatible message-based risk predicate.
% This clause must come before the indicator-list clauses.

message_risk(Message, Risk) :-
    string(Message),
    !,
    analyze_message(Message, Indicators),
    message_risk(Indicators, Risk).

% A critical indicator is enough for HIGH risk.

message_risk(Indicators, high) :-
    member(Indicator, Indicators),
    critical_indicator(Indicator),
    !.

% Multiple indicators can increase a message to HIGH risk.

message_risk(Indicators, high) :-
    calculate_risk_score(Indicators, Score),
    Score >= 7,
    !.

% A moderate cumulative score indicates MEDIUM risk.

message_risk(Indicators, medium) :-
    calculate_risk_score(Indicators, Score),
    Score >= 3,
    !.

% No significant detected indicators means LOW risk.

message_risk(_, low).

% ============================================================
% SECTION 8: RISK RECOMMENDATIONS
% ============================================================

recommendation(high,
    "HIGH RISK: Do not follow the message's instructions. Do not share passwords, PINs, OTPs, or private information. Do not send money or install unknown software. Verify the situation through an independently obtained official contact channel.").

recommendation(medium,
    "MEDIUM RISK: Treat this message with caution. Do not rush, click suspicious links, or make payments. Verify the sender and the claims independently using an official source before taking action.").

recommendation(low,
    "LOW RISK: No significant suspicious indicators were detected by the current rules. This does not prove the message is safe. Remain cautious, especially with unexpected requests, links, attachments, and financial instructions.").

% ============================================================
% SECTION 9: CATEGORY-SPECIFIC SAFETY ADVICE
% ============================================================

category_advice(credential_theft,
    "Credential safety: Never disclose your PIN, password, OTP, recovery phrase, or authentication code to another person.").

category_advice(phishing,
    "Phishing safety: Avoid opening suspicious links. Navigate to the official website or application yourself instead of using a link in the message.").

category_advice(social_engineering,
    "Social engineering safety: Do not let threats, urgency, secrecy, or emotional pressure force you into making a decision.").

category_advice(financial_fraud,
    "Financial safety: Do not transfer money or pay unexpected fees until you have independently verified the request.").

category_advice(reward_scam,
    "Reward safety: Independently verify unexpected prizes. Be suspicious of requests to pay money before receiving a reward.").

category_advice(employment_fraud,
    "Employment safety: Verify the employer and vacancy through official channels. Be cautious of recruitment fees and unrealistic salary promises.").

category_advice(investment_fraud,
    "Investment safety: Do not invest based on guaranteed-profit claims. Research the company and verify its regulatory status independently.").

category_advice(impersonation_fraud,
    "Impersonation safety: End the conversation and contact the organization using a number or website you obtained independently.").

category_advice(mobile_money_fraud,
    "Mobile money safety: Never disclose your mobile money PIN or OTP. Verify transaction and reversal claims using your provider's official service.").

category_advice(account_compromise,
    "Account safety: Use the official application or website to review account activity, change compromised credentials, and enable multi-factor authentication.").

category_advice(malware,
    "Device safety: Do not install unknown applications or open suspicious attachments. Use trusted sources and keep device security protections enabled.").

category_advice(unauthorized_access,
    "Remote access safety: Do not grant remote control of your device to an unverified person. Disconnect suspicious remote sessions and seek trusted technical assistance.").

category_advice(identity_theft,
    "Identity safety: Do not share identity documents, banking details, or other sensitive personal information with unverified contacts.").

category_advice(delivery_fraud,
    "Delivery safety: Verify shipment information through the delivery company's official tracking service before paying any fee.").

% Build advice from all detected categories.

category_recommendations(Categories, AdviceList) :-
    findall(
        Advice,
        (
            member(Category, Categories),
            category_advice(Category, Advice)
        ),
        AdviceList
    ).

% ============================================================
% SECTION 10: COMPLETE EXPERT SYSTEM OUTPUT
% ============================================================

% Preserve the existing four-argument Python bridge interface.

analyze_message(Message, Indicators, Risk, Advice) :-
    analyze_message(Message, Indicators),
    message_risk(Indicators, Risk),
    recommendation(Risk, Advice).

% Extended analysis includes score, categories and evidence.

analyze_message_extended(
    Message,
    Indicators,
    Risk,
    Score,
    Categories,
    Evidence,
    Advice
) :-
    analyze_message(Message, Indicators),
    calculate_risk_score(Indicators, Score),
    message_risk(Indicators, Risk),
    analyze_categories(Indicators, Categories),
    analyze_evidence(Indicators, Evidence),
    recommendation(Risk, Advice).

% Full analysis includes category-specific recommendations.

analyze_message_full(
    Message,
    Indicators,
    Risk,
    Score,
    Categories,
    Evidence,
    Advice,
    CategoryAdvice
) :-
    analyze_message_extended(
        Message,
        Indicators,
        Risk,
        Score,
        Categories,
        Evidence,
        Advice
    ),
    category_recommendations(Categories, CategoryAdvice).

% ============================================================
% SECTION 11: SYSTEM INFORMATION
% ============================================================

system_name("CyberSentry").

system_description(
    "A Prolog-based cybersecurity expert system for detecting suspicious messages, identifying potential threats, assessing risk, and recommending protective actions."
).

system_version("2.0").
