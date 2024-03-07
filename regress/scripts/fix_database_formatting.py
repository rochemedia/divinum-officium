import os
import pathlib
import re

CITATION_REGEX = r"^\s*(?:!)\s*(?P<book>(?:\d\s)?\w+)\s*(?P<chapter>\d+)(?::|,\s*)(?P<verses>\d+-?\d*,?\d*)\s*$"

def fix_encoding(path: pathlib.Path):
    try:
        content = path.read_text()
    except UnicodeDecodeError:
        content = path.read_text(encoding="windows-1252")
        path.write_text(content, encoding="utf-8")

def fix_bible_references(path: pathlib.Path):
    if not path.suffix == ".txt":
        return
    content = path.read_text()
    fixed_whitespace = re.sub(
        CITATION_REGEX, r"!\g<book> \g<chapter>:\g<verses>", content, flags=re.MULTILINE
    )
    if fixed_whitespace == content:
        return
    path.write_text(fixed_whitespace)

def main():
    for path in pathlib.Path(".").rglob("*"):
        if path.is_file() and path.suffix not in (
                ".gif",
                ".ico",
                ".jpg",
                ".pdf",
                ".png",
                ".ttf",
        ):
            fix_encoding(path)
            fix_bible_references(path)

if __name__ == "__main__":
    main()
