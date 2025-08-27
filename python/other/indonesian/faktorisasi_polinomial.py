# Program Faktorisasi Polinomial
# ---------------------------------------
# Program ini menerima input berupa polinomial berderejat hingga 3
# dan mencoba memfaktorkannya ke dalam bentuk linear (jika memungkinkan)
# dengan mencari akar-akar real menggunakan teorema faktor dan pembagian polinomial.

import sympy as sp

def faktorisasi_polinomial():
    print("=== Faktorisasi Polinomial ===")
    x = sp.Symbol('x')

    # Input polinomial dalam bentuk string
    expr_str = input("Masukkan polinomial (misal: x**3 - 6*x**2 + 11*x - 6): ")
    try:
        poly = sp.sympify(expr_str)
    except:
        print("Format polinomial tidak valid.")
        return

    # Faktorisasi menggunakan SymPy
    faktor = sp.factor(poly)

    print(f"\nPolinomial awal: {poly}")
    print(f"Hasil faktorisasi: {faktor}")

faktorisasi_polinomial()
