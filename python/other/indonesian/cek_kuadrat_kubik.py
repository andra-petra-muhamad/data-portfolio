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
    i = -abs(n) if n < 0 else 0  # mulai dari -|n| jika negatif, dari 0 jika positif
    while i * i * i <= n:
        if i * i * i == n:
            return True
        i += 1
    return False

angka = int(input("Masukkan angka: "))

if is_square(angka):
    print(f"{angka} adalah bilangan kuadrat sempurna.")
else:
    print(f"{angka} bukan bilangan kuadrat sempurna.")

if is_cube(angka):
    print(f"{angka} adalah bilangan kubik sempurna.")
else:
    print(f"{angka} bukan bilangan kubik sempurna.")
