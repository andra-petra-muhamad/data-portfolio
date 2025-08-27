# Matrix Determinant & Inverse Program
# ----------------------------------------------------------
# - Input: Matrix size and matrix elements
# - Process: Calculate the determinant and inverse (if any)

import numpy as np

# Input matrix size
n = int(input("Enter the size of the matrix (n x n): "))

# Input matrix elements
print(f"Enter the elements of the {n}x{n} matrix (separate with spaces):")
matrix = []
for i in range(n):
    row = list(map(float, input(f"Row {i+1}: ").split()))
    matrix.append(row)

# Convert to NumPy array
A = np.array(matrix)

# Display the matrix
print("\nMatrix A:")
print(A)

# Calculate determinant
determinant = np.linalg.det(A)
print(f"\nDeterminant of the matrix: {determinant}")

# Check if the matrix has an inverse
if np.isclose(determinant, 0):
    print("\nThe matrix does not have an inverse because its determinant is zero.")
else:
    inverse = np.linalg.inv(A)
    print("\nInverse of the matrix:")
    print(inverse)
