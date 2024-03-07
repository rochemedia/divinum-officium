import os
import pathlib
import re

# Define a regular expression for matching Bible references in the text
CITATION_REGEX = r"^\s*(?:!)\s*(?P<book>(?:\d\s)?\w+)\s*(?P<chapter>\d+)(?::|,\s*)(?P<verses>\d+-?\d*,?\d*)\s*$"

def fix_encoding(path: pathlib.Path):
    """
    Fix any encoding issues with the given file path. If the file content cannot be decoded using UTF-8, try using windows-1252 encoding instead.
    If successful, convert the file content to UTF-8 encoding.

    Args:
    path (pathlib.Path): The file path to fix the encoding for.
    """
    try:
        content = path.read_text()
    except UnicodeDecodeError:
        content = path.read_text(encoding="windows-1252")
        path.write_text(content, encoding="utf-8")

def fix_bible_references(path: pathlib.Path):
    """
    Fix the formatting of Bible references in the given file path. If the file has a '.txt' extension, search for Bible references in the file content
    and fix their formatting according to the defined regular expression.

    Args:
    path (pathlib.Path): The file path to fix the Bible references for.
    """
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
    """
    The main function that iterates through all the files in the current directory and its subdirectories, and fixes their encoding and Bible references.
    It skips files with certain
