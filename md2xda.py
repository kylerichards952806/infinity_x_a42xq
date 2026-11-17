#!/usr/bin/env python3
"""Render the Infinity-X A42 release post markdown as XDA (XenForo) BBCode.

The markdown post is the source of truth. Run this after editing it:

    python3 md2xda.py

Both paths default to files next to this script, so it works from any
working directory. Optional arguments override them:

    python3 md2xda.py path/to/post.md path/to/post-bbcode.txt

Formatting covers what the release post uses: headings, bold, inline code,
fenced code blocks, bullet lists (including one nested level), markdown
links, bare URLs and pipe tables. Checksums and filenames are kept inside
[CODE] blocks so the editor does not mangle them.
"""

import argparse
import re
import sys
from pathlib import Path

REPO = Path(__file__).resolve().parent
DEFAULT_INPUT = REPO / "release-post-infinityx-a42xq-17.md"
DEFAULT_OUTPUT = REPO / "release-post-infinityx-a42xq-17-xda-bbcode.txt"

SIZE_BY_LEVEL = {1: 6, 2: 6, 3: 5, 4: 4}


def inline(text):
    text = re.sub(r"\[([^\]]+)\]\(([^)]+)\)", r"[URL='\2']\1[/URL]", text)
    text = re.sub(r"\*\*(.+?)\*\*", r"[B]\1[/B]", text)
    text = re.sub(r"`([^`]+)`", r"[ICODE]\1[/ICODE]", text)
    text = re.sub(
        r"(?<![='\]])https?://[^\s)\]]+",
        lambda m: "[URL]%s[/URL]" % m.group(0),
        text,
    )
    return text


def convert(md):
    lines = md.splitlines()
    out = []
    i = 0
    while i < len(lines):
        line = lines[i]
        if not line.strip():
            out.append("")
            i += 1
            continue
        if line.strip() == "---":
            out.append("[HR][/HR]")
            i += 1
            continue
        if line.startswith("```"):
            i += 1
            block = []
            while i < len(lines) and not lines[i].startswith("```"):
                block.append(lines[i])
                i += 1
            i += 1
            out.append("[CODE]" + "\n".join(block) + "[/CODE]")
            continue
        if line.startswith("|"):
            rows = []
            while i < len(lines) and lines[i].startswith("|"):
                rows.append(lines[i])
                i += 1
            rows = [r for r in rows if not re.match(r"^\|[\s\-:|]+\|$", r)]
            out.append("[LIST]")
            for row in rows:
                cells = [c.strip() for c in row.strip().strip("|").split("|")]
                if len(cells) == 4:
                    out.append(
                        "[*][B]%s[/B] (%s) — %s — %s"
                        % tuple(inline(c) for c in cells)
                    )
                else:
                    out.append("[*]" + " — ".join(inline(c) for c in cells))
            out.append("[/LIST]")
            continue
        if re.match(r"^\s*- ", line):
            out.append("[LIST]")
            while i < len(lines) and re.match(r"^\s*- ", lines[i]):
                nested = lines[i].startswith("  - ")
                text = re.sub(r"^\s*- ", "", lines[i])
                out.append("[*]" + ("– " if nested else "") + inline(text))
                i += 1
            out.append("[/LIST]")
            continue
        heading = re.match(r"^(#{1,4})\s+(.*)$", line)
        if heading:
            level = len(heading.group(1))
            text = inline(heading.group(2))
            if level == 1:
                text = (
                    "Project Infinity-X 4.2 (Android 17) for the "
                    "Samsung Galaxy A42 5G"
                )
            out.append("")
            out.append("[SIZE=%d][B]%s[/B][/SIZE]" % (SIZE_BY_LEVEL[level], text))
            out.append("")
            i += 1
            continue
        out.append(inline(line))
        i += 1
    return "\n".join(out).strip() + "\n"


def main():
    parser = argparse.ArgumentParser(description=__doc__.splitlines()[0])
    parser.add_argument("input", nargs="?", default=str(DEFAULT_INPUT))
    parser.add_argument("output", nargs="?", default=str(DEFAULT_OUTPUT))
    args = parser.parse_args()

    source = Path(args.input)
    target = Path(args.output)
    if not source.is_file():
        sys.exit("input not found: %s" % source)

    body = convert(source.read_text(encoding="utf-8"))
    target.write_text(body, encoding="utf-8")

    print("wrote %s (%d lines, %d bytes) from %s" % (
        target, body.count("\n"), len(body.encode("utf-8")), source))


if __name__ == "__main__":
    main()
