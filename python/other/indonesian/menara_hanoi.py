#Kode ini bertujuan untuk menyelesaikan masalah Menara Hanoi (Tower of Hanoi), yaitu:
# Memindahkan semua cakram dari tiang asal ke tiang tujuan menggunakan satu tiang bantu, dengan aturan:
# 1. Hanya satu cakram yang boleh dipindahkan dalam satu waktu.
# 2. Tidak boleh meletakkan cakram besar di atas cakram yang lebih kecil.
# 3. Semua cakram harus berpindah dari tiang asal ke tiang tujuan sesuai aturan.

# Logika Permainan Menara Hanoi
# Untuk n cakram:
# 1. Pindahkan n-1 cakram pertama dari tiang Asal ke tiang Antara (menggunakan Tiang Tujuan sebagai bantu).
# 2. Pindahkan cakram terbesar (cakram ke-n) dari tiang Asal ke tiang Tujuan.
# 3. Pindahkan kembali n-1 cakram dari tiang Antara ke tiang Tujuan (menggunakan Tiang Asal sebagai bantu).

def hanoi(n, asal, tujuan, antara, langkah=1):
    if n == 1:
        print(f"{langkah}. Pindahkan cakram {n} dari tiang {asal} ke tiang {tujuan}")
        return langkah + 1
    langkah = hanoi(n - 1, asal, antara, tujuan, langkah)
    print(f"{langkah}. Pindahkan cakram {n} dari tiang {asal} ke tiang {tujuan}")
    langkah += 1
    return hanoi(n - 1, antara, tujuan, asal, langkah)

# Input dari pengguna
n = int(input("Masukkan jumlah cakram: "))
total_langkah = hanoi(n, "A", "C", "B")
print(f"Banyak langkah minimum yang dibutuhkan adalah {total_langkah - 1}")





















