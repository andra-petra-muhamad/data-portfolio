print("Let's find the initials and age category of the TV villain")

# Input data
name = input("Your name: ").strip()
year = int(input("Your date of birth: "))

# Calculate age and category
age = 2025 - year
if age <= 10:
    category = "Children"
elif age <= 18:
    category = "Teenager"
else:
    category = "Adult"

# Get initials
name_word = name.title().split() # Capitalize the title, split into a list
number_of_words = len(name_word)

if number_of_words <= 4:
    initials = "".join(word[0] for word in name_word)
    print(f"Your initials are {initials}")
    print(f"You are already in {category}")
else:
    print("Sorry, your name is too long. Maximum 4 words yes!")
print("Now you know the characteristics of the criminals being broadcast on TV!!!")