# Program Determinan & Inverse Matriks
# ----------------------------------------------------------
# - Input: ukuran matriks dan elemen-elemen matriks
# - Proses: hitung determinan dan inverse (jika ada)

import numpy as np

# Input ukuran matriks
n = int(input("Masukkan ukuran matriks (n x n): "))

# Input elemen matriks
print(f"Masukkan elemen matriks {n}x{n} (pisahkan dengan spasi):")
matriks = []
for i in range(n):
    baris = list(map(float, input(f"Baris {i+1}: ").split()))
    matriks.append(baris)

# Konversi ke array NumPy
A = np.array(matriks)

# Cetak matriks
print("\nMatriks A:")
print(A)

# Hitung determinan
determinan = np.linalg.det(A)
print(f"\nDeterminan matriks: {determinan}")

# Cek apakah matriks memiliki inverse
if np.isclose(determinan, 0):
    print("\nMatriks tidak memiliki inverse karena determinannya nol.")
else:
    inverse = np.linalg.inv(A)
    print("\nInverse matriks:")
    print(inverse)
