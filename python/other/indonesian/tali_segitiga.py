# Mensimulasikan peluang bahwa tiga potong tali acak (jumlah total panjang = 1) bisa membentuk segitiga.
# Metode: pilih dua titik potong secara acak pada tali sepanjang 1.
# Tiga potongan didapat dari: 0 → titik1, titik1 → titik2, titik2 → 1.
# Syarat segitiga dari tiga sisi a,b,c:
# Jumlah dua sisi manapun harus lebih besar dari sisi ketiga. Alias:
# a + b > c
# a + c > b
# b + c > a
# Jika sisi terpanjang (max) < jumlah dua lainnya → segitiga valid. 
# Atau secara logika: sum(tali) - max > max

import random

sukses = 0
banyakpercobaan = int(input("Masukkan banyak percobaan yang anda inginkan: "))

for _ in range(banyakpercobaan):
    titik1 = random.uniform(0, 1)
    titik2 = random.uniform(0, 1)
    titik1, titik2 = sorted([titik1, titik2])

    a = titik1                     # potongan pertama: dari 0 ke titik1
    b = titik2 - titik1            # potongan kedua: dari titik1 ke titik2
    c = 1 - titik2                 # potongan ketiga: dari titik2 ke ujung

    # Syarat segitiga: jumlah dua sisi harus lebih besar dari sisi ketiga
    if a + b > c and a + c > b and b + c > a:
        sukses += 1

peluang = sukses / banyakpercobaan
print(f"Peluang membentuk segitiga: {peluang:.4f}")
print(f"Nilai a = {a:.4f}")
print(f"Nilai b = {b:.4f}")
print(f"Nilai c = {c:.4f}")
