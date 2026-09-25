# mod3_kel25 — Modul 3 Flutter (ApiCountries Demo)

Percobaan Modul 3: aplikasi Flutter lintas platform yang menampilkan daftar negara
dari API https://www.apicountries.com/countries, dengan halaman Detail + Profile
dan BottomNavigationBar (Home / Profile).

Kelompok 25 — Faras Fauzan Attaqi (21120124140119)

## Struktur (sesuai Gambar 3.16 & 3.17 di modul)
```
lib/
  main.dart
  screens/
    home.dart
    detail.dart
    profile.dart
  widget/
    navigation.dart
test/
  widget_test.dart
```

## Cara pakai
1. Install Flutter SDK + plugin Flutter di VSCode (lihat CARA_JALANKAN.txt)
2. Buka folder ini di VSCode: `code "C:\Users\faras\AndroidStudioProjects\mod3_kel25"`
3. Di terminal VSCode:
```
flutter pub get
flutter pub add http
flutter run
```
4. Untuk widget test:
```
flutter test
```

## Catatan penyesuaian dari modul (agar jalan di 2026)
- `home.dart`: ditambah header `User-Agent` + `Accept: application/json` pada
  `HttpClient` karena server kini menolak request tanpa User-Agent (403).
- `profile.dart`: `withValues(alpha: 128)` diperbaiki jadi `withOpacity(0.5)`
  (API modul salah rentang + tidak kompatibel dengan Flutter lama), Nama/NIM
  diganti ke anggota Kelompok 25, avatar diganti ke akun Faras.
- `widget_test.dart`: package disesuaikan jadi `mod3_kel25`.
