def input_matrix():
    n = int(input("Enter the number of equations (rows): "))
    A = []
    print("Enter the elements of the augmented matrix (number of columns = number of variables + 1).")
    print("Example: for 2 variables, enter 3 values per row (a1 a2 b).")

    m = None
    for i in range(n):
        row = list(map(float, input(f"Row {i+1} (separate with spaces): ").split()))
        if m is None:
            m = len(row) - 1  # number of variables = total columns - 1 (right-hand side)
        elif len(row) != m + 1:
            raise ValueError(f"Row {i+1} must contain {m + 1} elements, consistent with the first row.")
        A.append(row)

    return A, n, m

def print_matrix(M):
    for row in M:
        print("  ".join(f"{x:8.3f}" for x in row))

def forward_elimination(A, n, m):
    for i in range(min(n, m)):
        # Pivoting
        max_row = max(range(i, n), key=lambda r: abs(A[r][i]))
        A[i], A[max_row] = A[max_row], A[i]

        pivot = A[i][i]
        if abs(pivot) < 1e-12:
            continue

        for j in range(i + 1, n):
            ratio = A[j][i] / pivot
            for k in range(i, m + 1):
                A[j][k] -= ratio * A[i][k]
    return A

def back_substitution(A, n, m):
    x = [0 for _ in range(m)]
    for i in range(n - 1, -1, -1):
        if i >= m:
            continue
        if abs(A[i][i]) < 1e-8:
            if abs(A[i][m]) < 1e-8:
                continue  # zero row → infinite solutions
            else:
                return None  # inconsistent row → no solution
        x[i] = A[i][m] / A[i][i]
        for j in range(i):
            A[j][m] -= A[j][i] * x[i]
    return x

def check_solution_type(A, n, m):
    for i in range(n):
        if all(abs(A[i][j]) < 1e-8 for j in range(m)) and abs(A[i][m]) > 1e-8:
            return "No solution"
    rank = sum(any(abs(val) > 1e-8 for val in row[:m]) for row in A)
    if rank < m:
        return "Infinite solutions"
    else:
        return "Unique solution"

def main():
    A, n, m = input_matrix()
    print("\nInitial Augmented Matrix:")
    print_matrix(A)

    A = forward_elimination(A, n, m)
    print("\nAfter Gauss Elimination:")
    print_matrix(A)

    solution_type = check_solution_type(A, n, m)
    print(f"\nSolution type: {solution_type}")

    if solution_type == "Unique solution":
        sol = back_substitution(A, n, m)
        if sol:
            print("\nSolution:")
            for i, val in enumerate(sol):
                print(f"x{i+1} = {val:.4f}")
    elif solution_type == "Infinite solutions":
        print("\nThe system has infinitely many solutions (underdetermined system).")
    else:
        print("\nThe system has no solution.")

main()
