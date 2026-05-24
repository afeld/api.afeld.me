import spacy
from spacy.tokens import Span

nlp = spacy.load("en_core_web_sm")

# written by Copilot

PAST_LEAD_WORDS = {
    "built",
    "created",
    "designed",
    "developed",
    "improved",
    "implemented",
    "launched",
    "led",
    "managed",
    "taught",
    "worked",
}


def _morph_has(token, key: str, value: str) -> bool:
    return value in token.morph.get(key)


def _sentence_tense(sent: Span) -> str:
    """Returns 'past', 'present', or 'unknown' for a sentence."""
    first_token = next((t for t in sent if not t.is_space and not t.is_punct), None)
    lead_word = first_token.text.lower() if first_token else ""

    # Resume bullets often start with a past-tense action verb that parsers can mis-tag.
    has_past = lead_word in PAST_LEAD_WORDS or lead_word.endswith("ed")
    has_present = False

    for token in sent:
        if token.pos_ not in {"VERB", "AUX"}:
            continue

        is_finite = _morph_has(token, "VerbForm", "Fin")
        is_root_past_participle = (
            token.dep_ == "ROOT"
            and token.tag_ == "VBN"
            and _morph_has(token, "Tense", "Past")
        )

        if _morph_has(token, "Tense", "Past") and (
            is_finite or is_root_past_participle
        ):
            has_past = True

        present_in_relative_clause = token.dep_ in {"relcl", "acl"}
        likely_proper_noun_mistag = token.i != sent.start and token.text[:1].isupper()
        if (
            _morph_has(token, "Tense", "Pres")
            and is_finite
            and not present_in_relative_clause
            and not likely_proper_noun_mistag
        ):
            has_present = True

    if has_past and not has_present:
        return "past"

    if has_present and not has_past:
        return "present"

    return "unknown"


def all_present(text: str):
    sentences = nlp(text).sents
    return all(_sentence_tense(s) != "past" for s in sentences)


def all_past(text: str):
    sentences = nlp(text).sents
    return all(_sentence_tense(s) != "present" for s in sentences)
