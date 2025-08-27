import random

# Get 10 unique random numbers from 1 to 100
A = random.sample(range(1, 101), 10)
print("List of numbers:", A)

# Initialization
maximum = A[0]
update_count = 0

# Check and count how many times the maximum is updated
for i in range(1, len(A)):
    if A[i] > maximum:
        print(f"{A[i]} is a new value greater than {maximum} → update!")
        maximum = A[i]
        update_count += 1
    else:
        print(f"{A[i]} is not greater than {maximum}")

# Final Result
print(f"\nThe maximum value is {maximum}")
print(f"The maximum value was updated {update_count} times")