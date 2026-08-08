import urllib.request
import json

# We will fetch a generic list of common english words, filter for length 3-7,
# and select about 1500 words suitable for kids.

url = "https://raw.githubusercontent.com/first20hours/google-10000-english/master/google-10000-english-no-swears.txt"
response = urllib.request.urlopen(url)
data = response.read().decode('utf-8')
words = data.split('\n')

# Filter for kids (length 3 to 7), basic words.
filtered_words = [w.strip().upper() for w in words if 3 <= len(w.strip()) <= 7 and w.strip().isalpha()]
final_words = filtered_words[:1500]

dart_content = "class WordDataset {\n"
dart_words = ", ".join([f"'{w}'" for w in final_words])
dart_content += f"  static const List<String> allWords = [{dart_words}];\n"
dart_content += "}\n"

with open("lib/core/constants/word_dataset.dart", "w") as f:
    f.write(dart_content)

print(f"Generated dataset with {len(final_words)} words.")
