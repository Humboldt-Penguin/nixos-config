# /// script
# requires-python = ">=3.12"
# dependencies = []
# ///

"""
backup.py — Create a compressed backup of a file or directory.

Usage:
    python backup.py <target> [--dereference] [--utc]

Rules:
    - If <target> is a file like "name.ext", create "name__backup_YYMMDD-HHMM.ext.tar.gz"
    - If <target> is a directory like "name", create "name__backup_YYMMDD-HHMM.tar.gz"

The archive is created in the parent directory of <target>.
"""


from __future__ import annotations

import argparse
import sys
import tarfile
from datetime import datetime, timezone
from pathlib import Path





def _split_name_for_file_naming(p: Path) -> tuple[str, str]:
    """
    Return (base, ext_for_naming) for a file path.

    - Single extension: "report.txt" -> ("report", ".txt")
    - Multi-part kept together: "archive.tar.gz" -> ("archive", ".tar.gz")
    - No extension: "LICENSE" -> ("LICENSE", "")
    - Dotfiles (hidden): ".bashrc" -> (".bashrc", "")
    """

    # Multi-part extensions we want to keep together when naming backups
    _MULTI_EXTS: set[tuple[str, str]] = {
        (".tar", ".gz"),
        (".tar", ".bz2"),
        (".tar", ".xz"),
        (".tar", ".zst"),
        (".tar", ".Z"),
    }

    name = p.name

    # Treat lone-dot hidden files as no-extension
    if name.startswith(".") and name.count(".") == 1:
        return name, ""

    suffixes = p.suffixes
    if len(suffixes) >= 2 and tuple(suffixes[-2:]) in _MULTI_EXTS:
        ext = "".join(suffixes[-2:])
        base = name[: -len(ext)]
        if base.endswith("."):
            base = base[:-1]
        return base, ext

    # default: last suffix only
    return p.stem, (suffixes[-1] if suffixes else "")



def _timestamp(use_utc: bool) -> str:
    # YYMMDD-HHMM from local time (default) or UTC
    now = datetime.now(timezone.utc) if use_utc else datetime.now()
    return now.strftime("%y%m%d-%H%M")



def _candidate_archive_path(
    target: Path,
    base: str,
    ext_for_naming: str,
    timestamp: str,
) -> Path:
    """Construct the initial (non-unique) archive path in target's parent directory."""
    name = f"{base}__backup_{timestamp}{ext_for_naming}.tar.gz"
    return target.parent / name



def _ensure_unique(path: Path) -> Path:
    """If path exists, append -02, -03, ... before .tar.gz to avoid clobbering."""
    if not path.exists():
        return path
    suffix = ".tar.gz"
    stem = path.name[: -len(suffix)]
    for i in range(2, 1000):
        candidate = path.with_name(f"{stem}-{i:02d}{suffix}")
        if not candidate.exists():
            return candidate
    raise FileExistsError("Could not find a unique filename after 999 attempts.")



def _skip_self_filter(archive_leafname: str):
    """
    Return a tarfile filter that skips the archive file itself if encountered.
    The filter receives a TarInfo and should return TarInfo or None.
    """
    def _filter(ti: tarfile.TarInfo) -> tarfile.TarInfo | None:
        # Tar member names always use forward slashes.
        leaf = ti.name.rsplit("/", 1)[-1]
        if leaf == archive_leafname:
            return None
        return ti
    return _filter



def create_backup(
    target: Path,
    *,
    dereference: bool = False,
    use_utc: bool = False,
) -> Path:
    # NOTE: we intentionally *don't* resolve() so symlinks keep their original name.
    target = target.expanduser()

    if not target.exists():
        raise FileNotFoundError(f"Target does not exist: {target}")

    timestamp = _timestamp(use_utc)

    if target.is_dir():
        base = target.name if target.name not in (".", "") else target.resolve().name
        ext_for_naming = ""
    elif target.is_file():
        base, ext_for_naming = _split_name_for_file_naming(target)
        # If you *don't* want archive.tar.gz → ...tar.gz.tar.gz, uncomment next line:
        # if ext_for_naming == ".tar.gz": ext_for_naming = ""
    else:
        raise ValueError(f"Target is neither a regular file nor a directory: {target}")

    archive_path = _candidate_archive_path(target, base, ext_for_naming, timestamp)
    archive_path = _ensure_unique(archive_path)

    # Create tar.gz; arcname keeps the original top-level name (no parent dirs).
    arcname = target.name
    if arcname in (".", ""):
        arcname = target.resolve().name

    # Use tarfile.open(..., dereference=...) to match --dereference flag.
    with tarfile.open(archive_path, mode="w:gz", dereference=dereference) as tar:
        tar.add(
            target,
            arcname=arcname,
            recursive=True,
            # follow_symlinks is not a valid TarFile.add() kwarg in 3.12/3.13
            filter=_skip_self_filter(archive_path.name),
        )

    return archive_path





def main(argv=None) -> int:
    parser = argparse.ArgumentParser(
        description="Create a compressed backup of a file or directory."
    )
    parser.add_argument(
        "target", help="Path to an existing file or directory to back up."
    )
    parser.add_argument(
        "--dereference",
        action="store_true",
        help="Follow symlinks (store the files they point to).",
    )
    parser.add_argument(
        "--utc",
        action="store_true",
        help="Use UTC time for the timestamp instead of local time.",
    )
    args = parser.parse_args(argv)

    try:
        archive = create_backup(
            Path(args.target),
            dereference=args.dereference,
            use_utc=args.utc,
        )
    except Exception as e:
        print(f"Error: {e}", file=sys.stderr)
        return 1

    print(f"Created backup: {archive}")
    return 0



if __name__ == "__main__":
    raise SystemExit(main())
