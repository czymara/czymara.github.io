---
permalink: /
title: "Welcome"
excerpt: "About me"
author_profile: true
redirect_from: 
  - /about/
  - /about.html
---

<style>
.recent { margin: 1.6em 0 0 0; padding: 0.8em 1.1em; background: #f8f8f8; border-left: 3px solid #ddd; font-size: 0.88em; line-height: 1.5; }
.recent .recent-head { font-variant: small-caps; letter-spacing: 0.04em; color: #666; margin-bottom: 0.5em; }
.recent p { margin: 0 0 0.55em 0; }
.recent p:last-child { margin-bottom: 0; }
.recent .venue { color: #555; }
</style>

I am a Senior Researcher at the [Netherlands Interdisciplinary Demographic Institute](https://nidi.nl/en/employees/christian-czymara/) (Royal Netherlands Academy of Arts and Sciences), working in the *Migration* and *Open Science* Departments, and affiliated with the [University of Groningen](https://www.rug.nl/staff/c.s.czymara/?lang=en).

My [research](/research/) focuses on social cohesion in ethnically diverse societies, and I approach it from two directions. The first examines what the public thinks about migration, what the media writes, and how the two are connected. The second concerns relations among ethinic minority groups and the views they hold. Methodologically, I combine advanced survey analysis with computational social science methods.

Two current projects carry this agenda forward: [Crossing Boundaries](https://www.nwo.nl/en/projects/tqapl20708), funded by the Dutch Research Council, and [social cohesion in ethnically diverse schools](https://socion-program.org/project/rethinking-social-cohesion-in-ethnically-diverse-schools-linking-horizontal-and-vertical-ties/) as part of [SOCION](https://socion-program.org/people/christian-czymara/).

My work has been published in journals like Social Forces, European Sociological Review, European Journal of Political Research, and Journal of Ethnic and Migration Studies, and has been taken up by policy institutions and international news [media](/media/). I serve as an Associate Editor of the [Journal of Computational Social Science](https://link.springer.com/journal/42001).

My [course materials](/teaching/) on multilevel modelling, panel data analysis, and computational social science are openly available.

Before joining NIDI, I worked at Goethe University Frankfurt, Tel Aviv University, and the University of Cologne, where I did my PhD.

{% if site.data.recent %}
<div class="recent">
  <div class="recent-head">Recent publications</div>
  {% for item in site.data.recent %}
  <p><a href="{{ item.url }}">{{ item.title }}</a> <span class="venue"><em>{{ item.venue }}</em>, {{ item.year }}</span></p>
  {% endfor %}
</div>
{% endif %}
