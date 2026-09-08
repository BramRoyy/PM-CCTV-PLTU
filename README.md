# 📹 PM-CCTV — Maintenance & Monitoring System

![Flutter](https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white)
![Dart](https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white)
![Node.js](https://img.shields.io/badge/Node.js-339933?style=for-the-badge&logo=nodedotjs&logoColor=white)
![Express.js](https://img.shields.io/badge/Express.js-000000?style=for-the-badge&logo=express&logoColor=white)
![PostgreSQL](https://img.shields.io/badge/PostgreSQL-4169E1?style=for-the-badge&logo=postgresql&logoColor=white)
![PLN Nusantara Power UP Paiton](https://img.shields.io/badge/PT_PLN_Nusantara_Power-0080FF?style=for-the-badge)

**PM-CCTV** (`pm_cctv`) adalah aplikasi berbasis Flutter yang dikembangkan untuk mendukung kegiatan pemantauan (*monitoring*), pelaporan gangguan, dan pemeliharaan preventif (*preventive maintenance*) perangkat CCTV di lingkungan **PT PLN Nusantara Power**.

---

## 📌 Fitur & Kapabilitas Utama

- **Navigasi & UI Interaktif**: Antarmuka modern menggunakan `google_nav_bar` untuk navigasi bawah, slider banner dengan `carousel_slider`, serta interaksi konfirmasi aksi dengan `slide_to_act`.
- **Manajemen Berkas & Media**: Pengambilan foto atau dokumentasi fisik unit CCTV menggunakan `image_picker` serta pengunggahan file lampiran laporan melalui `file_picker` dan penanganan tipe MIME dengan `mime`.
- **Diagnostik Jaringan & Perangkat**: Pemeriksaan status koneksi dan informasi jaringan lokal area unit CCTV berbasis `network_info_plus` serta eksekusi skrip diagnostik/perintah terminal menggunakan `process_run`.
- **Integrasi API Client**: Komunikasi data asinkronus berbasis REST API menggunakan modul `http`.
- **Notifikasi Pop-up Kustom**: Sistem peringatan dan konfirmasi aksi *troubleshooting* terintegrasi menggunakan `quickalert`.

---

## 🛠️ Stack Teknologi & Dependensi

| Kategori | Paket / Library | Deskripsi |
| :--- | :--- | :--- |
| **Framework** | `flutter` | Framework utama pengembang aplikasi multi-platform. |
| **Networking** | `http` | HTTP Client untuk pengiriman data REST API. |
| **Diagnostic & Network**| `network_info_plus`, `process_run` | Pengecekan IP/Wi-Fi dan pemrosesan perintah perintah lokal. |
| **Media & File** | `image_picker`, `file_picker`, `mime` | Pengambilan gambar kamera, pemilih dokumen, dan validasi MIME type. |
| **UI Components** | `google_nav_bar`, `carousel_slider`, `slide_to_act` | Komponen navigasi tab, carousel citra, dan slider aksi. |
| **Alerts & Dialogs** | `quickalert` | Tampilan dialog peringatan dan konfirmasi responsif. |

---

## 📁 Struktur Folder Proyek

```text
pm_cctv/
├── android/                   # Konfigurasi platform Android
├── ios/                       # Konfigurasi platform iOS
├── assets/
│   └── images/                # Aset gambar & Logo PLN
├── lib/
│   ├── API/                   # Konfigurasi endpoint & konstanta API
│   ├── AppManager/            # Pengelola state aplikasi & manajer sesi
│   ├── models/                # Data model & serialisasi JSON
│   ├── services/              # Layanan backend (network, file handler, command runner)
│   ├── Screen/                # Tampilan antarmuka pengguna (UI Screens)
│   └── main.dart              # Titik masuk utama (Entry point) aplikasi
├── pubspec.yaml               # Konfigurasi paket & dependensi proyek
└── README.md                  # Dokumentasi proyek

```

---

## 🚀 Cara Menjalankan Aplikasi

### 1. Prasyarat (*Prerequisites*)

Pastikan perangkat pengembangan Anda telah terpasang:

* **Flutter SDK**: `^3.3.4` atau yang lebih baru.
* **Dart SDK**: `^3.3.4`

### 2. Langkah Instalasi

1. **Clone Repositori**:
```bash
git clone [https://github.com/BramRoyy/PM-CCTV-PLTU.git](https://github.com/BramRoyy/PM-CCTV-PLTU.git)
cd PM-CCTV-PLTU

```


2. **Install Dependensi**:
```bash
flutter pub get

```


3. **Generasi Ikon Aplikasi (Opsional)**:
```bash
flutter pub run flutter_launcher_icons

```


4. **Jalankan Aplikasi**:
```bash
flutter run

```



---

## 👤 Pengembang

Dikembangkan oleh **Abraham Roy Rudianto** sebagai bagian dari program magang di **PT PLN Nusantara Power UP Paiton**.
