def caesar(text, key, mode="encryption"): #Combined encryption and decryption function
    result = ""
    for char in text:
        if char.isalpha():
            base = ord('A') if char.isupper() else ord('a') # Determines the ASCII base point
            # Determines the shift direction:
            # If encrypting, shift forward (+key),
            # If decrypting, shift backward (-key).
            shift = key if mode == "encryption" else -key
            result += chr((ord(char) - base + shift) % 26 + base)
        else:
            result += char # numbers, spaces, fixed symbols
    return result

# Input
text = input("Enter text: ")
key = int(input("Enter key (shift letter): "))

# Process
cipher = caesar(text, key, mode="encryption")
plain = caesar(cipher, key, mode="decryption")

# Output
print(f"\nOriginal text: {text}")
print(f"Encrypted: {cipher}")
print(f"After reading: {plain}")

'''
Calculation Example
For example:

char = 'c', key = 3, mode = encryption

base = ord('a') = 97

(ord('c') - 97 + 3) % 26 = (99 - 97 + 3) % 26 = 5

chr(5 + 97) = 'f'
So 'c' → 'f'.
'''