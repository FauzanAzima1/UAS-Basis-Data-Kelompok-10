# Sistem Basis Data Administrasi Desa 

Repository ini berisi *final project* (Evaluasi Akhir Semester) untuk mata kuliah Pemrograman Basis Data. 

Sistem ini dirancang untuk mendigitalkan dan mengotomatisasi pencatatan sipil di tingkat desa, mulai dari data kependudukan, pengelolaan Kartu Keluarga (KK), pengajuan surat, hingga pencatatan bantuan sosial. Karena tugas ini berfokus pada arsitektur RDBMS, sistem ini sangat mengandalkan *logic* di sisi *backend* database (tidak menggunakan aplikasi *frontend*).

##  Tech Stack
- **Database Engine:** MySQL / MariaDB
- **Tested on Tools:** DBeaver, MySQL Workbench, phpMyAdmin

##  Highlight Fitur Database
Sistem ini tidak sekadar melakukan operasi CRUD biasa, melainkan memindahkan *business logic* administrasi desa ke level *database engine* agar lebih aman dan efisien. Berikut objek database yang kami implementasikan:

- **10 Tabel Relasional:** Menggunakan skema normalisasi (3NF) lengkap dengan *Primary Key* dan *Foreign Key* (`ON UPDATE CASCADE`).
- **3 Stored Procedures:** Untuk memproses penambahan warga baru dan *auto-generate* persetujuan/nomor surat.
- **2 Functions:** Kalkulasi dinamis, seperti menghitung umur *real-time* dari tanggal lahir dan kalkulasi nominal bantuan.
- **3 Triggers:** Otomatisasi mutasi (otomatis mengubah status aktif warga jadi 'Meninggal' jika diinput di tabel kematian) dan sistem proteksi cegah-hapus data.
- **Cursor:** Untuk melakukan *looping* pembuatan rekap laporan bantuan sosial bulanan.
- **Transaction & Exception:** Menggunakan `COMMIT`, `ROLLBACK`, dan validasi *error* kustom untuk menjaga integritas data jika ada kesalahan *input* (misal: duplikasi NIK).
- **Audit Log:** Mencatat otomatis setiap aksi, waktu, dan *user* yang melakukan perubahan data ke tabel `audit_log`.
- **Indexing:** Optimasi performa *query* untuk mempercepat pencarian nama penduduk dan nomor surat.

##  Struktur Direktori
file di repo ini dibagi menjadi dua folder utama:

```text
📦 UAS-Basis-Data-Kelompok-10
├── 📂 sql                    # Source code SQL lengkap 
│   ├── 01_Skema_Tabel.sql    # Script DDL (Create DB, Table, Index)
│   ├── 02_Objek_Database.sql # Script Logic (SP, Function, Trigger, Cursor)
│   ├── 03_Data_Dummy.sql     # Script DML (Insert 30+ data warga & transaksi)
│   └── 04_Pengujian_Demo.sql # Kumpulan query untuk live-demo dan testing
└── 📄 README.md              # Dokumentasi repository

```

##  Cara Menjalankan (How to Run)

Bagi penguji yang ingin mencoba *run* database ini di *local machine*, silakan ikuti *step* berikut:

1. Pastikan *service* MySQL/MariaDB sudah berjalan (bisa melalui XAMPP/Laragon).
2. *Clone* repo ini atau unduh sebagai ZIP.
3. Buka SQL Client (DBeaver atau MySQL Workbench sangat disarankan agar lebih mudah mengeksekusi banyak file sekaligus).
4. Eksekusi *script* SQL di dalam folder `sql` **secara berurutan**:
* Run `01_Skema_Tabel.sql` (Akan otomatis membuat database `db_desa_kelompok10`).
* Run `02_Objek_Database.sql`.
* Run `03_Data_Dummy.sql`.


5. Selesai! Database sudah ter-isi dan siap dites. Silakan gunakan *query* yang ada di dalam `04_Pengujian_Demo.sql` untuk melakukan simulasi transaksi dan melihat fitur *Trigger* beraksi.

## 👥 Tim Pengembang (Kelompok 10)

| Nama | Peran Utama |
| --- | --- |
| **Fauzan Azima** | Project Manager & Database Architect |
| **Jack Stiven** | Database Developer (Logic, Procedure, Cursor) |
| **Dimas Aprilino** | Database Administrator (Trigger, Audit, QA) |

---

*Proyek ini di-submit untuk memenuhi Evaluasi Akhir Semester (EAS) Pemrograman Basis Data - 2026.*
