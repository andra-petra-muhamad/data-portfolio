# Matrix Determinant & Inverse Program
# ----------------------------------------------------------
# - Input: matrix size and matrix elements
# - Process: calculate determinant and inverse (if it exists)

def input_matrix():
    # Input matrix size
    while True:
        try:
            n = int(input("Enter the size of the matrix (n x n): "))
            if n <= 0:
                print("Size must be positive!")
                continue
            break
        except ValueError:
            print("Please enter an integer!")

    matrix = []
    print(f"Enter the elements of the matrix row by row (separate with spaces):")
    for i in range(n):
        while True:
            try:
                row = list(map(float, input(f"Row {i+1}: ").split()))
                if len(row) != n:
                    print(f"There must be exactly {n} numbers in this row!")
                    continue
                matrix.append(row)
                break
            except ValueError:
                print("Please enter numbers only!")

    return matrix

def determinant(matrix):
    n = len(matrix)
    mat = [row[:] for row in matrix]  # copy matrix
    det = 1

    for i in range(n):
        # If pivot is 0 → swap rows
        if mat[i][i] == 0:
            for j in range(i+1, n):
                if mat[j][i] != 0:
                    mat[i], mat[j] = mat[j], mat[i]
                    det *= -1
                    break
            else:
                return 0  # determinant is 0 → singular matrix

        # Multiply determinant by pivot value
        det *= mat[i][i]
        pivot = mat[i][i]
        for k in range(i+1, n):
            factor = mat[k][i] / pivot
            for l in range(i, n):
                mat[k][l] -= factor * mat[i][l]

    return det

def inverse(matrix):
    n = len(matrix)
    # Create identity matrix
    identity = [[float(i == j) for j in range(n)] for i in range(n)]
    mat = [row[:] for row in matrix]  # copy matrix

    # Gauss-Jordan elimination
    for i in range(n):
        pivot = mat[i][i]
        if pivot == 0:
            for j in range(i+1, n):
                if mat[j][i] != 0:
                    mat[i], mat[j] = mat[j], mat[i]
                    identity[i], identity[j] = identity[j], identity[i]
                    pivot = mat[i][i]
                    break
            else:
                return None  # Cannot be inverted

        # Normalize pivot row
        factor = mat[i][i]
        for k in range(n):
            mat[i][k] /= factor
            identity[i][k] /= factor

        # Make other rows' column i = 0
        for j in range(n):
            if j != i:
                factor = mat[j][i]
                for k in range(n):
                    mat[j][k] -= factor * mat[i][k]
                    identity[j][k] -= factor * identity[i][k]

    return identity

matrix = input_matrix()

print("\nMatrix entered:")
for row in matrix:
    print(row)

det = determinant(matrix)
print(f"\nDeterminant: {det}")

if det != 0:
    inv = inverse(matrix)
    print("\nMatrix Inverse:")
    for row in inv:
        print(row)
else:
    print("\nThis matrix does not have an inverse (its determinant is 0).")
    
    
    
 7.12   -8.56   9.44   -6.88   5.33
-4.75   6.19  -7.51    8.62  -9.73
10.38  -11.47   5.96  -3.82   7.28
-6.15   9.23  -4.37   8.91  -12.56
5.62   -7.74   6.81  -9.45   8.17
