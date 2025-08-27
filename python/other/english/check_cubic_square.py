def is_square(n):
    if n < 0:
        return False
    i = 0
    while i * i <= n:
        if i * i == n:
            return True
        i += 1
    return False

def is_cube(n):
    i = -abs(n) if n < 0 else 0 # start from -|n| if negative, from 0 if positive
    while i * i * i <= n:
        if i * i * i == n:
            return True
        i += 1
    return False

number = int(input("Enter a number: "))

if is_square(number):
    print(f"{number} is a perfect square.")
else:
    print(f"{number} is not a perfect square.")

if is_cube(number):
    print(f"{number} is a perfect cube.")
else:
    print(f"{number} is not a perfect cube.")