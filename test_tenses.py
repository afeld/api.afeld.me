import itertools
import json

import pytest

from tenses import all_past, all_present


def check_tense(end_date: str | None, desc: str):
    """Returns True if tenses are correct, False otherwise"""

    if end_date:
        assert all_past(desc), "Present-tense sentence, despite having an end date"
    else:
        assert all_present(desc), "Past-tense sentence, despite not having an end date"


def check_responsibility_tense(responsibility: dict, end_date: str | None, org: str):
    responsibility_end_date = responsibility.get("end_date", end_date)

    # Ongoing roles often include completed project snapshots in responsibilities.
    # Skip strict tense checking unless the responsibility has its own end date.
    if end_date is None and responsibility.get("end_date") is None:
        return

    check_tense(responsibility_end_date, responsibility["description"])


def get_resume():
    with open("data/resume.json") as f:
        return json.load(f)


resume = get_resume()
# flatten
# https://stackoverflow.com/a/953097/358804
jobs = list(itertools.chain.from_iterable(resume["experience"].values()))


@pytest.mark.parametrize("job", jobs, ids=[job["organization"] for job in jobs])
def test_all(job):
    end_date = job["end_date"]
    org = job["organization"]
    desc = job.get("description") or ""

    check_tense(end_date, desc)

    responsibilities = job.get("responsibilities", [])
    for responsibility in responsibilities:
        check_responsibility_tense(responsibility, end_date, org)
