n = int(input("Masukkan banyak baris: "))
def triangle(n):
    print(f"triangle({n})")
    for row in range(1, n+1):
        for column in range(1, 2*n):
            if row == n or row + column == n+1 or column - row == n - 1:
                print("*", end ="")
            else:
                print(end =" ")
        print()
triangle(n)

