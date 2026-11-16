import json
import os
import re
import xml.etree.ElementTree as ET

os.makedirs("work", exist_ok=True)
UNICODE_STR_PAT = re.compile(r'"((?:[^"\r\n\\]|\\.)*\\u[0-9a-fA-F]{4}(?:[^"\r\n\\]|\\.)*)"')

with open(r"D:\REA\PVTK_English_VN\update_kit\dict\smali_strings.json", "r", encoding="utf-8") as f:
    pvtk1_dict = json.load(f)

GAME_DIRS = [
    "base_pvtk2/smali/cmn/phongvan",
    "base_pvtk2/smali_classes2/com/hz",
    "base_pvtk2/smali_classes2/com/lori",
    "base_pvtk2/smali_classes2/javax/microedition",
    "base_pvtk2/smali_classes2/online/cmn",
]

matched = {}
unmatched_viet = {}
unmatched_other = {}
occ_matched = 0

for root_dir in GAME_DIRS:
    if not os.path.isdir(root_dir):
        continue
    for dp, _, fns in os.walk(root_dir):
        for fn in fns:
            if not fn.endswith(".smali"):
                continue
            p = os.path.join(dp, fn)
            with open(p, encoding="utf-8", errors="ignore") as fp:
                txt = fp.read()
            if "\\u" not in txt:
                continue
            for m in UNICODE_STR_PAT.findall(txt):
                if m in pvtk1_dict:
                    matched[m] = pvtk1_dict[m]
                    occ_matched += 1
                else:
                    try:
                        dec = m.encode("utf-8").decode("unicode_escape")
                    except Exception:
                        dec = m
                    if any(0x00C0 <= ord(c) <= 0x1EF9 for c in dec):
                        if m not in unmatched_viet:
                            unmatched_viet[m] = dec
                    else:
                        if m not in unmatched_other:
                            unmatched_other[m] = dec

with open("work/matched_smali_strings.json", "w", encoding="utf-8") as f:
    json.dump(matched, f, ensure_ascii=False, indent=2)

with open("work/remaining_viet_smali.json", "w", encoding="utf-8") as f:
    json.dump(unmatched_viet, f, ensure_ascii=False, indent=2)

with open("work/remaining_other_smali.json", "w", encoding="utf-8") as f:
    json.dump(unmatched_other, f, ensure_ascii=False, indent=2)

print(f"Matched with PVTK1 dict: {len(matched)} unique ({occ_matched} occurrences)")
print(f"Remaining Vietnamese strings in game code: {len(unmatched_viet)}")
print(f"Remaining non-Viet unicode strings (CJK/ctrl/etc): {len(unmatched_other)}")

# Also check res/values*/strings.xml
for dp, _, fns in os.walk("base_pvtk2/res"):
    if "strings.xml" in fns:
        p = os.path.join(dp, "strings.xml")
        try:
            tree = ET.parse(p)
            viet_xml = []
            for elem in tree.getroot().findall("string"):
                t = "".join(elem.itertext())
                if any(0x00C0 <= ord(c) <= 0x1EF9 for c in t):
                    viet_xml.append((elem.attrib.get("name"), t))
            if viet_xml:
                print(f"{p}: {len(viet_xml)} Vietnamese strings")
        except Exception as e:
            print(f"{p}: parse error {e}")
