# PVTK English Update Kit

Direktori ini berisi semua bahan translasi dan skrip patch agar ketika developer merilis APK versi baru (misalnya `v38`), kamu tidak perlu menerjemahkan dari nol.

## Isi Direktori
- `apply_update.py` — Skrip utama untuk menerapkan translasi yang sudah ada ke folder APK baru hasil decompile, sekaligus mendeteksi string baru yang belum diterjemahkan.
- `dict/smali_strings.json` — Kamus 2.993 string statis di `smali` (aman karena hanya me-replace string yang cocok, tidak menimpa file `.smali` utuh).
- `assets/dict_en.txt` — Kamus runtime (5.794 entri item, skill, NPC, quest, dll.) yang dibaca oleh `com.hz.en.Translator`.
- `assets/ota_url.txt` — URL dasar (opsional) untuk fitur OTA Patch otomatis (`dict_en.txt` + gambar `.png` + `.ui`).
- `smali/com/hz/en/Translator.smali` & `OtaPatcher.smali` — Class runtime translator & OTA patcher.
- `unknown/` — 9 gambar `.png` (`common/`) dan 27 file `.ui` (`ui/`) yang sudah dimodifikasi.
- `res/values/strings.xml` — Backup `strings.xml` Android yang sudah berbahasa Inggris.
- `keystore/pvtk_en.keystore` — Keystore signing agar APK versi update tetap bisa di-install menimpa APK lama di HP tanpa uninstall.

## Cara Mengaktifkan OTA Auto-Update (Tanpa Install Ulang APK)
1. Buat folder publik di GitHub (atau server HTTPS statis lain), misalnya `ota/`.
2. Isi URL folder raw-nya ke `assets/ota_url.txt` (contoh: `https://raw.githubusercontent.com/<user>/<repo>/main/ota/`).
3. Di dalam folder `ota/`, siapkan:
   - `version.txt` — angka versi patch, misalnya `1` (naikkan menjadi `2`, `3`, dst. tiap kali ada update).
   - `files.txt` — daftar path file yang mau di-update (satu per baris), misalnya:
     ```text
     dict_en.txt
     common/508.png
     ui/108.ui
     ```
   - File-file tersebut sesuai path relatifnya (`ota/dict_en.txt`, `ota/common/508.png`, dll.).
4. Saat user membuka ulang game, `OtaPatcher` otomatis mengunduh file baru di background dan menyimpannya ke `getFilesDir()/pvtk_patch/`. Perubahan langsung aktif tanpa install ulang APK.

## Cara Pakai Saat Game Ada Update

1. **Download APK baru** dari developer (misal `pvtk_v38.apk`).
2. **Decompile APK baru:**
   ```powershell
   apktool d pvtk_v38.apk -o base_v38
   ```
3. **Jalankan skrip update:**
   ```powershell
   python update_kit/apply_update.py base_v38
   ```
   Skrip ini akan otomatis:
   - Menerapkan seluruh translasi string `smali` yang cocok.
   - Menyalin `assets/dict_en.txt` dan `Translator.smali`.
   - Mengecek file mana saja yang perlu dipasangi hook `Translator`.
   - Menyimpan daftar string baru/berubah ke `base_v38/remaining_new_strings.json`.
4. **Cek & terjemahkan sisanya (jika ada):**
   - Buka `base_v38/remaining_new_strings.json` lalu tambahkan terjemahannya ke `update_kit/dict/smali_strings.json` dan jalankan ulang `apply_update.py`.
   - Jika ada teks item/skill/quest baru dari server, tambahkan ke `update_kit/assets/dict_en.txt`.
   - Pasang hook `Lcom/hz/en/Translator;` pada file yang dilaporkan belum ter-hook (referensi bisa lihat di `base_v37/smali`).
5. **Build ulang APK:**
   ```powershell
   apktool b base_v38 -o build/PVTK_v38_unsigned.apk
   ```
6. **Sign APK** memakai `update_kit/keystore/pvtk_en.keystore` sebelum di-install ke device/emulator.
