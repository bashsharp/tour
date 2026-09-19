---
title: 06-sharp
---
# `06-sharp/`

Files in this chapter (each opens on GitHub; the transcript beside a program is what `check.sh` diffs against):

{% assign dir = page.dir %}{% for f in site.static_files %}{% if f.path contains dir %}- [`{{ f.name }}`](https://github.com/bashsharp/tour/blob/main{{ f.path }})
{% endif %}{% endfor %}
[← back to the tour](../)
