def input_polynomial():
    degree = int(input("Enter the highest degree of the polynomial: "))
    coeffs = []
    for i in range(degree + 1):
        c = float(input(f"Enter the coefficient for x^{i}: "))
        coeffs.append(c)
    return coeffs

def display_polynomial(p):
    terms = []
    for i, c in enumerate(p):
        if c != 0:
            if i == 0:
                terms.append(f"{c}")
            elif i == 1:
                terms.append(f"{c}x")
            else:
                terms.append(f"{c}x^{i}")
    return " + ".join(terms) if terms else "0"

def add(p1, p2):
    length = max(len(p1), len(p2))
    p1 += [0] * (length - len(p1))
    p2 += [0] * (length - len(p2))
    return [p1[i] + p2[i] for i in range(length)]

def subtract(p1, p2):
    length = max(len(p1), len(p2))
    p1 += [0] * (length - len(p1))
    p2 += [0] * (length - len(p2))
    return [p1[i] - p2[i] for i in range(length)]

def multiply(p1, p2):
    result = [0] * (len(p1) + len(p2) - 1)
    for i in range(len(p1)):
        for j in range(len(p2)):
            result[i+j] += p1[i] * p2[j]
    return result

def divide(p1, p2):
    divisor_degree = len(p2) - 1
    quotient = [0] * (len(p1) - divisor_degree)
    remainder = p1[:]
    while len(remainder) >= len(p2):
        factor = remainder[-1] / p2[-1]
        degree_diff = len(remainder) - len(p2)
        quotient[degree_diff] = factor
        for i in range(len(p2)):
            remainder[degree_diff + i] -= factor * p2[i]
        while remainder and abs(remainder[-1]) < 1e-10:
            remainder.pop()
    return quotient, remainder

def derivative(p):
    if len(p) == 1:
        return [0]
    return [p[i] * i for i in range(1, len(p))]

def integral(p):
    return [0] + [p[i] / (i+1) for i in range(len(p))]

def evaluate(p, x):
    return sum(p[i] * (x ** i) for i in range(len(p)))

# Menu
while True:
    print("\n=== MANUAL POLYNOMIAL CALCULATOR ===")
    print("1. Addition")
    print("2. Subtraction")
    print("3. Multiplication")
    print("4. Division")
    print("5. Derivative")
    print("6. Integral")
    print("7. Evaluate")
    print("8. Exit")
    choice = input("Choose an option: ")

    if choice == "1":
        p1 = input_polynomial()
        p2 = input_polynomial()
        print("Result:", display_polynomial(add(p1, p2)))
    elif choice == "2":
        p1 = input_polynomial()
        p2 = input_polynomial()
        print("Result:", display_polynomial(subtract(p1, p2)))
    elif choice == "3":
        p1 = input_polynomial()
        p2 = input_polynomial()
        print("Result:", display_polynomial(multiply(p1, p2)))
    elif choice == "4":
        p1 = input_polynomial()
        p2 = input_polynomial()
        quotient, remainder = divide(p1, p2)
        print("Quotient:", display_polynomial(quotient))
        print("Remainder:", display_polynomial(remainder))
    elif choice == "5":
        p = input_polynomial()
        print("Derivative:", display_polynomial(derivative(p)))
    elif choice == "6":
        p = input_polynomial()
        print("Integral:", display_polynomial(integral(p)) + " + C")
    elif choice == "7":
        p = input_polynomial()
        value = float(input("Enter the value of x: "))
        print(f"Evaluation result: {evaluate(p, value)}")
    elif choice == "8":
        print("Thank you, program terminated.")
        break
    else:
        print("Invalid choice.")
