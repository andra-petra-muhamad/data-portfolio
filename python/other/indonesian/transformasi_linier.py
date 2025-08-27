# Program Transformasi Linier
# ----------------------------------------------------------
# - Masukan: matriks transformasi dan vektor
# - Proses: menerapkan transformasi linier ke vektor dan menampilkan hasilnya

import numpy as np

n = int(input("Masukkan ukuran matriks (n untuk matriks n×n): "))

print("\nMasukkan elemen matriks transformasi (baris per baris):")
matrix = []
for i in range(n):
    row = list(map(float, input(f"Baris {i+1}: ").split()))
    if len(row) != n:
        raise ValueError("Jumlah kolom harus sama dengan ukuran matriks!")
    matrix.append(row)

A = np.array(matrix)

print("\nMasukkan elemen vektor x:")
x = list(map(float, input().split()))
if len(x) != n:
    raise ValueError("Ukuran vektor x harus sama dengan ukuran matriks!")
x = np.array(x)

print("\nMasukkan elemen vektor y:")
y = list(map(float, input().split()))
if len(y) != n:
    raise ValueError("Ukuran vektor y harus sama dengan ukuran matriks!")
y = np.array(y)

k = float(input("\nMasukkan konstanta skalar k: "))

# --- HASIL TRANSFORMASI ---
Tx = A @ x
Ty = A @ y

print("\nHasil Transformasi:")
print(f"T(x) = {Tx}")
print(f"T(y) = {Ty}")

# --- PEMBUKTIAN SIFAT TRANSFORMASI LINIER ---
# 1. Aditivitas: T(x + y) = T(x) + T(y)
T_xy = A @ (x + y)
T_x_plus_T_y = Tx + Ty

# 2. Homogenitas: T(kx) = kT(x)
T_kx = A @ (k * x)
k_Tx = k * Tx

print("\n=== Pembuktian ===")
print(f"T(x + y) = {T_xy}")
print(f"T(x) + T(y) = {T_x_plus_T_y}")
print("Aditivitas:", np.allclose(T_xy, T_x_plus_T_y))

print(f"\nT(kx) = {T_kx}")
print(f"k * T(x) = {k_Tx}")
print("Homogenitas:", np.allclose(T_kx, k_Tx))

if np.allclose(T_xy, T_x_plus_T_y) and np.allclose(T_kx, k_Tx):
    print("\nKesimpulan: Transformasi ini adalah transformasi linier ✅")
else:
    print("\nKesimpulan: Transformasi ini BUKAN transformasi linier ❌")
