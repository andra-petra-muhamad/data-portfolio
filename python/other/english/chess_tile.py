# Program: Determining the Color of a Chess Tile from a Position (e.g., a2, b4)

print("Chess Tile Color Program")
position = input("Enter the position of the tile (e.g., a2, b4): ").lower()

# Input Validation
if len(position) != 2 or position[0] not in "abcdefgh" or not position[1].isdigit():
    print("Invalid input! Use format like a2, b4 (letters a-h and numbers 1-8).")
else:
    letter = position[0]
    number = int(position[1])

if number < 1 or number > 8:
    print("Number must be between 1 and 8!")
else:
    # Convert letters to numbers column
    column = ord(letter) - ord('a') + 1
    
    # Color Logic: If the number of columns + rows is even → white, if the number of odd → black
    if (column + number) % 2 == 0:
        color = "white"
    else:
        color = "black"
    print(f"Position {position} is the colored square {color}.")

print("Program completed.")