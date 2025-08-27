# Program Determinan & Inverse Matriks
# ----------------------------------------------------------
# - Input: ukuran matriks dan elemen-elemen matriks
# - Proses: hitung determinan dan inverse (jika ada)

def input_matriks():
    # Input ukuran matriks
    while True:
        try:
            n = int(input("Masukkan ukuran matriks (n x n): "))
            if n <= 0:
                print("Ukuran harus positif!")
                continue
            break
        except ValueError:
            print("Masukkan angka bulat!")

    matriks = []
    print(f"Masukkan elemen matriks baris per baris (pisahkan dengan spasi):")
    for i in range(n):
        while True:
            try:
                baris = list(map(float, input(f"Baris {i+1}: ").split()))
                if len(baris) != n:
                    print(f"Harus ada {n} angka di baris ini!")
                    continue
                matriks.append(baris)
                break
            except ValueError:
                print("Masukkan hanya angka!")

    return matriks

def determinan(matrix):
    n = len(matrix)
    mat = [row[:] for row in matrix]  # copy matriks
    det = 1

    for i in range(n):
        # Pivot 0 → tukar baris
        if mat[i][i] == 0:
            for j in range(i+1, n):
                if mat[j][i] != 0:
                    mat[i], mat[j] = mat[j], mat[i]
                    det *= -1
                    break
            else:
                return 0  # determinan 0 → matriks singular

        # Skala pivot
        det *= mat[i][i]
        pivot = mat[i][i]
        for k in range(i+1, n):
            faktor = mat[k][i] / pivot
            for l in range(i, n):
                mat[k][l] -= faktor * mat[i][l]

    return det

def inverse(matrix):
    n = len(matrix)
    # Membuat matriks identitas
    identitas = [[float(i == j) for j in range(n)] for i in range(n)]
    mat = [row[:] for row in matrix]  # copy matriks

    # Gauss-Jordan
    for i in range(n):
        pivot = mat[i][i]
        if pivot == 0:
            for j in range(i+1, n):
                if mat[j][i] != 0:
                    mat[i], mat[j] = mat[j], mat[i]
                    identitas[i], identitas[j] = identitas[j], identitas[i]
                    pivot = mat[i][i]
                    break
            else:
                return None  # Tidak bisa diinverse

        # Normalisasi pivot
        faktor = mat[i][i]
        for k in range(n):
            mat[i][k] /= faktor
            identitas[i][k] /= faktor

        # Nol-kan kolom selain pivot
        for j in range(n):
            if j != i:
                faktor = mat[j][i]
                for k in range(n):
                    mat[j][k] -= faktor * mat[i][k]
                    identitas[j][k] -= faktor * identitas[i][k]

    return identitas

matriks = input_matriks()

print("\nMatriks yang dimasukkan:")
for baris in matriks:
    print(baris)

det = determinan(matriks)
print(f"\nDeterminan: {det}")

if det != 0:
    inv = inverse(matriks)
    print("\nInverse Matriks:")
    for baris in inv:
        print(baris)
else:
    print("\nMatriks ini tidak memiliki inverse (determinannya 0).")
