# Program: Menentukan Warna Petak Catur dari Posisi (misal: a2, b4)

print("Program Warna Petak Catur")
posisi = input("Masukkan posisi petak (contoh: a2, b4): ").lower()

# Validasi input
if len(posisi) != 2 or posisi[0] not in "abcdefgh" or not posisi[1].isdigit():
    print("Input tidak valid! Gunakan format seperti a2, b4 (huruf a-h dan angka 1-8).")
else:
    huruf = posisi[0]
    angka = int(posisi[1])

    if angka < 1 or angka > 8:
        print("Angka harus antara 1 sampai 8!")
    else:
        # Konversi huruf ke angka kolom
        kolom = ord(huruf) - ord('a') + 1

        # Logika warna: jika jumlah kolom+baris genap → putih, ganjil → hitam
        if (kolom + angka) % 2 == 0:
            warna = "putih"
        else:
            warna = "hitam"

        print(f"Posisi {posisi} adalah petak berwarna {warna}.")

print("Program selesai.")
