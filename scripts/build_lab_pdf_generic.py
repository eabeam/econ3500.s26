#!/usr/bin/env python3
import os
import re
import subprocess
import sys
from pathlib import Path


def normalize_lab_arg(arg: str) -> str:
    arg = arg.strip()
    if not arg:
        return arg
    if arg.isdigit():
        return f"{int(arg):02d}-lab.md"
    if arg.lower().startswith("lab") and arg[3:].isdigit():
        return f"{int(arg[3:]):02d}-lab.md"
    if arg.endswith("-lab"):
        return f"{arg}.md"
    if arg.endswith(".md"):
        return arg
    return arg


def extract_title(front_matter: str) -> str | None:
    for line in front_matter.splitlines():
        m = re.match(r'^\s*title:\s*["\']?(.*?)["\']?\s*$', line)
        if m:
            return m.group(1).strip()
    return None


def main() -> int:
    root = Path(__file__).resolve().parents[1]
    assignment_dir = root / "content" / "assignment"

    if len(sys.argv) > 1:
        raw_arg = sys.argv[1]
    else:
        raw_arg = input("Lab markdown file (e.g., 03-lab.md or 3): ")

    lab_arg = normalize_lab_arg(raw_arg)
    if not lab_arg:
        print("No lab file provided.")
        return 1

    source_md = Path(lab_arg)
    if not source_md.is_absolute():
        source_md = assignment_dir / source_md.name

    if not source_md.exists():
        print(f"Lab markdown not found: {source_md}")
        return 1

    temp_md = source_md.with_name(f"{source_md.stem}-pandoc.md")
    output_pdf = source_md.with_suffix(".pdf")

    raw_text = source_md.read_text()
    front_matter = ""
    if raw_text.startswith("---"):
        parts = raw_text.split("---", 2)
        if len(parts) >= 3:
            front_matter = parts[1]
            raw_text = parts[2]
    text = raw_text.strip()

    title = extract_title(front_matter)
    if not title:
        title = source_md.stem.replace("-", " ").title()
    if not title.lower().startswith("econ3500"):
        title = f"ECON3500 {title}"

    # Remove print-friendly link line(s)
    text = re.sub(r"^.*print-friendly.*\n", "", text, flags=re.IGNORECASE | re.MULTILINE)
    # Remove common section header
    text = re.sub(r"^##\\s+Lab Content\\s*$", "", text, flags=re.MULTILINE)
    # Remove emoji tokens like :eye:
    text = text.replace(":eye:", "")

    # Drop Hugo alert shortcodes, keep the content
    text = re.sub(r"^\\s*{{[%<]\\s*alert\\b[^}]*}}\\s*$", "", text, flags=re.MULTILINE)
    text = re.sub(r"^\\s*{{[%<]\\s*/alert\\b[^}]*}}\\s*$", "", text, flags=re.MULTILINE)
    text = re.sub(r"{{[%<]\\s*/?alert\\b[^}]*}}\\s*", "", text)

    # Drop Quarto callout wrappers if present
    text = re.sub(r"^\\s*:::\\s*\\{\\.callout[^}]*\\}\\s*$", "", text, flags=re.MULTILINE)
    text = re.sub(r"^\\s*:::\\s*$", "", text, flags=re.MULTILINE)

    front_matter_out = """---
geometry: margin=1in
mainfont: "FiraSans"
header-includes:
  - '\\usepackage[sfdefault]{FiraSans}'
  - '\\usepackage{fancyhdr}'
  - '\\fancyhf{}'
  - '\\lhead{ECON3500: Econometrics and Applications}'
  - '\\pagestyle{fancy}'
  - '\\renewcommand{\\headrulewidth}{0pt}'
  - '\\renewcommand{\\footrulewidth}{0pt}'
---

"""

    heading = f"""\\begin{{center}}
\\LARGE\\textbf{{{title}}}
\\end{{center}}

"""

    text = f"{front_matter_out}{heading}{text}"

    def figure_repl(match):
        src = match.group("src")
        title_match = match.group("title") or Path(src).stem
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
        return f"![{title_match}]({rel_path}){{width=50%}}"

    text = re.sub(
        r'{{< figure[^>]*src="(?P<src>[^"]+)"[^>]*title="(?P<title>[^"]*)"[^>]*>}}',
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
        "-s",
        temp_md.name,
        "-o",
        str(output_pdf),
        "--pdf-engine=pdflatex",
        "-V",
        "geometry:margin=1in",
    ]

    subprocess.run(pandoc_cmd, check=True, cwd=temp_md.parent)
    temp_md.unlink()

    print(f"Wrote: {output_pdf}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
