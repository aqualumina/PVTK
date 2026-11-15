"""Apply existing PVTK English translations to a newly decompiled APK directory."""

import argparse
import json
import os
import re
import shutil
import sys

KIT_DIR = os.path.dirname(os.path.abspath(__file__))
UNICODE_STR_PAT = re.compile(r'"((?:[^"\\]|\\.)*\\u[0-9a-fA-F]{4}(?:[^"\\]|\\.)*)"')

HOOK_TARGETS = [
    r"com\hz\net\Message.smali",
    r"com\hz\gui\GLabel.smali",
    r"com\hz\gui\GTextArea.smali",
    r"com\hz\core\Item.smali",
    r"com\hz\core\Skill.smali",
    r"com\hz\core\Mission.smali",
    r"com\hz\core\Condition.smali",
    r"com\hz\common\Utilities.smali",
    r"com\hz\main\GameText.smali",
    r"com\hz\main\MsgHandler.smali",
    r"com\hz\ui\UIHandler.smali",
    r"com\hz\ui\XmlParse.smali",
    r"javax\microedition\lcdui\Font.smali",
    r"javax\microedition\lcdui\Graphics.smali",
]


def apply_smali_dict(smali_root: str, mapping: dict) -> tuple[int, int]:
    """Replace known unicode-escaped smali strings in-place."""
    files_changed = 0
    strings_replaced = 0

    for dp, _, fns in os.walk(smali_root):
        for fn in fns:
            if not fn.endswith(".smali"):
                continue
            path = os.path.join(dp, fn)
            txt = open(path, encoding="utf-8", errors="ignore").read()
            if "\\u" not in txt:
                continue

            count_in_file = 0

            def repl(m):
                nonlocal count_in_file
                key = m.group(1)
                if key in mapping:
                    count_in_file += 1
                    return f'"{mapping[key]}"'
                return m.group(0)

            new_txt = UNICODE_STR_PAT.sub(repl, txt)
            if count_in_file > 0:
                with open(path, "w", encoding="utf-8", newline="\n") as f:
                    f.write(new_txt)
                files_changed += 1
                strings_replaced += count_in_file

    return files_changed, strings_replaced


def scan_remaining_strings(smali_root: str) -> dict:
    """Scan remaining unicode-escaped strings that were not in the dictionary."""
    unique = {}
    for dp, _, fns in os.walk(smali_root):
        for fn in fns:
            if not fn.endswith(".smali"):
                continue
            path = os.path.join(dp, fn)
            txt = open(path, encoding="utf-8", errors="ignore").read()
            for m in UNICODE_STR_PAT.findall(txt):
                if m not in unique:
                    try:
                        dec = m.encode("utf-8").decode("unicode_escape")
                    except Exception:
                        dec = m
                    unique[m] = dec
    return unique


def check_hooks(smali_root: str) -> list[str]:
    """Return list of hook target files missing com/hz/en/Translator references."""
    missing = []
    for rel in HOOK_TARGETS:
        p = os.path.join(smali_root, rel)
        if not os.path.exists(p):
            missing.append(f"{rel} (file not found)")
            continue
        txt = open(p, encoding="utf-8", errors="ignore").read()
        if "Lcom/hz/en/Translator;" not in txt:
            missing.append(rel)
    return missing


def main():
    parser = argparse.ArgumentParser(
        description="Apply PVTK English translation kit to a newly decompiled APK folder."
    )
    parser.add_argument("target_dir", help="Path to decompiled APK directory (e.g. base_v38)")
    parser.add_argument(
        "--copy-strings-xml",
        action="store_true",
        help="Overwrite res/values/strings.xml (only use if no new XML string IDs were added)",
    )
    args = parser.parse_args()

    target = os.path.abspath(args.target_dir)
    smali_root = os.path.join(target, "smali")
    if not os.path.isdir(smali_root):
        print(f"ERROR: smali directory not found at {smali_root}", file=sys.stderr)
        sys.exit(1)

    dict_path = os.path.join(KIT_DIR, "dict", "smali_strings.json")
    mapping = json.load(open(dict_path, encoding="utf-8"))
    print(f"Loaded {len(mapping)} smali string translations.")

    files_changed, strings_replaced = apply_smali_dict(smali_root, mapping)
    print(f"Smali strings: updated {files_changed} files, replaced {strings_replaced} occurrences.")

    assets_dir = os.path.join(target, "assets")
    os.makedirs(assets_dir, exist_ok=True)
    shutil.copy2(
        os.path.join(KIT_DIR, "assets", "dict_en.txt"),
        os.path.join(assets_dir, "dict_en.txt"),
    )
    shutil.copy2(
        os.path.join(KIT_DIR, "assets", "ota_url.txt"),
        os.path.join(assets_dir, "ota_url.txt"),
    )
    shutil.copy2(
        os.path.join(KIT_DIR, "assets", "report_url.txt"),
        os.path.join(assets_dir, "report_url.txt"),
    )
    print("Copied assets/dict_en.txt, ota_url.txt, and report_url.txt.")

    en_dir = os.path.join(smali_root, "com", "hz", "en")
    os.makedirs(en_dir, exist_ok=True)
    for cls_file in ("Translator.smali", "OtaPatcher.smali", "MissReporter.smali"):
        shutil.copy2(
            os.path.join(KIT_DIR, "smali", "com", "hz", "en", cls_file),
            os.path.join(en_dir, cls_file),
        )
    print("Copied Translator.smali, OtaPatcher.smali, and MissReporter.smali.")

    unknown_src = os.path.join(KIT_DIR, "unknown")
    if os.path.isdir(unknown_src):
        unknown_dst = os.path.join(target, "unknown")
        shutil.copytree(unknown_src, unknown_dst, dirs_exist_ok=True)
        print("Copied modified unknown/ assets (.png and .ui).")

    if args.copy_strings_xml:
        res_dst = os.path.join(target, "res", "values", "strings.xml")
        os.makedirs(os.path.dirname(res_dst), exist_ok=True)
        shutil.copy2(os.path.join(KIT_DIR, "res", "values", "strings.xml"), res_dst)
        print("Copied res/values/strings.xml.")

    missing_hooks = check_hooks(smali_root)
    if missing_hooks:
        print(f"\n[!] {len(missing_hooks)} file(s) need Translator hooks (runtime server-text translation):")
        for item in missing_hooks:
            print(f"    - {item}")
    else:
        print("\n[OK] All Translator hooks are present.")

    remaining = scan_remaining_strings(smali_root)
    rem_out = os.path.join(target, "remaining_new_strings.json")
    with open(rem_out, "w", encoding="utf-8") as f:
        json.dump(remaining, f, ensure_ascii=False, indent=2)
    print(f"\nRemaining untranslated unicode strings: {len(remaining)}")
    print(f"Saved diff to: {rem_out}")


if __name__ == "__main__":
    main()
