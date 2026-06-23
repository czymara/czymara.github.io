#!/usr/bin/env python3
"""
Generate Google Scholar citations plot.
Works from both local machines and cloud servers (GitHub Actions).
"""

import requests
from bs4 import BeautifulSoup
import matplotlib.pyplot as plt
import matplotlib.ticker as ticker
from datetime import date
import sys

SCHOLAR_ID = "khPqHmgAAAAJ"
SCHOLAR_URL = f"https://scholar.google.de/citations?user={SCHOLAR_ID}&hl=en"

headers = {
    "User-Agent": "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/122.0.0.0 Safari/537.36",
    "Accept-Language": "en-US,en;q=0.9",
    "Accept": "text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8",
}

print("Fetching Google Scholar page...")
try:
    r = requests.get(SCHOLAR_URL, headers=headers, timeout=20)
    r.raise_for_status()
    soup = BeautifulSoup(r.text, "html.parser")
except Exception as e:
    print(f"✗ Error fetching: {e}")
    sys.exit(1)

# ── Extract metrics ──────────────────────────────────────────────────────────
print("Extracting metrics...")
try:
    table = soup.find(id="gsc_rsb_st")
    if table is None:
        raise ValueError("Stats table not found")

    cells = table.find_all("td", class_="gsc_rsb_std")
    total_cites = int(cells[0].text)
    h_index = int(cells[2].text)
    i10_index = int(cells[4].text)

    print(f"✓ citations={total_cites}, h-index={h_index}, i10-index={i10_index}")
except Exception as e:
    print(f"✗ Error extracting metrics: {e}")
    sys.exit(1)

# ── Extract citations per year ──────────────────────────────────────────────
print("Extracting citations per year...")
try:
    bars = soup.select("a.gsc_g_a")
    print(f"  Found {len(bars)} bar elements")

    cites_per_year = {}

    # Bars are already in chronological order (oldest to newest)
    current_year = date.today().year

    # Extract all counts in order
    counts = []
    for bar in bars:
        span = bar.find("span", class_="gsc_g_al")
        if span:
            counts.append(int(span.text))

    # Map to years (bars go from oldest to newest)
    num_years = len(counts)
    start_year = current_year - num_years + 1

    for i, count in enumerate(counts):
        year = start_year + i
        cites_per_year[year] = count
        print(f"  {year}: {count} citations")

    if not cites_per_year:
        raise ValueError("No citation data extracted")

except Exception as e:
    print(f"✗ Error extracting citations: {e}")
    sys.exit(1)

# ── Generate plot ───────────────────────────────────────────────────────────
print("Generating plot...")
try:
    years = sorted(cites_per_year.keys())
    counts = [cites_per_year[y] for y in years]

    # Match the original R plot styling
    clr = "#2a2e31"
    fsize = 16

    fig, ax = plt.subplots(figsize=(16/3, 16/3), dpi=300)

    # Use positions 0, 1, 2, ... and label with years
    positions = range(len(years))
    ax.bar(positions, counts, color=clr, width=0.7)

    # Styling
    ax.set_facecolor("white")
    fig.patch.set_alpha(0)

    for spine in ax.spines.values():
        spine.set_edgecolor(clr)
        spine.set_linewidth(1)
    for spine in ["top", "right"]:
        ax.spines[spine].set_visible(False)

    ax.tick_params(colors=clr, labelsize=fsize)
    ax.set_xticks(positions)
    ax.set_xticklabels(years, rotation=45, ha="right")
    ax.set_ylabel(None)
    ax.set_xlabel(None)

    # Caption
    caption = f"Total citations: {total_cites}; H-index: {h_index}"
    fig.text(0.5, 0.02, caption, ha="center", va="bottom",
             fontsize=int(fsize * 1.4), color=clr, weight="bold")

    plt.tight_layout(rect=[0, 0.05, 1, 1])
    plt.savefig("czymara_scholar_citations.png", dpi=300, bbox_inches="tight",
                facecolor="none", edgecolor="none", transparent=True)
    plt.close()

    print("✓ Saved czymara_scholar_citations.png")
    print("Done!")

except Exception as e:
    print(f"✗ Error generating plot: {e}")
    import traceback
    traceback.print_exc()
    sys.exit(1)
