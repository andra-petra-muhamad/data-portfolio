n = int(input("Masukkan banyak baris: "))
def segitiga(n):
    print(f"segitiga({n})")
    for baris in range(1, n+1):
        for kolom in range(1, 2*n):
            if baris == n or baris + kolom == n+1 or kolom - baris == n - 1:
                print("*", end ="")
            else:
                print(end =" ")
        print()
segitiga(n)

