# Polynomial Calculator Program
# ----------------------------------------------------------

from sympy import symbols, Poly, factor, integrate, diff

# Define variable x
x = symbols('x')

def input_polynomial():
    expr = input("Enter a polynomial (e.g., x**2 + 2*x + 1): ")
    return Poly(expr, x)

def add(p1, p2):
    return p1 + p2

def subtract(p1, p2):
    return p1 - p2

def multiply(p1, p2):
    return p1 * p2

def divide(p1, p2):
    return p1.div(p2)  # returns (quotient, remainder)

def derivative(p):
    return diff(p, x)

def integral(p):
    return integrate(p, x)

def evaluate(p, value):
    return p.eval({x: value})

def factorize(p):
    return factor(p)

# Interactive menu
while True:
    print("\n=== POLYNOMIAL CALCULATOR ===")
    print("1. Addition")
    print("2. Subtraction")
    print("3. Multiplication")
    print("4. Division")
    print("5. Derivative")
    print("6. Integral")
    print("7. Evaluate")
    print("8. Factorize")
    print("9. Exit")
    
    choice = input("Choose an option: ")

    if choice == "1":
        p1 = input_polynomial()
        p2 = input_polynomial()
        print("Result:", add(p1, p2))
    elif choice == "2":
        p1 = input_polynomial()
        p2 = input_polynomial()
        print("Result:", subtract(p1, p2))
    elif choice == "3":
        p1 = input_polynomial()
        p2 = input_polynomial()
        print("Result:", multiply(p1, p2))
    elif choice == "4":
        p1 = input_polynomial()
        p2 = input_polynomial()
        quotient, remainder = divide(p1, p2)
        print(f"Quotient: {quotient}, Remainder: {remainder}")
    elif choice == "5":
        p = input_polynomial()
        print("Derivative:", derivative(p))
    elif choice == "6":
        p = input_polynomial()
        print("Integral:", integral(p))
    elif choice == "7":
        p = input_polynomial()
        value = float(input("Enter the value of x: "))
        print(f"Evaluation result: {evaluate(p, value)}")
    elif choice == "8":
        p = input_polynomial()
        print("Factors:", factorize(p))
    elif choice == "9":
        print("Thank you, program terminated.")
        break
    else:
        print("Invalid choice, please try again.")
