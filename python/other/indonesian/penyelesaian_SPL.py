# ============================================================
# Program Penyelesai Sistem Persamaan Linear (SPL) Interaktif
# Metode yang Didukung:
# 1. Eliminasi Gauss
# 2. Eliminasi Gauss-Jordan
# 3. Invers Matriks
# 4. Aturan Cramer
# 5. Dekomposisi LU
# 6. Metode Iteratif Jacobi
#
# Pengguna diminta memasukkan matriks augmented (A|b) secara manual,
# lalu memilih metode yang diinginkan. Program akan menghitung solusi,
# jika ada, dan menampilkannya.
# Dapat mendeteksi kasus tidak ada solusi atau solusi tak unik.

import numpy as np

def input_matrix():
    n = int(input("Masukkan jumlah persamaan (baris): "))
    m = int(input("Masukkan jumlah variabel (kolom): "))
    print("Masukkan elemen augmented matrix A|b (baris demi baris, dipisah spasi):")
    A = []
    for i in range(n):
        row = list(map(float, input(f"Baris {i+1}: ").split()))
        if len(row) != m + 1:
            raise ValueError("Setiap baris harus berisi jumlah variabel + 1.")
        A.append(row)
    return np.array(A), n, m

def print_matrix(M):
    for row in M:
        print("  ".join(f"{x:8.4f}" for x in row))

def gauss_elimination(A, n, m):
    A = A.astype(float)
    for i in range(min(n, m)):
        max_row = max(range(i, n), key=lambda r: abs(A[r][i]))
        A[[i, max_row]] = A[[max_row, i]]
        if abs(A[i][i]) < 1e-8:
            continue
        for j in range(i + 1, n):
            ratio = A[j][i] / A[i][i]
            A[j, i:] -= ratio * A[i, i:]
    return A

def gauss_jordan(A, n, m):
    A = A.astype(float)
    for i in range(min(n, m)):
        max_row = max(range(i, n), key=lambda r: abs(A[r][i]))
        A[[i, max_row]] = A[[max_row, i]]
        if abs(A[i][i]) < 1e-8:
            continue
        A[i] = A[i] / A[i][i]
        for j in range(n):
            if j != i:
                A[j] -= A[j][i] * A[i]
    return A

def back_substitution(A, n, m):
    x = np.zeros(m)
    for i in range(n-1, -1, -1):
        if i >= m:
            continue
        if abs(A[i][i]) < 1e-8:
            if abs(A[i][-1]) > 1e-8:
                return None
            continue
        x[i] = (A[i][-1] - np.dot(A[i][i+1:m], x[i+1:m])) / A[i][i]
    return x

def solve_by_inverse(Aug, n, m):
    if n != m:
        return None
    A = Aug[:, :-1]
    b = Aug[:, -1]
    if np.linalg.det(A) == 0:
        return None
    x = np.linalg.inv(A).dot(b)
    return x

def solve_by_cramer(Aug, n, m):
    if n != m:
        return None
    A = Aug[:, :-1]
    b = Aug[:, -1]
    det_A = np.linalg.det(A)
    if abs(det_A) < 1e-8:
        return None
    x = np.zeros(n)
    for i in range(n):
        Ai = A.copy()
        Ai[:, i] = b
        x[i] = np.linalg.det(Ai) / det_A
    return x

def solve_by_lu(Aug, n, m):
    if n != m:
        return None
    A = Aug[:, :-1]
    b = Aug[:, -1]
    try:
        from scipy.linalg import lu
        P, L, U = lu(A)
        y = np.linalg.solve(L, P.dot(b))
        x = np.linalg.solve(U, y)
        return x
    except ImportError:
        return None

def solve_by_jacobi(Aug, n, m, tol=1e-10, max_iter=100):
    if n != m:
        return None
    A = Aug[:, :-1]
    b = Aug[:, -1]
    x = np.zeros_like(b)
    for _ in range(max_iter):
        x_new = np.zeros_like(x)
        for i in range(n):
            s = sum(A[i][j] * x[j] for j in range(n) if j != i)
            x_new[i] = (b[i] - s) / A[i][i]
        if np.linalg.norm(x_new - x, ord=np.inf) < tol:
            return x_new
        x = x_new
    return x

def main():
    print("=== Penyelesaian Sistem Persamaan Linear ===")
    print("Metode yang tersedia:")
    print("1. Eliminasi Gauss")
    print("2. Eliminasi Gauss-Jordan")
    print("3. Invers Matriks")
    print("4. Aturan Cramer")
    print("5. Dekomposisi LU")
    print("6. Iteratif Jacobi")
    pilihan = input("Pilih metode (1-6): ")

    A, n, m = input_matrix()

    if pilihan == '1':
        A_gauss = gauss_elimination(A.copy(), n, m)
        x = back_substitution(A_gauss, n, m)
    elif pilihan == '2':
        A_gj = gauss_jordan(A.copy(), n, m)
        x = A_gj[:, -1]
    elif pilihan == '3':
        x = solve_by_inverse(A, n, m)
    elif pilihan == '4':
        x = solve_by_cramer(A, n, m)
    elif pilihan == '5':
        x = solve_by_lu(A, n, m)
    elif pilihan == '6':
        x = solve_by_jacobi(A, n, m)
    else:
        print("Pilihan tidak valid.")
        return

    if x is None:
        print("\nSistem tidak memiliki solusi unik atau tidak dapat diselesaikan dengan metode ini.")
    else:
        print("\nSolusi SPL:")
        for i, xi in enumerate(x):
            print(f"x{i+1} = {xi:.4f}")

main()

