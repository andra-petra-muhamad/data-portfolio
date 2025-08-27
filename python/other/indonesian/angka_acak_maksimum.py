import random

# Ambil 10 angka acak unik dari 1 sampai 100
A = random.sample(range(1, 101), 10)
print("Daftar angka:", A)

# Inisialisasi
maksimum = A[0]
update_count = 0

# Cek dan hitung berapa kali maksimum diperbarui
for i in range(1, len(A)):
    if A[i] > maksimum:
        print(f"{A[i]} adalah nilai baru yang lebih besar dari {maksimum} → update!")
        maksimum = A[i]
        update_count += 1
    else:
        print(f"{A[i]} tidak lebih besar dari {maksimum}")

# Hasil akhir
print(f"\nNilai maksimum adalah {maksimum}")
print(f"Update nilai maksimum terjadi sebanyak {update_count} kali")
