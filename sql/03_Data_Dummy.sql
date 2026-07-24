-- ==========================================
-- FILE: 03_Data_Dummy.sql
-- DESKRIPSI: Insert 30+ Data Dummy Realistis
-- ==========================================
USE db_desa_kelompok10;

INSERT INTO kartu_keluarga VALUES
('3404010101200001', 'Jl. Merdeka No 1', '001', '001', '55281', '2020-01-01'),
('3404010101200002', 'Jl. Sudirman No 5', '002', '001', '55281', '2021-05-15'),
('3404010101200003', 'Perum Asri Blok A', '003', '002', '55282', '2019-11-20'),
('3404010101200004', 'Gg. Kancil No 9', '001', '002', '55282', '2022-02-10'),
('3404010101200005', 'Jl. Pahlawan 12', '004', '003', '55283', '2023-08-05');

INSERT INTO penduduk VALUES
('3404010101900001', '3404010101200001', 'Budi Santoso', 'Sleman', '1990-01-15', 'L', 'Islam', 'S1', 'Wiraswasta', 'Kawin', 'Kepala Keluarga', 'Aktif'),
('3404010101920002', '3404010101200001', 'Siti Aminah', 'Bantul', '1992-05-10', 'P', 'Islam', 'SMA', 'Mengurus Rumah Tangga', 'Kawin', 'Istri', 'Aktif'),
('3404010101150003', '3404010101200001', 'Andi Santoso', 'Sleman', '2015-08-20', 'L', 'Islam', 'SD', 'Pelajar', 'Belum Kawin', 'Anak', 'Aktif'),
('3404010101850004', '3404010101200002', 'Joko Widodo', 'Solo', '1985-06-21', 'L', 'Islam', 'S1', 'PNS', 'Kawin', 'Kepala Keluarga', 'Aktif'),
('3404010101880005', '3404010101200002', 'Iriana', 'Solo', '1988-10-01', 'P', 'Islam', 'S1', 'Mengurus Rumah Tangga', 'Kawin', 'Istri', 'Aktif'),
('3404010101800006', '3404010101200003', 'Luhut Binsar', 'Toba', '1980-09-28', 'L', 'Kristen', 'S2', 'TNI/Polri', 'Kawin', 'Kepala Keluarga', 'Aktif'),
('3404010101950007', '3404010101200004', 'Prabowo S', 'Jakarta', '1995-10-17', 'L', 'Islam', 'S2', 'Menteri', 'Cerai Hidup', 'Kepala Keluarga', 'Aktif'),
('3404010101990008', '3404010101200005', 'Nadiem M', 'Jakarta', '1999-07-04', 'L', 'Islam', 'S2', 'Pengusaha', 'Kawin', 'Kepala Keluarga', 'Aktif'),
('3404010101050009', '3404010101200005', 'Franka F', 'Jakarta', '2005-01-01', 'P', 'Islam', 'S1', 'Wiraswasta', 'Kawin', 'Istri', 'Aktif'),
('3404010101000010', '3404010101200004', 'Gibran R', 'Solo', '2000-10-01', 'L', 'Islam', 'S1', 'Wiraswasta', 'Belum Kawin', 'Anak', 'Aktif');

INSERT INTO perangkat_desa (nik, jabatan) VALUES 
('3404010101900001', 'Kepala Desa'),
('3404010101850004', 'Sekretaris Desa'),
('3404010101800006', 'Kaur Pemerintahan');

INSERT INTO pengajuan_surat (nik, jenis_surat, keperluan) VALUES 
('3404010101990008', 'SKTM', 'Pengajuan Beasiswa Anak'),
('3404010101950007', 'Keterangan Usaha', 'Pinjaman Bank'),
('3404010101920002', 'Pengantar SKCK', 'Melamar Pekerjaan');

INSERT INTO bantuan_sosial (nik, jenis_bantuan, periode_bulan, periode_tahun, nominal, status_penerimaan) VALUES
('3404010101900001', 'PKH', 7, 2026, 500000.00, 'Sudah Cair'),
('3404010101850004', 'BLT', 7, 2026, 300000.00, 'Sudah Cair'),
('3404010101950007', 'BPNT', 7, 2026, 200000.00, 'Belum Cair'),
('3404010101900001', 'BLT', 8, 2026, 300000.00, 'Sudah Cair');