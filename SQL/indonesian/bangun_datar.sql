/*
Dalam pelajaran matematika, kita dapat menghitung luas bangun datar,
misalnya segitiga dan persegi panjang. 
Kita akan membuat stored procedure untuk menghitung luas segitiga dan
persegi panjang. Stored procedure ini akan memiliki 4 parameter, yaitu:
a. jenis bangun datar (IN) (string), yaitu jenis bangun datar yang akan dihitung;
saat ini kita hanya akan menghitung segitiga dan persegi panjang saja
b. x (IN) (float), yaitu jika jenis bangun datar segitiga, x adalah alas dan jika
persegi panjang, x adalah panjang
c. y (IN) (float), yaitu jika jenis bangun datar segitiga, y adalah tinggi dan jika
persegi panjang, y adalah lebar
d. luas (OUT) (float), yaitu luas bangun datar yang dihitung
e. keterangan (OUT) (string), yaitu keterangan apakah perhitungan berhasil
dilakukan
*/

/*
Membuat Stored Procedure
Kita membuat prosedur bernama hitung_luas dengan parameter:
- jenis → tipe bangun datar (segitiga / persegi panjang / lainnya)
- x, y → angka (alas/tinggi atau panjang/lebar)
- hasil → output luas
- keterangan → status apakah perhitungan berhasil
*/
DELIMITER $$
CREATE PROCEDURE hitung_luas (
    IN jenis VARCHAR (255),
    IN x FLOAT,
    IN y FLOAT,
    OUT hasil FLOAT,
    OUT keterangan VARCHAR (255)
) BEGIN
    CASE
        WHEN jenis = 'segitiga' THEN SET hasil = 0.5 * x * y, keterangan = 'Perhitungan berhasil!';
        WHEN jenis = 'persegi panjang' THEN SET hasil = x * y, keterangan = 'Perhitungan berhasil!';
        ELSE SET hasil = NULL ; SET keterangan = 'Perhitungan gagal. Bangun datar tidak didukung';
    END CASE;
END $$
DELIMITER ;

-- Menghitung Luas Segitiga
SET @jenis_bangun_datar = 'segitiga';-- atau SET @jenis_bangun_datar = 'persegi panjang'
SET @x = 10 ; -- atau angka berapapun sebagai alas, jenis data FLOAT
SET @y = 20 ; -- atau angka berapapun sebagai tinggi, jenis data FLOAT

CALL hitung_luas(@jenis_bangun_datar, @x, @y, @luas, @keterangan);
SELECT @jenis_bangun_datar, @x, @y, @luas, @keterangan;

-- Menghitung luas persegi panjang
SET @jenis_bangun_datar = 'persegi panjang';-- atau SET @jenis_bangun_datar = 'persegi panjang'
SET @x = 10 ; -- atau angka berapapun sebagai panjang, jenis data FLOAT
SET @y = 20 ; -- atau angka berapapun sebagai lebar, jenis data FLOAT

CALL hitung_luas(@jenis_bangun_datar, @x, @y, @luas, @keterangan);
SELECT @jenis_bangun_datar, @x, @y, @luas, @keterangan;

-- Menghitung Luas Bangun yang Tidak Didukung (Misalnya Lingkaran)
SET @jenis_bangun_datar = 'lingkaran';-- atau SET @jenis_bangun_datar = 'persegi panjang'
SET @x = 10 ; -- atau angka berapapun, jenis data FLOAT
SET @y = 20 ; -- atau angka berapapun, jenis data FLOAT

CALL hitung_luas(@jenis_bangun_datar, @x, @y, @luas, @keterangan);
SELECT @jenis_bangun_datar, @x, @y, @luas, @keterangan;





