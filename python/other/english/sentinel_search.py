# Sentinel search is a method where a special value (the target itself)
# is added to the end of the list to eliminate the need for boundary checks during the search.
# This allows us to search without checking if we are out of bounds at each iteration.
# After the search, we check if the index is within the original list length
# to determine whether the target was originally present or just the sentinel.

import random

def sentinel_search(A, target):
    original = A.copy()         # Preserve the original list
    A.append(target)            # Add the sentinel to the end
    i = 0

    # No need to check the list length because the target is guaranteed to be found
    while A[i] != target:
        i += 1

    if i == len(original):
        print(f"Target NOT found in the original list. Found at index {i} due to sentinel.")
    else:
        print(f"Target found at index {i} in the original list.")

    print("\nList with sentinel:")
    print(A)
    print("\nOriginal list:")
    print(original)

# Simulation
n = int(input("Number of elements in the list: "))
A = random.sample(range(1, 1001), n)  # Generate a list of unique random integers
target = int(input("Target to search for: "))
sentinel_search(A, target)
