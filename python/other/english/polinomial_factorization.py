# Polynomial Factorization Program
# ---------------------------------------
# This program takes input in the form of a polynomial of degree up to 3
# and attempts to factor it into linear form (if possible)
# by finding real roots using the factor theorem and polynomial division.

import sympy as sp

def factor_polynomial():
    print("=== Polynomial Factorization ===")
    x = sp.Symbol('x')

    # Input polynomial as a string
    expr_str = input("Enter a polynomial (e.g., x**3 - 6*x**2 + 11*x - 6): ")
    try:
        poly = sp.sympify(expr_str)
    except:
        print("Invalid polynomial format.")
        return

    # Factorization using SymPy
    factors = sp.factor(poly)

    print(f"\nOriginal polynomial: {poly}")
    print(f"Factored form: {factors}")

factor_polynomial()
