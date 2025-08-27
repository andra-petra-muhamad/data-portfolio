def input_matrix(): 
    r, c = map(int, input("Enter the size of the matrix (row column): ").split()) 
    return [list(map(float, input(f"Row {i+1}: ").split())) for i in range(r)]

def input_vector(name): 
    return list(map(float, input(f"{name}: ").split()))

def scalar_times_matrix(mat, k): 
    return [[k * x for x in row] for row in mat]
def dot_product(v1, v2): 
    return sum(a * b for a, b in zip(v1, v2))

print("Select operation:\n1. Scalar × Matrix\n2. Dot Product")
select = input("Selection (1/2): ")

if select == "1": 
    m = input_matrix() 
    k = float(input("Enter scalar: "))
    result = scalar_times_matrix(m, k)
    print("Result:")
    [print(row) for row in result]
elif select == "2":
    v1 = input_vector("Vector 1")
    v2 = input_vector("Vector 2")
    if len(v1) != len(v2):
        print("The vector lengths are not the same.")
    else:
        print("Dot product:", dot_product(v1, v2))
else:
    print("Invalid choice.")