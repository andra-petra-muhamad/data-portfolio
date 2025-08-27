def input_matrix():
    n = int(input("Masukkan jumlah persamaan (baris): "))
    m = int(input("Masukkan jumlah variabel (kolom): "))
    print("Masukkan elemen augmented matrix (baris demi baris):")
    A = []
    for i in range(n):
        row = list(map(float, input(f"Baris {i+1} (pisahkan dengan spasi): ").split()))
        if len(row) != m + 1:
            raise ValueError("Setiap baris harus memiliki jumlah variabel + 1 elemen.")
        A.append(row)
    return A, n, m

def print_matrix(M):
    for row in M:
        print("  ".join(f"{x:8.3f}" for x in row))

def forward_elimination(A, n, m):
    for i in range(min(n, m)):
        # Pivoting: cari baris dengan nilai absolut terbesar di kolom i
        max_row = max(range(i, n), key=lambda r: abs(A[r][i]))
        A[i], A[max_row] = A[max_row], A[i]

        pivot = A[i][i]
        if pivot == 0:
            continue  # Lewati baris jika pivot nol (nanti dicek jenis solusi)

        for j in range(i + 1, n):
            ratio = A[j][i] / pivot
            for k in range(i, m + 1):
                A[j][k] -= ratio * A[i][k]
    return A

def back_substitution(A, n, m):
    x = [0 for _ in range(m)]
    for i in range(n - 1, -1, -1):
        if i >= m:
            continue  # baris lebih banyak dari kolom (underdetermined)
        if A[i][i] == 0:
            if A[i][m] == 0:
                continue  # baris nol semua → solusi tak hingga
            else:
                return None  # tidak ada solusi
        x[i] = A[i][m] / A[i][i]
        for j in range(i):
            A[j][m] -= A[j][i] * x[i]
    return x

def check_solution_type(A, n, m):
    for i in range(n):
        if all(abs(A[i][j]) < 1e-8 for j in range(m)) and abs(A[i][m]) > 1e-8:
            return "Tidak ada solusi"
    rank = sum(any(abs(val) > 1e-8 for val in row[:m]) for row in A)
    if rank < m:
        return "Tak hingga solusi"
    else:
        return "Unik"

def main():
    A, n, m = input_matrix()
    print("\nAugmented Matrix Awal:")
    print_matrix(A)

    A = forward_elimination(A, n, m)
    print("\nSetelah Eliminasi Gauss:")
    print_matrix(A)

    tipe = check_solution_type(A, n, m)
    print(f"\nJenis solusi: {tipe}")

    if tipe == "Unik":
        sol = back_substitution(A, n, m)
        if sol:
            print("\nSolusi:")
            for i, val in enumerate(sol):
                print(f"x{i+1} = {val:.4f}")
    elif tipe == "Tak hingga solusi":
        print("\nSolusi tak hingga: sistem underdetermined (jumlah variabel > rank)")
    else:
        print("\nSistem tidak memiliki solusi")

main()
