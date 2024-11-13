import json
import spacy
from spacy.tokens import Span

nlp = spacy.load("en_core_web_sm")


# based on
# https://stackoverflow.com/a/57822531/358804
def detect_past_sentence(sent: Span):
    return sent.root.tag_ == "VBD" or any(
        w.dep_ == "aux" and w.tag_ == "VBD" for w in sent.root.children
    )


def all_present(text: str):
    sentences = nlp(text).sents
    return all(not detect_past_sentence(s) for s in sentences)


def all_past(text: str):
    sentences = nlp(text).sents
    return all(detect_past_sentence(s) for s in sentences)


# there is probably a way to avoid these false positives, but just skip them explicitly for now
IGNORE = [
    "self-employed - VoteAmerica",
    "Technology Transformation Services (TTS)",
    "Technology Transformation Services (TTS) - FAS Systems Governance Committee (FSGC)",
    "Technology Transformation Services (TTS) - Mac Working Group",
    "Upsolve",
    "Brooklyn Rail",
    "xD",
    "xD - Recalls",
    "NYC Planning Labs - Discovery",
    "18F",
    "18F - eQIP",
    "18F - DevSecOps Working Group",
    "18F - CIO Liaison",
    "18F - Project Boise",
    "18F - ATO Sprinting/Streamlining Team",
    "18F - cloud.gov",
    "18F - OpenControl / Compliance Masonry",
    "GitHub",
    "Artsy",
    "American Express Publishing",
    "EmpireConf",
    "New York University (NYU) - School of Professional Studies (SPS)",
    "New York University (NYU) - Interactive Telecommunications Program (ITP)",
    "City University of New York (CUNY)",
    "General Assembly",
    "Hacker Hours",
    "Columbia University - School of Professional Studies (SPS)",
]


def check_tense(end_date: str | None, desc: str, role: str):
    """Returns True if tenses are correct, False otherwise"""

    if role in IGNORE:
        return True

    if end_date:
        if not all_past(desc):
            print(f"{role} has a present-tense sentence, despite having an end date")
            return False
    else:
        if not all_present(desc):
            print(f"{role} has a past-tense sentence, despite not having an end date")
            return False

    return True


def check_responsibility_tense(responsibility: dict, end_date: str | None, org: str):
    group = responsibility["group"] or responsibility["title"]
    role = f"{org} - {group}"
    return check_tense(end_date, responsibility["description"], role)


def get_resume():
    with open("data/resume.json") as f:
        return json.load(f)


def run():
    resume = get_resume()
    any_incorrect_tense = False

    for jobs in resume["experience"].values():
        for job in jobs:
            end_date = job["end_date"]
            org = job["organization"]
            desc = job.get("description") or ""

            correct_tense = check_tense(end_date, desc, org)
            if not correct_tense:
                any_incorrect_tense = True

            responsibilities = job.get("responsibilities", [])
            for responsibility in responsibilities:
                correct_tense = check_responsibility_tense(
                    responsibility, end_date, org
                )
                if not correct_tense:
                    any_incorrect_tense = True

    if any_incorrect_tense:
        exit(1)


run()
