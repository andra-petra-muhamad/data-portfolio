def input_polinomial():
    derajat = int(input("Masukkan derajat tertinggi polinomial: "))
    koef = []
    for i in range(derajat + 1):
        k = float(input(f"Masukkan koefisien x^{i}: "))
        koef.append(k)
    return koef

def tampilkan_polinomial(p):
    suku = []
    for i, k in enumerate(p):
        if k != 0:
            if i == 0:
                suku.append(f"{k}")
            elif i == 1:
                suku.append(f"{k}x")
            else:
                suku.append(f"{k}x^{i}")
    return " + ".join(suku) if suku else "0"

def tambah(p1, p2):
    panjang = max(len(p1), len(p2))
    p1 += [0] * (panjang - len(p1))
    p2 += [0] * (panjang - len(p2))
    return [p1[i] + p2[i] for i in range(panjang)]

def kurang(p1, p2):
    panjang = max(len(p1), len(p2))
    p1 += [0] * (panjang - len(p1))
    p2 += [0] * (panjang - len(p2))
    return [p1[i] - p2[i] for i in range(panjang)]

def kali(p1, p2):
    hasil = [0] * (len(p1) + len(p2) - 1)
    for i in range(len(p1)):
        for j in range(len(p2)):
            hasil[i+j] += p1[i] * p2[j]
    return hasil

def bagi(p1, p2):
    pembagi_degree = len(p2) - 1
    hasil = [0] * (len(p1) - pembagi_degree)
    sisa = p1[:]
    while len(sisa) >= len(p2):
        faktor = sisa[-1] / p2[-1]
        degree_selisih = len(sisa) - len(p2)
        hasil[degree_selisih] = faktor
        for i in range(len(p2)):
            sisa[degree_selisih + i] -= faktor * p2[i]
        while sisa and abs(sisa[-1]) < 1e-10:
            sisa.pop()
    return hasil, sisa

def turunan(p):
    if len(p) == 1:
        return [0]
    return [p[i] * i for i in range(1, len(p))]

def integral(p):
    return [0] + [p[i] / (i+1) for i in range(len(p))]

def evaluasi(p, x):
    return sum(p[i] * (x ** i) for i in range(len(p)))

# Menu
while True:
    print("\n=== KALKULATOR POLINOMIAL MANUAL ===")
    print("1. Penjumlahan")
    print("2. Pengurangan")
    print("3. Perkalian")
    print("4. Pembagian")
    print("5. Turunan")
    print("6. Integral")
    print("7. Evaluasi nilai")
    print("8. Keluar")
    pilih = input("Pilih menu: ")

    if pilih == "1":
        p1 = input_polinomial()
        p2 = input_polinomial()
        print("Hasil:", tampilkan_polinomial(tambah(p1, p2)))
    elif pilih == "2":
        p1 = input_polinomial()
        p2 = input_polinomial()
        print("Hasil:", tampilkan_polinomial(kurang(p1, p2)))
    elif pilih == "3":
        p1 = input_polinomial()
        p2 = input_polinomial()
        print("Hasil:", tampilkan_polinomial(kali(p1, p2)))
    elif pilih == "4":
        p1 = input_polinomial()
        p2 = input_polinomial()
        hasil, sisa = bagi(p1, p2)
        print("Hasil bagi:", tampilkan_polinomial(hasil))
        print("Sisa:", tampilkan_polinomial(sisa))
    elif pilih == "5":
        p = input_polinomial()
        print("Turunan:", tampilkan_polinomial(turunan(p)))
    elif pilih == "6":
        p = input_polinomial()
        print("Integral:", tampilkan_polinomial(integral(p)) + " + C")
    elif pilih == "7":
        p = input_polinomial()
        nilai = float(input("Masukkan nilai x: "))
        print(f"Hasil evaluasi: {evaluasi(p, nilai)}")
    elif pilih == "8":
        print("Terima kasih, program selesai.")
        break
    else:
        print("Pilihan tidak valid.")
