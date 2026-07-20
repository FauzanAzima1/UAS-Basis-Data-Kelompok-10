-- ==========================================
-- FILE: 01_Skema_Tabel.sql
-- DESKRIPSI: Pembuatan Database, Tabel, dan Index
-- ==========================================
CREATE DATABASE IF NOT EXISTS db_desa_kelompok10;
USE db_desa_kelompok10;

CREATE TABLE kartu_keluarga (
    no_kk VARCHAR(16) PRIMARY KEY,
    alamat VARCHAR(255) NOT NULL,
    rt VARCHAR(3) NOT NULL,
    rw VARCHAR(3) NOT NULL,
    kode_pos VARCHAR(5) DEFAULT '00000',
    tgl_diterbitkan DATE NOT NULL
);

CREATE TABLE penduduk (
    nik VARCHAR(16) PRIMARY KEY,
    no_kk VARCHAR(16),
    nama_lengkap VARCHAR(100) NOT NULL,
    tempat_lahir VARCHAR(50) NOT NULL,
    tgl_lahir DATE NOT NULL,
    jenis_kelamin ENUM('L', 'P') NOT NULL,
    agama ENUM('Islam', 'Kristen', 'Katolik', 'Hindu', 'Buddha', 'Konghucu') NOT NULL,
    pendidikan VARCHAR(50) DEFAULT 'Belum/Tidak Sekolah',
    pekerjaan VARCHAR(50) DEFAULT 'Belum/Tidak Bekerja',
    status_perkawinan ENUM('Belum Kawin', 'Kawin', 'Cerai Hidup', 'Cerai Mati') NOT NULL,
    status_keluarga ENUM('Kepala Keluarga', 'Suami', 'Istri', 'Anak', 'Mertua', 'Lainnya') NOT NULL,
    status_kependudukan ENUM('Aktif', 'Meninggal', 'Pindah') DEFAULT 'Aktif',
    CONSTRAINT fk_penduduk_kk FOREIGN KEY (no_kk) REFERENCES kartu_keluarga(no_kk) ON UPDATE CASCADE ON DELETE SET NULL
);

CREATE TABLE perangkat_desa (
    id_perangkat INT AUTO_INCREMENT PRIMARY KEY,
    nik VARCHAR(16) UNIQUE,
    jabatan VARCHAR(50) NOT NULL,
    status ENUM('Aktif', 'Non-Aktif') DEFAULT 'Aktif',
    CONSTRAINT fk_perangkat_nik FOREIGN KEY (nik) REFERENCES penduduk(nik) ON UPDATE CASCADE
);

CREATE TABLE pengajuan_surat (
    id_pengajuan INT AUTO_INCREMENT PRIMARY KEY,
    nik VARCHAR(16) NOT NULL,
    jenis_surat VARCHAR(50) NOT NULL,
    keperluan TEXT NOT NULL,
    tgl_pengajuan DATETIME DEFAULT CURRENT_TIMESTAMP,
    status_pengajuan ENUM('Menunggu', 'Diproses', 'Selesai', 'Ditolak') DEFAULT 'Menunggu',
    CONSTRAINT fk_pengajuan_nik FOREIGN KEY (nik) REFERENCES penduduk(nik) ON DELETE CASCADE
);

CREATE TABLE surat (
    id_surat INT AUTO_INCREMENT PRIMARY KEY,
    id_pengajuan INT UNIQUE NOT NULL,
    nomor_surat VARCHAR(50) UNIQUE NOT NULL,
    tgl_cetak DATETIME DEFAULT CURRENT_TIMESTAMP,
    id_perangkat INT,
    CONSTRAINT fk_surat_pengajuan FOREIGN KEY (id_pengajuan) REFERENCES pengajuan_surat(id_pengajuan) ON DELETE CASCADE,
    CONSTRAINT fk_surat_perangkat FOREIGN KEY (id_perangkat) REFERENCES perangkat_desa(id_perangkat)
);

CREATE TABLE bantuan_sosial (
    id_bantuan INT AUTO_INCREMENT PRIMARY KEY,
    nik VARCHAR(16) NOT NULL,
    jenis_bantuan VARCHAR(50) NOT NULL,
    periode_bulan INT NOT NULL,
    periode_tahun INT NOT NULL,
    nominal DECIMAL(10,2) DEFAULT 0.00,
    status_penerimaan ENUM('Belum Cair', 'Sudah Cair') DEFAULT 'Belum Cair',
    CONSTRAINT fk_bantuan_nik FOREIGN KEY (nik) REFERENCES penduduk(nik)
);

CREATE TABLE kelahiran (
    id_kelahiran INT AUTO_INCREMENT PRIMARY KEY,
    no_kk VARCHAR(16) NOT NULL,
    nama_bayi VARCHAR(100) NOT NULL,
    tgl_lahir DATE NOT NULL,
    nama_ayah VARCHAR(100),
    nama_ibu VARCHAR(100),
    CONSTRAINT fk_kelahiran_kk FOREIGN KEY (no_kk) REFERENCES kartu_keluarga(no_kk)
);

CREATE TABLE kematian (
    id_kematian INT AUTO_INCREMENT PRIMARY KEY,
    nik VARCHAR(16) UNIQUE NOT NULL,
    tgl_meninggal DATE NOT NULL,
    penyebab VARCHAR(255),
    tempat_meninggal VARCHAR(100),
    CONSTRAINT fk_kematian_nik FOREIGN KEY (nik) REFERENCES penduduk(nik)
);

CREATE TABLE pindah_penduduk (
    id_pindah INT AUTO_INCREMENT PRIMARY KEY,
    nik VARCHAR(16) UNIQUE NOT NULL,
    tgl_pindah DATE NOT NULL,
    alamat_tujuan TEXT NOT NULL,
    alasan_pindah VARCHAR(255),
    CONSTRAINT fk_pindah_nik FOREIGN KEY (nik) REFERENCES penduduk(nik)
);

CREATE TABLE audit_log (
    id_log INT AUTO_INCREMENT PRIMARY KEY,
    waktu DATETIME DEFAULT CURRENT_TIMESTAMP,
    tabel_terdampak VARCHAR(50),
    aksi VARCHAR(10),
    data_lama TEXT,
    data_baru TEXT,
    user_db VARCHAR(50)
);

-- Indexing Optimasi Query
CREATE INDEX idx_penduduk_nama ON penduduk(nama_lengkap);
CREATE INDEX idx_surat_nomor ON surat(nomor_surat);
CREATE INDEX idx_bantuan_periode ON bantuan_sosial(periode_tahun, periode_bulan);