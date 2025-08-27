#This code aims to solve the Tower of Hanoi problem, namely:
# Move all discs from the origin pole to the destination pole using a single auxiliary pole, with the following rules:
# 1. Only one disc may be moved at a time.
# 2. No larger disc may be placed on top of a smaller disc.
# 3. All discs must move from the origin pole to the destination pole according to the rules.

# Logic of the Tower of Hanoi Game
# For n discs:
# 1. Move the first n-1 discs from the Origin pole to the Intermediate pole (using the Destination Pole as an auxiliary).
# 2. Move the largest disc (nth disc) from the Origin pole to the Destination pole.
# 3. Move the n-1 discs from the Intermediate pole back to the Destination pole (using the Origin Pole as an auxiliary).

def hanoi(n, origin, destination, between, steps=1):
    if n == 1:
        print(f"{steps}. Move {n} discs from {origin} to {destination} pole")
        return steps + 1
    steps = hanoi(n - 1, origin, between, destination, steps)
    print(f"{steps}. Move {n} discs from {origin} to {destination} pole")
    steps += 1
    return hanoi(n - 1, between, destination, origin, steps)

# User Input
n = int(input("Enter the number of discs: "))
total_steps = hanoi(n, "A", "C", "B")
print(f"The minimum number of steps required is {total_steps - 1}")