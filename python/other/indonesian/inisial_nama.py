print("Mari kita mencari inisial dan kategori usia penjahat di TV")

# Input data
nama = input("Nama: ").strip()
tahun = int(input("Tahun Kelahiran: "))

# Hitung usia dan kategori
usia = 2025 - tahun
if usia <= 10:
    kategori = "Anak-Anak"
elif usia <= 18:
    kategori = "Remaja"
else:
    kategori = "Dewasa"

# Ambil inisial
kata_nama = nama.title().split()  # title agar huruf kapital di awal, split jadi list
jumlah_kata = len(kata_nama)

if jumlah_kata <= 4:
    inisial = "".join(kata[0] for kata in kata_nama)
    print(f"Inisialmu adalah {inisial}")
    print(f"Kamu sudah {kategori}")
else:
    print("Maaf, namamu terlalu panjang. Maksimal 4 kata ya!")

print("Sekarang kamu tahu kan ciri-ciri penjahat yang sedang disiarkan di TV!!!")
