# This code is designed to determine whether the Queens in a chess game can attack each other, based on their positions on the chessboard (e.g., d4 and f6).

print("+++++ Two-Queen Chess Program +++++")
letter = "abcdefgh"

def valid(pos):
    return len(pos) == 2 and pos[0] in letter and pos[1].isdigit() and 1 <= int(pos[1]) <= 8

white = input("White queen position (e.g., d4): ").lower()
black = input("Black queen position (e.g., f6): ").lower()

if valid(white) and valid(black):
    x1, y1 = letter.index(white[0]), int(white[1])
    x2, y2 = letter.index(black[0]), int(black[1])
    
    if white == black:
        print(f"White and black queens are in the same position ({white})")
    elif x1 == x2 or y1 == y2 or abs(x1 - x2) == abs(y1 - y2):
        print(f"The white queen in {white} can attack the black queen in {black}")
    else:
        print(f"The white queen in {white} cannot attack the black queen in {black}")
else:
    print("Invalid position! Use a format like d4 or E5.")

print("+++++ Have a nice day +++++")