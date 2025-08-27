# Kode ini dibuat untuk menentukan apakah Menteri (Queen) dalam permainan catur dapat menyerang 
# satu sama lain, berdasarkan posisi mereka di papan catur (misalnya d4 dan f6).

print("+++++ Program Catur Dua Menteri +++++")
huruf = "abcdefgh"

def valid(pos):
    return len(pos) == 2 and pos[0] in huruf and pos[1].isdigit() and 1 <= int(pos[1]) <= 8

putih = input("Posisi menteri putih (misal: d4): ").lower()
hitam = input("Posisi menteri hitam (misal: f6): ").lower()

if valid(putih) and valid(hitam):
    x1, y1 = huruf.index(putih[0]), int(putih[1])
    x2, y2 = huruf.index(hitam[0]), int(hitam[1])

    if putih == hitam:
        print(f"Menteri putih dan hitam berada di posisi yang sama ({putih})")
    elif x1 == x2 or y1 == y2 or abs(x1 - x2) == abs(y1 - y2):
        print(f"Menteri putih di {putih} dapat menyerang menteri hitam di {hitam}")
    else:
        print(f"Menteri putih di {putih} TIDAK dapat menyerang menteri hitam di {hitam}")
else:
    print("Posisi tidak valid! Gunakan format seperti d4 atau E5.")

print("+++++ Semoga harimu menyenangkan +++++")
