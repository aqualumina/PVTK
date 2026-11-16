"""Auto-translate Google Sheet rows >= min_rows via Gemini API and update OTA dict_en.txt."""

import argparse
import json
import os
import sys
import urllib.error
import urllib.parse
import urllib.request

GEMINI_MODEL = os.environ.get("GEMINI_MODEL", "gemini-2.5-flash")
BATCH_SIZE = 40

GAMES = {
    "pvtk1": "pvtk1/ota",
    "pvtk2": "pvtk2/ota",
}


def http_get_json(url: str) -> dict:
    req = urllib.request.Request(url, headers={"User-Agent": "PVTK-Auto-OTA/1.0"})
    with urllib.request.urlopen(req, timeout=60) as resp:
        return json.loads(resp.read().decode("utf-8"))


def translate_batch_gemini(items: list[str], api_key: str) -> list[str]:
    """Translate a batch of Vietnamese game strings to English using Gemini API."""
    prompt = (
        "You are translating Vietnamese MMORPG (Phong Van Truyen Ky / The World Online) "
        "game strings into concise, natural English.\n"
        "Rules:\n"
        "1. Preserve all formatting codes/placeholders EXACTLY: /cXXXXXX, /p, %U, %s, %d, \\n, \\t.\n"
        "2. Keep item/skill/quest names concise and RPG-appropriate.\n"
        "3. Return ONLY a JSON array of translated strings in the exact same order and length as the input.\n\n"
        f"Input JSON array:\n{json.dumps(items, ensure_ascii=False)}"
    )

    url = f"https://generativelanguage.googleapis.com/v1beta/models/{GEMINI_MODEL}:generateContent?key={api_key}"
    payload = {
        "contents": [{"parts": [{"text": prompt}]}],
        "generationConfig": {
            "temperature": 0.2,
            "responseMimeType": "application/json",
        },
    }
    data = json.dumps(payload).encode("utf-8")
    req = urllib.request.Request(
        url,
        data=data,
        headers={"Content-Type": "application/json"},
        method="POST",
    )
    with urllib.request.urlopen(req, timeout=120) as resp:
        res = json.loads(resp.read().decode("utf-8"))

    text = res["candidates"][0]["content"]["parts"][0]["text"]
    translated = json.loads(text)
    if not isinstance(translated, list) or len(translated) != len(items):
        raise ValueError(f"Gemini returned {len(translated) if isinstance(translated, list) else type(translated)} items, expected {len(items)}")
    return [str(x).replace("\t", " ").replace("\r", "").replace("\n", "\\n").strip() for x in translated]


def bump_version(version_path: str) -> str:
    cur = "1.0"
    if os.path.exists(version_path):
        with open(version_path, "r", encoding="utf-8") as f:
            cur = f.read().strip() or "1.0"
    if "." in cur:
        major, minor = cur.rsplit(".", 1)
        new_ver = f"{major}.{int(minor) + 1}"
    else:
        new_ver = str(int(cur) + 1)
    with open(version_path, "w", encoding="utf-8", newline="\n") as f:
        f.write(new_ver + "\n")
    return new_ver


def update_dict_file(dict_path: str, entries: list[tuple[str, str, str]]) -> int:
    existing = {}
    order = []
    if os.path.exists(dict_path):
        with open(dict_path, "r", encoding="utf-8") as f:
            for line in f:
                line = line.rstrip("\r\n")
                if not line:
                    continue
                parts = line.split("\t")
                if len(parts) >= 3:
                    uid = (parts[0], parts[1])
                    if uid not in existing:
                        order.append(uid)
                    existing[uid] = "\t".join(parts[2:])

    added = 0
    for typ, key, eng in entries:
        uid = (typ, key)
        if not eng:
            continue
        if uid not in existing:
            order.append(uid)
            added += 1
        existing[uid] = eng

    with open(dict_path, "w", encoding="utf-8", newline="\n") as f:
        for uid in order:
            f.write(f"{uid[0]}\t{uid[1]}\t{existing[uid]}\n")
    return added


