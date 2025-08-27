def caesar(teks, kunci, mode="enkripsi"): #Fungsi gabungan enkripsi dan dekripsi
    hasil = ""
    for char in teks:
        if char.isalpha():
            base = ord('A') if char.isupper() else ord('a') # Menentukan titik dasar ASCII

            # Menentukan arah pergeseran:
            # Jika enkripsi, geser maju (+kunci),
            # Jika dekripsi, geser mundur (-kunci).

            geser = kunci if mode == "enkripsi" else -kunci 
            hasil += chr((ord(char) - base + geser) % 26 + base)
        else:
            hasil += char  # angka, spasi, simbol tetap
    return hasil

# Input
teks = input("Masukkan teks: ")
kunci = int(input("Masukkan kunci (geser huruf): "))

# Proses
cipher = caesar(teks, kunci, mode="enkripsi")
plain = caesar(cipher, kunci, mode="dekripsi")

# Output
print(f"\nTeks asli     : {teks}")
print(f"Terenkripsi   : {cipher}")
print(f"Setelah baca  : {plain}")

'''
Contoh Perhitungan
Misalnya:

char = 'c', kunci = 3, mode = enkripsi

base = ord('a') = 97

(ord('c') - 97 + 3) % 26 = (99 - 97 + 3) % 26 = 5

chr(5 + 97) = 'f'
Jadi 'c' → 'f'.
'''

