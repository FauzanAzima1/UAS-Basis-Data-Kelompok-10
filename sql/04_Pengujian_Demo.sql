-- ==========================================
-- FILE: 04_Pengujian_Demo.sql
-- DESKRIPSI: Kueri untuk dipanggil saat presentasi
-- ==========================================
USE db_desa_kelompok10;

-- 1. Uji Function
SELECT nama_lengkap, tgl_lahir, fn_hitung_umur(tgl_lahir) AS umur FROM penduduk;
SELECT fn_total_bantuan_kk('3404010101200001') AS Total_Bantuan_KK_Budi;

-- 2. Uji SP & Exception
CALL sp_tambah_penduduk('3404010101990008', '3404010101200005', 'Gagal Input', '1990-01-01', 'L', 'Islam');
CALL sp_buat_surat(1, 1);

-- 3. Uji Trigger & Audit
INSERT INTO kematian (nik, tgl_meninggal, penyebab) VALUES ('3404010101800006', CURDATE(), 'Sakit');
SELECT * FROM audit_log;

-- 4. Uji Cursor
CALL sp_laporan_bantuan(7, 2026);

-- 5. Uji Transaction (Rollback)
START TRANSACTION;
INSERT INTO bantuan_sosial (nik, jenis_bantuan, periode_bulan, periode_tahun, nominal) VALUES ('3404010101920002', 'BLT', 8, 2026, 30000000.00); 
ROLLBACK;