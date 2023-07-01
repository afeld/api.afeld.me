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


def check_tense(end_date: str | None, desc: str, role: str):
    if end_date:
        if not all_past(desc):
            print(f"{role} has a present-tense sentence")
    else:
        if not all_present(desc):
            print(f"{role} has a past-tense sentence")


with open("data/resume.json") as f:
    data = json.load(f)
    for jobs in data["experience"].values():
        for job in jobs:
            end_date = job["end_date"]
            org = job["organization"]
            desc = job.get("description") or ""

            check_tense(end_date, desc, org)

            responsibilities = job.get("responsibilities", [])
            for responsibility in responsibilities:
                role = f"{org} - {responsibility['group']}"
                check_tense(end_date, responsibility["description"], role)
