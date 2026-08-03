#!/usr/bin/env python3
"""
Fetch Google Scholar citation statistics, write them to _data/scholar.yml,
and render the citations-per-year chart used in the sidebar.

Run daily by .github/workflows/update-scholar-stats.yml, and runnable
locally with:

    pip install scholarly pyyaml matplotlib
    python3 scripts/fetch_scholar_stats.py

Google Scholar sometimes blocks automated requests. If every attempt
fails, the script exits non-zero and leaves _data/scholar.yml and the
chart untouched, so the site keeps showing the last good numbers.
"""

import os
import sys
import time
import datetime
from datetime import timezone

import yaml
import matplotlib

matplotlib.use("Agg")
import matplotlib.pyplot as plt

from scholarly import scholarly

SCHOLAR_USER_ID = "khPqHmgAAAAJ"
ATTEMPTS = 4          # Scholar blocks intermittently, so retry a few times
BACKOFF_SECONDS = 20

REPO_ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
DATA_PATH = os.path.join(REPO_ROOT, "_data", "scholar.yml")
CHART_PATH = os.path.join(REPO_ROOT, "code", "citations", "czymara_scholar_citations.png")

BAR_COLOR = "#2a2e31"  # inverted to light by the dark-mode CSS in _includes/head/custom.html


def fetch_author():
    """Fetch and fill the Scholar profile, retrying on transient blocks."""
    last_error = None
    for attempt in range(1, ATTEMPTS + 1):
        try:
            author = scholarly.search_author_id(SCHOLAR_USER_ID)
            return scholarly.fill(author, sections=["indices", "counts"])
        except Exception as exc:  # scholarly raises a variety of types
            last_error = exc
            print(f"Attempt {attempt}/{ATTEMPTS} failed: {exc}", file=sys.stderr)
            if attempt < ATTEMPTS:
                time.sleep(BACKOFF_SECONDS * attempt)
    raise RuntimeError(f"Could not fetch Google Scholar profile: {last_error}")


def build_stats(author):
    current_year = datetime.datetime.now(timezone.utc).year
    return {
        "citations_all": author.get("citedby", 0),
        "citations_recent": author.get("citedby5y", 0),
        "hindex_all": author.get("hindex", 0),
        "hindex_recent": author.get("hindex5y", 0),
        "since_year": current_year - 5,
        "profile_url": f"https://scholar.google.de/citations?user={SCHOLAR_USER_ID}",
    }


def render_chart(author, path):
    """Slim bar chart of citations per year, transparent background."""
    cites_per_year = author.get("cites_per_year") or {}
    if not cites_per_year:
        print("No per-year citation counts returned; keeping existing chart.", file=sys.stderr)
        return

    years = sorted(cites_per_year)
    counts = [cites_per_year[y] for y in years]

    os.makedirs(os.path.dirname(path), exist_ok=True)

    fig, ax = plt.subplots(figsize=(4.6, 1.9), dpi=200)
    ax.bar(range(len(years)), counts, color=BAR_COLOR, width=0.65)

    ax.set_xticks(range(len(years)))
    ax.set_xticklabels([str(y) for y in years], fontsize=7, rotation=45, ha="right")
    ax.set_yticks([])
    ax.tick_params(axis="x", colors=BAR_COLOR, length=0)
    for spine in ("top", "right", "left"):
        ax.spines[spine].set_visible(False)
    ax.spines["bottom"].set_color(BAR_COLOR)

    fig.patch.set_alpha(0.0)
    ax.patch.set_alpha(0.0)
    fig.tight_layout(pad=0.4)
    fig.savefig(path, transparent=True)
    plt.close(fig)


def main():
    try:
        author = fetch_author()
        stats = build_stats(author)
    except Exception as exc:
        print(f"Failed to fetch Google Scholar stats: {exc}", file=sys.stderr)
        print("Existing _data/scholar.yml and chart left unchanged.", file=sys.stderr)
        return 1

    if not stats["citations_all"]:
        print("Scholar returned zero citations, which is almost certainly a "
              "blocked request. Leaving existing data unchanged.", file=sys.stderr)
        return 1

    os.makedirs(os.path.dirname(DATA_PATH), exist_ok=True)
    with open(DATA_PATH, "w", encoding="utf-8") as f:
        yaml.dump(stats, f, default_flow_style=False, allow_unicode=True, sort_keys=False)
    print(f"Wrote {DATA_PATH}: {stats}")

    try:
        render_chart(author, CHART_PATH)
        print(f"Wrote {CHART_PATH}")
    except Exception as exc:
        # The chart is a nice-to-have; don't fail the run over it.
        print(f"Warning: could not render citation chart: {exc}", file=sys.stderr)

    return 0


if __name__ == "__main__":
    raise SystemExit(main())
