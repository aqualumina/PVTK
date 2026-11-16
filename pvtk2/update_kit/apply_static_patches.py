import json
import os
import re
import struct
import xml.etree.ElementTree as ET

UNICODE_STR_PAT = re.compile(r'"((?:[^"\r\n\\]|\\.)*\\u[0-9a-fA-F]{4}(?:[^"\r\n\\]|\\.)*)"')

# 1. Smali strings
with open("work/matched_smali_strings.json", "r", encoding="utf-8") as f:
    smali_map = json.load(f)
with open("work/remaining_en_clean.json", "r", encoding="utf-8") as f:
    smali_map.update(json.load(f))

GAME_DIRS = [
    "base_pvtk2/smali/cmn/phongvan",
    "base_pvtk2/smali_classes2/com/hz",
    "base_pvtk2/smali_classes2/com/lori",
    "base_pvtk2/smali_classes2/javax/microedition",
    "base_pvtk2/smali_classes2/online/cmn",
]

def patch_smali():
    smali_files_changed = 0
    smali_strings_replaced = 0

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

                cnt = 0

                def repl(m):
                    nonlocal cnt
                    key = m.group(1)
                    if key in smali_map:
                        cnt += 1
                        val = smali_map[key].replace('"', '\\"')
                        return f'"{val}"'
                    return m.group(0)

                new_txt = UNICODE_STR_PAT.sub(repl, txt)
                if cnt > 0:
                    with open(p, "w", encoding="utf-8", newline="\n") as fp:
                        fp.write(new_txt)
                    smali_files_changed += 1
                    smali_strings_replaced += cnt

    print(f"Smali: updated {smali_files_changed} files, replaced {smali_strings_replaced} string occurrences.")


patch_smali()

# 2. Android res/values*/strings.xml
with open("work/res_en_strings.json", "r", encoding="utf-8") as f:
    res_map = json.load(f)

for xml_path in ["base_pvtk2/res/values/strings.xml", "base_pvtk2/res/values-vi/strings.xml"]:
    if not os.path.exists(xml_path):
        continue
    tree = ET.parse(xml_path)
    root = tree.getroot()
    xml_cnt = 0
    for elem in root.findall("string"):
        name = elem.attrib.get("name")
        if name in res_map and len(list(elem)) == 0:
            elem.text = res_map[name]
            xml_cnt += 1
    tree.write(xml_path, encoding="utf-8", xml_declaration=True)
    print(f"XML: updated {xml_cnt} strings in {xml_path}")

# 3. Binary .ui files
with open("work/ui_en_strings.json", "r", encoding="utf-8") as f:
    ui_map = json.load(f)

ui_dir = "base_pvtk2/assets/ui"
ui_files_changed = 0
ui_strings_replaced = 0

for fn in sorted(os.listdir(ui_dir)):
    if not fn.endswith(".ui"):
        continue
    p = os.path.join(ui_dir, fn)
    data = open(p, "rb").read()
    out = bytearray()
    i = 0
    n = len(data)
    changed = False
    while i < n:
        if i < n - 3 and data[i] == 0x0C:
            slen = struct.unpack_from(">H", data, i + 1)[0]
            if 1 <= slen <= 512 and i + 3 + slen <= n:
                raw = data[i + 3 : i + 3 + slen]
                try:
                    s = raw.decode("utf-8")
                    if s in ui_map:
                        new_raw = ui_map[s].encode("utf-8")
                        out.append(0x0C)
                        out.extend(struct.pack(">H", len(new_raw)))
                        out.extend(new_raw)
                        i += 3 + slen
                        changed = True
                        ui_strings_replaced += 1
                        continue
                except UnicodeDecodeError:
                    pass
        out.append(data[i])
        i += 1
    if changed:
        with open(p, "wb") as fp:
            fp.write(out)
        ui_files_changed += 1

print(f".ui: updated {ui_files_changed} files, replaced {ui_strings_replaced} string occurrences.")
