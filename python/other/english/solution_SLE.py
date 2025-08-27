# ============================================================
# Interactive Linear System Solver (SPL)
# Supported Methods:
# 1. Gauss Elimination
# 2. Gauss-Jordan Elimination
# 3. Matrix Inverse
# 4. Cramer's Rule
# 5. LU Decomposition
# 6. Jacobi Iterative Method
#
# The user is prompted to input the augmented matrix (A|b)
# and select a method. The program computes and displays the solution,
# if one exists. It also handles no-solution or infinite-solution cases.
# ============================================================

import numpy as np

def input_matrix():
    n = int(input("Enter the number of equations (rows): "))
    m = int(input("Enter the number of variables (columns): "))
    print("Enter the elements of the augmented matrix A|b (one row at a time, space-separated):")
    A = []
    for i in range(n):
        row = list(map(float, input(f"Row {i+1}: ").split()))
        if len(row) != m + 1:
            raise ValueError("Each row must contain the number of variables + 1.")
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
    print("=== Linear System Solver ===")
    print("Available Methods:")
    print("1. Gauss Elimination")
    print("2. Gauss-Jordan Elimination")
    print("3. Matrix Inverse Method")
    print("4. Cramer's Rule")
    print("5. LU Decomposition")
    print("6. Jacobi Iterative Method")
    choice = input("Choose a method (1-6): ")

    A, n, m = input_matrix()

    if choice == '1':
        A_gauss = gauss_elimination(A.copy(), n, m)
        x = back_substitution(A_gauss, n, m)
    elif choice == '2':
        A_gj = gauss_jordan(A.copy(), n, m)
        x = A_gj[:, -1]
    elif choice == '3':
        x = solve_by_inverse(A, n, m)
    elif choice == '4':
        x = solve_by_cramer(A, n, m)
    elif choice == '5':
        x = solve_by_lu(A, n, m)
    elif choice == '6':
        x = solve_by_jacobi(A, n, m)
    else:
        print("Invalid choice.")
        return

    if x is None:
        print("\nThe system has no unique solution or the method cannot be applied.")
    else:
        print("\nSolution:")
        for i, xi in enumerate(x):
            print(f"x{i+1} = {xi:.4f}")

main()
