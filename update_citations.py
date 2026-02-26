#!/usr/bin/env python3
"""
Update Google Scholar citation metrics for czymara.github.io.

Run this script from your local machine (not GitHub Actions) — exactly
like Christian Rauh's rvest approach which also runs locally at build time.
Google Scholar blocks requests from cloud/CI servers (Azure, etc.) but
works fine from a personal computer.

Usage:
    python3 update_citations.py

Then commit _data/scholar.json and code/citations/czymara_scholar_citations.png
via GitHub Desktop and push.
"""

import json
import sys
import os
import requests
from datetime import date
from bs4 import BeautifulSoup

# --- matplotlib is optional: skip plot if not installed ---
try:
    import matplotlib
    matplotlib.use("Agg")
    import matplotlib.pyplot as plt
    import matplotlib.ticker as ticker
    HAS_MPL = True
except ImportError:
    HAS_MPL = False

SCHOLAR_ID  = "khPqHmgAAAAJ"
SCHOLAR_URL = f"https://scholar.google.de/citations?user={SCHOLAR_ID}&hl=en"

# Locate repo root (script lives at repo root)
REPO_ROOT   = os.path.dirname(os.path.abspath(__file__))
JSON_PATH   = os.path.join(REPO_ROOT, "_data", "scholar.json")
PLOT_PATH   = os.path.join(REPO_ROOT, "code", "citations", "czymara_scholar_citations.png")

# ── load existing data as fallback ──────────────────────────────────────────
try:
    with open(JSON_PATH) as f:
        existing = json.load(f)
except Exception:
    existing = {}

# ── scrape Google Scholar (same XPath logic as Rauh's rvest code) ────────────
headers = {
    "User-Agent": (
        "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) "
        "AppleWebKit/537.36 (KHTML, like Gecko) "
        "Chrome/122.0.0.0 Safari/537.36"
    ),
    "Accept-Language": "en-US,en;q=0.9",
    "Accept": "text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8",
}

try:
    r = requests.get(SCHOLAR_URL, headers=headers, timeout=20)
    r.raise_for_status()
    soup = BeautifulSoup(r.text, "html.parser")

    # Same element Rauh targets: id="gsc_rsb_st"
    table = soup.find(id="gsc_rsb_st")
    if table is None:
        raise ValueError("Stats table not found — Google Scholar may have blocked the request.")

    cells     = table.find_all("td", class_="gsc_rsb_std")
    total     = int(cells[0].text)
    h_index   = int(cells[2].text)
    i10_index = int(cells[4].text)

    cites_per_year = {}
    for bar in soup.select("a.gsc_g_a"):
        year  = bar.get("href", "").split("as_ylo=")[-1].split("&")[0]
        count = bar.find("span", class_="gsc_g_al")
        if year.isdigit() and count:
            cites_per_year[year] = int(count.text)

    print(f"✓ Fetched: citations={total}, h-index={h_index}, i10-index={i10_index}")

except Exception as e:
    print(f"✗ Could not fetch from Google Scholar: {e}")
    if existing:
        print(f"  Keeping existing data from {existing.get('updated','unknown')}.")
    else:
        print("  No existing data to fall back on.")
    sys.exit(1)

# ── save JSON ────────────────────────────────────────────────────────────────
out = {
    "citations":  total,
    "h_index":    h_index,
    "i10_index":  i10_index,
    "updated":    str(date.today()),
}
with open(JSON_PATH, "w") as f:
    json.dump(out, f, indent=2)
print(f"✓ Saved {JSON_PATH}")

# ── generate bar chart ───────────────────────────────────────────────────────
if HAS_MPL and cites_per_year:
    years  = sorted(cites_per_year.keys())
    counts = [cites_per_year[y] for y in years]
    updated_str = date.today().strftime("%-d. %B %Y")
    caption = f"Total citations: {total}  |  H-index: {h_index}  |  Updated: {updated_str}"

    fig, ax = plt.subplots(figsize=(16/3, 16/3), dpi=300)
    ax.bar(years, counts, color="#333333", width=0.7)
    ax.set_facecolor("white")
    fig.patch.set_facecolor("white")
    for spine in ax.spines.values():
        spine.set_color("black")
    ax.tick_params(colors="black", which="both")
    ax.xaxis.set_major_locator(ticker.FixedLocator(years))
    ax.xaxis.set_tick_params(rotation=45)
    ax.set_title("Google Scholar citations", fontsize=11)
    fig.text(0.5, -0.05, caption, ha="center", va="top", fontsize=10, color="black")
    plt.tight_layout()
    os.makedirs(os.path.dirname(PLOT_PATH), exist_ok=True)
    plt.savefig(PLOT_PATH, bbox_inches="tight", dpi=300)
    plt.close()
    print(f"✓ Saved {PLOT_PATH}")
else:
    if not HAS_MPL:
        print("  (matplotlib not installed — skipping plot)")

print("\nDone! Commit _data/scholar.json and code/citations/czymara_scholar_citations.png via GitHub Desktop.")
