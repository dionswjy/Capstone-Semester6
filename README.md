# TirtaDesa

TirtaDesa adalah aplikasi mobile berbasis Flutter yang digunakan untuk membantu proses pencatatan dan monitoring meter air serta layanan pelanggan pada PAMSIMAS Desa.

Aplikasi ini dibuat untuk mempermudah petugas dalam mencatat meter air pelanggan, mengelola data pelanggan, memantau tagihan, serta menangani pengaduan masyarakat secara digital.

## Deskripsi Project

Project ini dikembangkan sebagai aplikasi mobile dengan fokus pada kebutuhan operasional PAMSIMAS desa. Sistem ini memiliki beberapa fitur utama seperti:

- Login pengguna
- Dashboard informasi
- Manajemen data pelanggan
- Pencatatan meter air
- Riwayat pembayaran/tagihan
- Pengaduan pelanggan
- Profil pengguna/petugas
- Monitoring data penggunaan air

## Teknologi yang Digunakan

- Flutter
- Dart
- GetX Pattern
- Firebase / API Backend
- Git & GitHub
- Figma / Stitch untuk desain UI

## Arsitektur Aplikasi

Project ini menggunakan pola arsitektur GetX agar struktur kode lebih rapi, modular, dan mudah dikembangkan.

Struktur utama aplikasi:

```bash
lib/
├── app/
│   ├── modules/
│   │   ├── login/
│   │   ├── dashboard/
│   │   ├── pelanggan/
│   │   ├── petugas_meter/
│   │   ├── pengaduan/
│   │   └── profile/
│   ├── routes/
│   ├── data/
│   └── widgets/
└── main.dart
