def input_matriks():
    r, c = map(int, input("Masukkan ukuran matriks (baris kolom): ").split())
    return [list(map(float, input(f"Baris {i+1}: ").split())) for i in range(r)]

def input_vektor(nama):
    return list(map(float, input(f"{nama}: ").split()))

def skalar_kali_matriks(mat, k): 
    return [[k * x for x in row] for row in mat]
def dot_product(v1, v2): 
    return sum(a * b for a, b in zip(v1, v2))

print("Pilih operasi:\n1. Skalar × Matriks\n2. Dot Product")
pilih = input("Pilihan (1/2): ")

if pilih == "1":
    m = input_matriks()
    k = float(input("Masukkan skalar: "))
    hasil = skalar_kali_matriks(m, k)
    print("Hasil:")
    [print(row) for row in hasil]
elif pilih == "2":
    v1 = input_vektor("Vektor 1")
    v2 = input_vektor("Vektor 2")
    if len(v1) != len(v2):
        print("Panjang vektor tidak sama.")
    else:
        print("Dot product:", dot_product(v1, v2))
else:
    print("Pilihan tidak valid.")
