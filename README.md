# TaskMate - Student Task & Study Planner 🎓📱

TaskMate adalah aplikasi mobile cerdas yang dirancang khusus untuk membantu mahasiswa mengelola tugas kuliah, deadline pengumpulan, jadwal belajar, dan produktivitas akademik harian dengan antarmuka yang modern, clean, dan intuitif.

---

## 🚀 Fitur Tahap 1 (UI & Navigasi)

- **Design System & Theming**:
  - Dukungan penuh **Light Mode** & **Dark Mode** secara dinamis.
  - Skema warna modern (Indigo, Cyan, Rose Red, Emerald Green, Amber).
  - Tipografi rapi dan konsisten sesuai standar Material 3.
- **Autentikasi Mahasiswa**:
  - Halaman **Login**: Email mahasiswa, kata sandi, visibility toggle, tombol isi otomatis akun demo.
  - Halaman **Register**: Pendaftaran lengkap dengan Nama Mahasiswa, Universitas, Program Studi, Email, dan Kata Sandi.
- **Dashboard Akademik**:
  - Greeting nama dan semester mahasiswa.
  - Kartu Progress & Target Produktivitas Mingguan.
  - Statistik Cepat: Total Tugas, Mendekati Deadline, Selesai, dan Prioritas Tinggi.
  - Slider Mata Kuliah Semester Berjalan dengan counter tugas.
  - Daftar Tugas yang Segera Dikumpulkan (Upcoming Deadlines) dengan countdown waktu real-time.
- **Manajemen Tugas (Task List)**:
  - Pencarian tugas real-time (judul, deskripsi, mata kuliah).
  - Filter status (Semua, Belum Selesai, Selesai).
  - Filter mata kuliah (Category chips).
  - Filter tingkat prioritas (Tinggi, Sedang, Rendah).
  - Checklist interaktif untuk menandai tugas selesai secara instan.
- **Detail Tugas (Task Detail)**:
  - Rincian lengkap mata kuliah, waktu deadline, status pengerjaan, tingkat prioritas, dan catatan/instruksi dosen.
  - Tombol aksi selesai/belum selesai dan dialog konfirmasi hapus tugas.
- **Tambah Tugas Baru (Modal Bottom Sheet)**:
  - Input judul, pilihan mata kuliah, date picker deadline, time picker jam pengumpulan, prioritas, dan catatan dosen.
- **Pengaturan & Profil (Settings)**:
  - Kartu profil mahasiswa (NIM/Email, Kampus, Semester).
  - Switcher Dark Mode instan.
  - Preferensi notifikasi reminder deadline & ringkasan pagi.
  - Navigasi logout kembali ke halaman autentikasi.

---

## 📁 Struktur Folder Modular

```text
lib/
├── app.dart                                # Konfigurasi MaterialApp & MultiProvider
├── main.dart                               # Entry point aplikasi
├── core/
│   ├── constants/
│   │   ├── app_colors.dart                 # Palet warna Light & Dark
│   │   ├── app_constants.dart              # Spacing, radius, durasi animasi
│   │   └── app_text_styles.dart            # Standar tipografi
│   ├── routes/
│   │   └── app_routes.dart                 # Named routing navigasi halaman
│   ├── theme/
│   │   ├── app_theme.dart                  # ThemeData Light & Dark (Material 3)
│   │   └── theme_provider.dart             # State management toggle theme
│   └── utils/
│       └── date_formatter.dart             # Formatter tanggal & countdown deadline
├── data/
│   ├── dummy/
│   │   └── dummy_data.dart                 # Data simulasi mahasiswa & tugas kuliah
│   └── models/
│       ├── category_model.dart             # Model kategori mata kuliah
│       ├── task_model.dart                 # Model tugas kuliah
│       └── user_model.dart                 # Model profil mahasiswa
└── presentation/
    ├── providers/
    │   ├── auth_provider.dart              # State autentikasi mahasiswa
    │   └── task_provider.dart              # State manajemen & filter tugas
    ├── screens/
    │   ├── auth/
    │   │   ├── login_screen.dart           # Halaman Login
    │   │   └── register_screen.dart        # Halaman Register
    │   ├── dashboard/
    │   │   └── dashboard_screen.dart       # Dashboard utama
    │   ├── settings/
    │   │   └── settings_screen.dart        # Pengaturan & Profil
    │   ├── task/
    │   │   ├── task_detail_screen.dart     # Halaman detail tugas
    │   │   └── task_list_screen.dart       # Halaman daftar semua tugas
    │   └── main_nav_screen.dart            # Shell navigasi bawah (BottomNav)
    └── widgets/
        ├── add_task_bottom_sheet.dart      # Modal dialog tambah tugas
        ├── category_chip.dart              # Chip kategori mata kuliah
        ├── custom_button.dart              # Tombol kustom (Primary, Outlined, Loading)
        ├── custom_text_field.dart          # Form input kustom
        ├── empty_state_view.dart           # Tampilan state kosong
        ├── priority_badge.dart             # Badge prioritas tugas
        ├── stat_card.dart                  # Kartu metrik statistik
        └── task_card.dart                  # Kartu item tugas interaktif
```

---

## 🛠️ Cara Menjalankan Project

### 1. Prasyarat Environment
Pastikan Flutter SDK sudah terpasang di komputer Anda. Jika belum terpasang:
- Unduh Flutter SDK dari [flutter.dev](https://docs.flutter.dev/get-started/install/windows) atau instal melalui terminal:
  ```powershell
  # Menggunakan Git
  git clone https://github.com/flutter/flutter.git -b stable C:\flutter
  # Tambahkan C:\flutter\bin ke PATH Environment Variables
  ```
- Periksa kesiapan environment dengan perintah:
  ```bash
  flutter doctor
  ```

### 2. Mengambil Dependency
Buka terminal di dalam folder project `C:\TaskMate` lalu jalankan:
```bash
flutter pub get
```

### 3. Menjalankan Aplikasi
Pilih device yang ingin digunakan (Chrome/Web, Emulator Android, atau Windows Desktop):
```bash
# Menjalankan di browser Chrome (Paling cepat untuk preview)
flutter run -d chrome

# Menjalankan di Android Device / Emulator
flutter run -d android

# Menjalankan di Windows Desktop
flutter run -d windows
```

