#!/usr/bin/env python3
"""Convert a little-endian RISC-V binary into 32-bit readmemh words."""

from __future__ import annotations

import argparse
from pathlib import Path


def iter_words(data: bytes):
    padded_len = (len(data) + 3) & ~3
    data = data.ljust(padded_len, b"\x00")
    for offset in range(0, len(data), 4):
        yield int.from_bytes(data[offset : offset + 4], "little")


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("input", type=Path)
    parser.add_argument("output", type=Path)
    args = parser.parse_args()

    data = args.input.read_bytes()
    args.output.parent.mkdir(parents=True, exist_ok=True)
    with args.output.open("w", encoding="ascii", newline="\n") as out_file:
        for word in iter_words(data):
            out_file.write(f"{word:08x}\n")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
