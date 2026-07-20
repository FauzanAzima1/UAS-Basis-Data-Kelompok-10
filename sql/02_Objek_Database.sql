-- ==========================================
-- FILE: 02_Objek_Database.sql
-- DESKRIPSI: Stored Procedure, Function, dan Trigger
-- ==========================================
USE db_desa_kelompok10;

DELIMITER $$

-- [FUNCTIONS]
CREATE FUNCTION fn_hitung_umur(tgl_lahir DATE) RETURNS INT DETERMINISTIC
BEGIN
    RETURN TIMESTAMPDIFF(YEAR, tgl_lahir, CURDATE());
END$$

CREATE FUNCTION fn_total_bantuan_kk(p_no_kk VARCHAR(16)) RETURNS DECIMAL(10,2) READS SQL DATA
BEGIN
    DECLARE total DECIMAL(10,2) DEFAULT 0;
    SELECT IFNULL(SUM(b.nominal), 0) INTO total FROM bantuan_sosial b
    JOIN penduduk p ON b.nik = p.nik
    WHERE p.no_kk = p_no_kk AND b.status_penerimaan = 'Sudah Cair';
    RETURN total;
END$$

-- [TRIGGERS]
CREATE TRIGGER trg_after_insert_penduduk AFTER INSERT ON penduduk FOR EACH ROW
BEGIN
    INSERT INTO audit_log (tabel_terdampak, aksi, data_baru, user_db)
    VALUES ('penduduk', 'INSERT', CONCAT('NIK: ', NEW.nik, ' ditambahkan'), USER());
END$$

CREATE TRIGGER trg_after_insert_kematian AFTER INSERT ON kematian FOR EACH ROW
BEGIN
    UPDATE penduduk SET status_kependudukan = 'Meninggal' WHERE nik = NEW.nik;
    INSERT INTO audit_log (tabel_terdampak, aksi, data_baru, user_db)
    VALUES ('penduduk', 'UPDATE', CONCAT('NIK ', NEW.nik, ' status menjadi Meninggal'), USER());
END$$

CREATE TRIGGER trg_before_delete_penduduk BEFORE DELETE ON penduduk FOR EACH ROW
BEGIN
    IF OLD.status_kependudukan = 'Aktif' THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'ERROR: Penduduk AKTIF tidak bisa dihapus!';
    END IF;
END$$

-- [STORED PROCEDURES]
CREATE PROCEDURE sp_tambah_penduduk(
    IN p_nik VARCHAR(16), IN p_kk VARCHAR(16), IN p_nama VARCHAR(100), 
    IN p_lahir DATE, IN p_jk ENUM('L','P'), IN p_agama VARCHAR(20)
)
BEGIN
    DECLARE EXIT HANDLER FOR 1062
    BEGIN
        SELECT 'GAGAL: NIK sudah terdaftar!' AS Pesan;
        ROLLBACK;
    END;
    START TRANSACTION;
    INSERT INTO penduduk (nik, no_kk, nama_lengkap, tempat_lahir, tgl_lahir, jenis_kelamin, agama, status_perkawinan, status_keluarga)
    VALUES (p_nik, p_kk, p_nama, 'Sleman', p_lahir, p_jk, p_agama, 'Belum Kawin', 'Anak');
    COMMIT;
    SELECT 'SUKSES: Data disimpan.' AS Pesan;
END$$

CREATE PROCEDURE sp_buat_surat(IN p_pengajuan INT, IN p_perangkat INT)
BEGIN
    DECLARE v_nik VARCHAR(16);
    DECLARE v_status VARCHAR(20);
    DECLARE v_no_surat VARCHAR(50);
    
    SELECT nik INTO v_nik FROM pengajuan_surat WHERE id_pengajuan = p_pengajuan;
    SELECT status_kependudukan INTO v_status FROM penduduk WHERE nik = v_nik;
    
    IF v_status != 'Aktif' THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'ERROR: Pemohon tidak Aktif';
    END IF;

    SET v_no_surat = CONCAT('470/', p_pengajuan, '/', YEAR(CURDATE()));
    START TRANSACTION;
    UPDATE pengajuan_surat SET status_pengajuan = 'Selesai' WHERE id_pengajuan = p_pengajuan;
    INSERT INTO surat (id_pengajuan, nomor_surat, id_perangkat) VALUES (p_pengajuan, v_no_surat, p_perangkat);
    COMMIT;
END$$

CREATE PROCEDURE sp_laporan_bantuan(IN p_bulan INT, IN p_tahun INT)
BEGIN
    DECLARE done INT DEFAULT FALSE;
    DECLARE v_nama VARCHAR(100);
    DECLARE v_jenis VARCHAR(50);
    DECLARE v_nominal DECIMAL(10,2);
    
    DECLARE cur_bantuan CURSOR FOR 
        SELECT p.nama_lengkap, b.jenis_bantuan, b.nominal 
        FROM bantuan_sosial b JOIN penduduk p ON b.nik = p.nik
        WHERE b.periode_bulan = p_bulan AND b.periode_tahun = p_tahun;
        
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;
    
    DROP TEMPORARY TABLE IF EXISTS temp_laporan;
    CREATE TEMPORARY TABLE temp_laporan (Nama VARCHAR(100), Jenis VARCHAR(50), Nominal DECIMAL(10,2));
    
    OPEN cur_bantuan;
    read_loop: LOOP
        FETCH cur_bantuan INTO v_nama, v_jenis, v_nominal;
        IF done THEN LEAVE read_loop; END IF;
        INSERT INTO temp_laporan VALUES (v_nama, v_jenis, v_nominal);
    END LOOP;
    CLOSE cur_bantuan;
    
    SELECT * FROM temp_laporan;
END$$

DELIMITER ;