#!/usr/bin/env python3
import os
import re
import subprocess
from pathlib import Path

root = Path(__file__).resolve().parents[1]
source_md = root / "content" / "assignment" / "02-lab.md"
temp_md = root / "content" / "assignment" / "02-lab-pandoc.md"
output_pdf = root / "content" / "assignment" / "02-lab.pdf"

raw_text = source_md.read_text()
if raw_text.startswith("---"):
    parts = raw_text.split("---", 2)
    if len(parts) >= 3:
        raw_text = parts[2]
text = raw_text.strip()

text = text.replace("**[Print-friendly pdf](../02-lab.pdf)**\n", "")
text = text.replace("## Lab Content\n", "")

front_matter = """---
geometry: margin=1in
mainfont: "FiraSans"
header-includes:
  - \\usepackage[sfdefault]{FiraSans}
  - \\usepackage{fancyhdr}
  - \\fancyhf{}
  - \\renewcommand{\\headrulewidth}{0pt}
  - \\renewcommand{\\footrulewidth}{0pt}
---

"""

text = f"{front_matter}{text}"

def figure_repl(match):
    src = match.group("src")
    title = match.group("title") or Path(src).stem
    candidate = Path(src)
    search_dirs = [
        root / "static" / "media",
        root / "content" / "assignment",
        root / "assets" / "images",
    ]
    asset = None
    for parent in search_dirs:
        path = parent / candidate.name
        if path.exists():
            asset = path
            break
    if asset is None:
        for path in root.rglob(candidate.name):
            if path.is_file():
                asset = path
                break
    if asset is None:
        asset = candidate
    rel_path = os.path.relpath(asset, temp_md.parent)
    return f"![{title}]({rel_path}){{width=50%}}"

text = re.sub(
    r"{{< figure[^>]*src=\"(?P<src>[^\"]+)\"[^>]*title=\"(?P<title>[^\"]*)\"[^>]*>}}",
    figure_repl,
    text,
)
text = re.sub(
    r"{{< youtube (?P<id>[^ >]+) >}}",
    lambda m: f"[YouTube video](https://www.youtube.com/watch?v={m.group('id')})",
    text,
)

temp_md.write_text(text)

pandoc_cmd = [
    "pandoc",
    temp_md.name,
    "-o",
    str(output_pdf),
    "--pdf-engine=pdflatex",
    "-V",
    "geometry:margin=1in",
]

subprocess.run(pandoc_cmd, check=True, cwd=temp_md.parent)

temp_md.unlink()
