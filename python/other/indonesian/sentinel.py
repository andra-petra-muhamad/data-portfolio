# Sentinel adalah nilai khusus (biasanya target) yang ditambahkan ke akhir list
# untuk menghentikan proses pencarian tanpa harus mengecek panjang list.
# Dengan sentinel, loop bisa berhenti hanya dengan membandingkan nilai, bukan panjang.
# Setelah ditemukan, dicek apakah posisi index-nya < len(A) sebelum penambahan.
# Jika ya → target asli ada dalam list. Jika tidak → hanya ketemu karena sentinel.

import random

def cari_sentinel(A, target):
    B = A.copy()  # simpan list asli
    A.append(target)  # tambahkan sentinel
    i = 0

    # Tidak perlu lagi cek panjang list karena pasti akan ketemu di akhir
    while A[i] != target:
        i += 1

    if i == len(B):  # ditemukan karena sentinel
        print(f"Target TIDAK ADA dalam list asli. Sentinel ditemukan di index {i}.")
    else:
        print(f"Target ditemukan pada index ke-{i} dalam list asli.")

    print("\nList dengan sentinel:")
    print(A)
    print("\nList asli:")
    print(B)

# Simulasi
n = int(input("Banyak elemen list: "))
A = random.sample(range(1, 1001), n)  # list unik acak
target = int(input("Target: "))
cari_sentinel(A, target)
