# Program Kalkulator Polinomial
# ----------------------------------------------------------

from sympy import symbols, Poly, factor, integrate, diff

# Definisi variabel x
x = symbols('x')

def input_polynomial():
    expr = input("Masukkan polinomial (contoh: x**2 + 2*x + 1): ")
    return Poly(expr, x)

def tambah(p1, p2):
    return p1 + p2

def kurang(p1, p2):
    return p1 - p2

def kali(p1, p2):
    return p1 * p2

def bagi(p1, p2):
    return p1.div(p2)  # return (hasil, sisa)

def turunan(p):
    return diff(p, x)

def integral(p):
    return integrate(p, x)

def evaluasi(p, nilai):
    return p.eval({x: nilai})

def faktorisasi(p):
    return factor(p)

# Menu interaktif
while True:
    print("\n=== KALKULATOR POLINOMIAL ===")
    print("1. Penjumlahan")
    print("2. Pengurangan")
    print("3. Perkalian")
    print("4. Pembagian")
    print("5. Turunan")
    print("6. Integral")
    print("7. Evaluasi nilai")
    print("8. Faktorisasi")
    print("9. Keluar")
    
    pilihan = input("Pilih menu: ")

    if pilihan == "1":
        p1 = input_polynomial()
        p2 = input_polynomial()
        print("Hasil:", tambah(p1, p2))
    elif pilihan == "2":
        p1 = input_polynomial()
        p2 = input_polynomial()
        print("Hasil:", kurang(p1, p2))
    elif pilihan == "3":
        p1 = input_polynomial()
        p2 = input_polynomial()
        print("Hasil:", kali(p1, p2))
    elif pilihan == "4":
        p1 = input_polynomial()
        p2 = input_polynomial()
        hasil, sisa = bagi(p1, p2)
        print(f"Hasil: {hasil}, Sisa: {sisa}")
    elif pilihan == "5":
        p = input_polynomial()
        print("Turunan:", turunan(p))
    elif pilihan == "6":
        p = input_polynomial()
        print("Integral:", integral(p))
    elif pilihan == "7":
        p = input_polynomial()
        nilai = float(input("Masukkan nilai x: "))
        print(f"Hasil evaluasi: {evaluasi(p, nilai)}")
    elif pilihan == "8":
        p = input_polynomial()
        print("Faktor:", faktorisasi(p))
    elif pilihan == "9":
        print("Terima kasih, program selesai.")
        break
    else:
        print("Pilihan tidak valid, coba lagi.")
