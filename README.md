All my publications and their appendices are available in the [files](files) folder.

Two more pieces of code are uploaded here:

- [Citations](scripts/fetch_scholar_stats.py) pulls the metrics of my [Google Scholar profile](https://scholar.google.com/citations?user=khPqHmgAAAAJ&hl=en) via the `scholarly` package, writes them to `_data/scholar.yml`, and plots citations per year. It runs daily via [GitHub Actions](.github/workflows/update-scholar-stats.yml).
- [Teachingevaluations](code/teachingevaluations) generates two plots: First, The time trend of students' [quantitative evaluations](code/teachingevaluations/EvalOverTime.R) of my courses. Second, a wordcloud (and some other stuff) of the [qualitative evaluations](code/teachingevaluations/evalationwordclouds.R) (although I do not upload the raw data due to potential privacy issues).

The repository was forked (then detached) by [Stuart Geiger](https://github.com/staeiou) from the [Minimal Mistakes Jekyll Theme](https://mmistakes.github.io/minimal-mistakes/), which is © 2016 Michael Rose and released under the MIT License. See LICENSE.md.
See more info at https://academicpages.github.io/
