# Simulates the probability that three random segments (with total length = 1) can form a triangle.
# Method: randomly select two cut points along a stick of length 1.
# The three segments are: from 0 to point1, from point1 to point2, and from point2 to 1.
# Triangle condition for sides a, b, c:
# The sum of any two sides must be greater than the third side:
# a + b > c
# a + c > b
# b + c > a
# Or logically: sum of all sides - max_side > max_side → triangle is valid

import random

success = 0
num_trials = int(input("Enter the number of trials: "))

for _ in range(num_trials):
    point1 = random.uniform(0, 1)
    point2 = random.uniform(0, 1)
    point1, point2 = sorted([point1, point2])

    a = point1                 # first segment: 0 to point1
    b = point2 - point1        # second segment: point1 to point2
    c = 1 - point2             # third segment: point2 to 1

    if a + b > c and a + c > b and b + c > a:
        success += 1

probability = success / num_trials
print(f"Probability of forming a triangle: {probability:.4f}")
print(f"Segment a = {a:.4f}")
print(f"Segment b = {b:.4f}")
print(f"Segment c = {c:.4f}")