def process_game(game: str, ota_dir: str, apps_url: str, secret: str, api_key: str, min_rows: int) -> bool:
    params = urllib.parse.urlencode({"action": "export", "game": game, "secret": secret})
    sep = "&" if "?" in apps_url else "?"
    export_url = f"{apps_url}{sep}{params}"

    print(f"[{game}] Checking sheet rows...")
    data = http_get_json(export_url)
    rows = data.get("rows", [])
    print(f"[{game}] Found {len(rows)} pending rows (threshold: {min_rows}).")

    if len(rows) < min_rows:
        return False

    to_translate_idx = []
    to_translate_txt = []
    resolved = []

    for idx, row in enumerate(rows):
        typ = str(row[0]).strip()
        key = str(row[1]).strip()
        vn = str(row[2]).strip()
        en = str(row[3]).strip() if len(row) > 3 else ""
        resolved.append([typ, key, en])
        if not en and vn:
            to_translate_idx.append(idx)
            to_translate_txt.append(vn)

    for start in range(0, len(to_translate_txt), BATCH_SIZE):
        batch_txt = to_translate_txt[start : start + BATCH_SIZE]
        batch_idx = to_translate_idx[start : start + BATCH_SIZE]
        print(f"[{game}] Translating batch {start + 1}-{start + len(batch_txt)} / {len(to_translate_txt)}...")
        translated = translate_batch_gemini(batch_txt, api_key)
        for i, eng in zip(batch_idx, translated):
            resolved[i][2] = eng

    entries = [(r[0], r[1], r[2]) for r in resolved if r[2]]
    dict_path = os.path.join(ota_dir, "dict_en.txt")
    added = update_dict_file(dict_path, entries)
    new_ver = bump_version(os.path.join(ota_dir, "version.txt"))

    files_path = os.path.join(ota_dir, "files.txt")
    if os.path.exists(files_path):
        with open(files_path, "r", encoding="utf-8") as f:
            flines = [l.strip() for l in f if l.strip()]
    else:
        flines = []
    if "dict_en.txt" not in flines:
        flines.insert(0, "dict_en.txt")
        with open(files_path, "w", encoding="utf-8", newline="\n") as f:
            f.write("\n".join(flines) + "\n")

    print(f"[{game}] Updated {dict_path} (+{added} new entries), bumped version to {new_ver}.")
    return True


def sync_game(game: str, apps_url: str, secret: str):
    params = urllib.parse.urlencode({"action": "sync", "game": game, "secret": secret})
    sep = "&" if "?" in apps_url else "?"
    res = http_get_json(f"{apps_url}{sep}{params}")
    print(f"[{game}] Sheet sync result: {res}")


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--min-rows", type=int, default=700)
    parser.add_argument("--sync-games", nargs="*", default=[])
    args = parser.parse_args()

    apps_url = os.environ.get("APPS_SCRIPT_URL", "").strip()
    secret = os.environ.get("APPS_SCRIPT_SECRET", "").strip()
    api_key = os.environ.get("GEMINI_API_KEY", "").strip()

    if not apps_url:
        print("ERROR: APPS_SCRIPT_URL is not set", file=sys.stderr)
        sys.exit(1)

    if args.sync_games:
        for g in args.sync_games:
            sync_game(g, apps_url, secret)
        return

    if not api_key:
        print("ERROR: GEMINI_API_KEY is not set", file=sys.stderr)
        sys.exit(1)

    updated = []
    for game, ota_dir in GAMES.items():
        if process_game(game, ota_dir, apps_url, secret, api_key, args.min_rows):
            updated.append(game)

    github_output = os.environ.get("GITHUB_OUTPUT")
    if github_output:
        with open(github_output, "a", encoding="utf-8") as f:
            f.write(f"updated_games={' '.join(updated)}\n")


if __name__ == "__main__":
    main()
