---
title: "Czymara Courses"
permalink: /courses/
redirect_from:
  - /teach/
  - /teaching/
---

<style>.page__title { display: none; }</style>
<style>
.courses-banner { position: relative; overflow: hidden; display: flex; align-items: center; justify-content: space-between; gap: 1.5em; margin: 0 0 1.6em 0; padding: 1.3em 1.5em; background: #f8f8f8; border: 1px solid #ddd; border-left: 4px solid var(--global-base-color); border-radius: 6px; }
.courses-banner__label { font-size: 0.75em; font-weight: bold; text-transform: uppercase; letter-spacing: 0.12em; color: var(--global-base-color); margin: 0 0 0.3em 0; }
.courses-banner__title { font-size: 1.5em; font-weight: bold; line-height: 1.25; margin: 0 0 0.35em 0; color: var(--global-text-color); }
.courses-banner__meta { font-size: 0.8em; color: var(--global-text-color); opacity: 0.75; margin: 0 0 0.8em 0; }
.courses-banner__meta a { color: inherit; }
.courses-banner__tags { display: flex; flex-wrap: wrap; gap: 0.4em; margin: 0; padding: 0; list-style: none; }
.courses-banner__tags li { margin: 0; padding: 0.15em 0.65em; font-size: 0.72em; color: var(--global-base-color); border: 1px solid var(--global-base-color); border-radius: 999px; }
.courses-banner__art { flex: 0 0 auto; width: 170px; height: 110px; color: var(--global-base-color); }
html[data-theme="dark"] .courses-banner { background: var(--global-footer-bg-color); border-color: var(--global-border-color); border-left-color: var(--global-base-color); }
@media (max-width: 700px) { .courses-banner__art { display: none; } }
</style>

<div class="courses-banner">
  <div>
    <div class="courses-banner__label">Czymara Courses</div>
    <div class="courses-banner__title">Quantitative &amp; Computational Methods Courses</div>
    <div class="courses-banner__meta">Dr. Christian S. Czymara · <a href="https://github.com/czymaracourses">github.com/czymaracourses</a></div>
    <ul class="courses-banner__tags">
      <li>R</li><li>Text Analysis</li><li>Machine Learning</li><li>Survey Methods</li><li>Statistics</li>
    </ul>
  </div>
  <svg class="courses-banner__art" viewBox="0 0 170 110" aria-hidden="true">
    <g stroke="currentColor" stroke-opacity="0.25" stroke-width="1">
      <line x1="10" y1="100" x2="165" y2="100"/><line x1="10" y1="100" x2="10" y2="5"/>
    </g>
    <g fill="currentColor" fill-opacity="0.45">
      <circle cx="24" cy="86" r="3"/><circle cx="35" cy="78" r="3"/><circle cx="44" cy="84" r="3"/><circle cx="55" cy="70" r="3"/>
      <circle cx="66" cy="74" r="3"/><circle cx="76" cy="60" r="3"/><circle cx="86" cy="64" r="3"/><circle cx="97" cy="50" r="3"/>
      <circle cx="108" cy="54" r="3"/><circle cx="118" cy="40" r="3"/><circle cx="130" cy="44" r="3"/><circle cx="141" cy="30" r="3"/>
      <circle cx="152" cy="26" r="3"/>
    </g>
    <line x1="18" y1="90" x2="160" y2="24" stroke="currentColor" stroke-width="2" stroke-linecap="round"/>
  </svg>
</div>

I teach quantitative methods and research design to social science students (full-semester courses, condensed research trainings, summer schools, and workshops) at Goethe University Frankfurt, the University of Cologne, and elsewhere, with a mean student evaluation of 1.5 (1.0 being the best score).

Below is a selection of courses with materials in open access. For a collection of my teaching repositories, please visit [Czymara Courses](https://github.com/czymaracourses).

Open-access Full Courses and Research Trainings
======

Computational Social Science
------

This full-semester course provides an introduction to computational social science and equips students with the skills to analyze large datasets, apply machine learning models, and use natural language processing for text analysis. It covers the full pipeline of computational data analysis, from data collection and preprocessing to data analysis and interpretation - all based on publicly available data. The course materials are openly accessible in this [GitHub repository](https://github.com/czymaracourses/CSS).

Longitudinal Data Analysis
------

I am regularly teaching on the analysis of longitudinal data in R, including a full semester [research training](https://github.com/czymaracourses/LongDataAnalysis) or a condensed two-day [summer school course](https://github.com/czymaracourses/PanelReg) (*note:* the materials are currently offline). Both formats include lectures and practical tutorials. This course introduces the essential tools for analyzing panel data in the social sciences to assess trends over time and explore causal relationships. Participants learn to manage panel data workflows in R, covering data sourcing, preparation, and analysis techniques.

Multilevel Modelling
------

My comprehensive research training [Comparative Social Research with Multi-level Modelling in R](https://github.com/czymaracourses/CompSocResearch) is fully available in open access. The curriculum is structured around data from the [European Social Survey](https://www.europeansocialsurvey.org/), with 15 sessions, each including a 90-minute lecture and a 90-minute tutorial, providing a balance of theoretical grounding and practical application. This course offers a thorough, hands-on approach to comparative social research, covering both introductory and advanced multilevel modeling.

The materials for the course are also available in Stata. Write me an email if you are interested.

Open-access Short Courses
======

Introductions to R and Python
------

If you're interested in mastering the basics of R and Python, I've created interactive Colabs to help you build an intuitive understanding of [R](https://colab.research.google.com/github/czymaracourses/intros/blob/main/Intro_to_R.ipynb)'s core logic and essential functions, along with their [Python](https://colab.research.google.com/github/czymaracourses/intros/blob/main/Intro_to_Python.ipynb) equivalents.

Topic Modelling
------

My workshop [Topic Modelling in R and Python](https://sites.google.com/view/dariia-mykhailyshyna/main/r-workshops-for-ukraine#h.k2gh03lf4lre), part of the [Workshops for Ukraine](https://sites.google.com/view/dariia-mykhailyshyna/main/r-workshops-for-ukraine) series, is freely accessible. You can find the workshop slides [here](https://czymaracourses.github.io/TopicModelling/topic_models_Ukraine_23.html#/title-slide). For a hands-on experience, explore the interactive Colab notebooks: the first Colab focuses on [R implementations](https://colab.research.google.com/github/czymaracourses/TopicModelling/blob/main/topic_models_R.ipynb), the second covers [Python applications](https://colab.research.google.com/github/czymaracourses/TopicModelling/blob/main/topic_models_BERTopic.ipynb). These materials provide practical guidance for applying topic modeling techniques in both R and Python, using real newspaper texts as examples.

Courses Taught
======

*Student evaluations in parentheses; 1.0 is the best possible score. Goethe University Frankfurt used a 1–6 scale, the University of Cologne a 1–5 scale.*

<img src="/code/teachingevaluations/out/evalovertime.png" width="350" height="350" alt="Teaching evaluation scores over time" style="float:right; margin-left:1em;">

- Apr 2026: Introduction to Migration & Migrants Research (PhD course), NIDI
- Jan 2026: Migration, Families and Households (MA Population Studies, guest lecture), University of Groningen
- Jun 2025: Von Nationen und Narrativen: Identitäten in multiethnischen Gesellschaften (*Of Nations and Narratives: Identities in Multi-ethnic Societies*, Ringvorlesung), Johannes Gutenberg University Mainz
- Winter 2024/25: Computational Social Science, Goethe University Frankfurt (GU) (1.2/6)
- Oct 2023: Introduction to Topic Modelling in R and Python, Workshops for Ukraine (online)
- Aug 2023: Einführung in die Panelregression (*Introduction to Panel Regression*), DeZIM Summer School
- Jul 2023: BIGSSS Summer School on Computational Social Science of Democratic Debate: Topic Models, Constructor University
- Jan 2023: IGS3 Excellence group (guest lecture), Tel Aviv University
- Summer 2022: Längsschnittdatenanalyse in R (*Longitudinal Data Analysis in R*), GU (1.5/6)
- Winter 2021/22: Vergleichende Sozialforschung mit Mehrebenenmodellen in R (*Comparative Social Research with Multilevel Models in R*), GU (1.8/6)
- Aug 2021: Multilevel Analysis, Frankfurt Digital Summer School
- Summer 2021: Längsschnittdatenanalyse und Kausalität (*Longitudinal Data Analysis and Causality*), GU (1.2/6)
- Jun 2021: Politische Soziologie I (*Political Sociology I*, guest lecture), University of Bamberg (online)
- Winter 2020/21: Längsschnittdatenanalyse und Kausalität (*Longitudinal Data Analysis and Causality*), GU (1.2/6)

<div style="width:350px; height:350px; float: right;">
  <img src="/code/teachingevaluations/out/lehrewordcloud.png" width="350" height="350" alt="Student evaluations" style="display: block; margin: auto;">
  <figcaption style="text-align: center;">Student evaluations of my courses</figcaption>
</div>

- Summer 2020: Längsschnittdatenanalyse und Kausalität (*Longitudinal Data Analysis and Causality*), GU (1.4/6)
- Winter 2019/20: Vergleichende Sozialforschung mit Mehrebenenmodellen (*Comparative Social Research with Multilevel Models*), GU (1.5/6)
- Summer 2019: Analyzing longitudinal data and the issue of causality, GU (1.4/6)
- Winter 2018/19: Quantitative comparative social research with multi-level modeling, GU (1.6/6)
- Summer 2018: An applied introduction into quantitative comparative social research, GU (1.7/5)
- Winter 2017/18: Analysis of cross-sectional data (as tutor), University of Cologne (UzK) (1.4/5)
- Summer 2017: Analysis of longitudinal data (as tutor), UzK
- Winter 2016/17: Analysis of cross-sectional data (as tutor), UzK (1.6/5)
- Summer 2016: Analysis of longitudinal data (as tutor), UzK (2.0/5)

