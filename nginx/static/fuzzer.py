import requests
import sys

if len(sys.argv) < 3:
    print("Uso: python fuzzer.py <URL> <WORDLIST>")
    sys.exit(1)

target_url = sys.argv[1].rstrip("/")
wordlist_file = sys.argv[2]

print(f"[+] Fuzzing {target_url}...")

try:
    with open(wordlist_file, "r") as f:
        words = f.read().splitlines()
except FileNotFoundError:
    print("Error: No se encuentra el archivo wordlist.txt")
    sys.exit(1)

for word in words:
    if not word: continue
    url = f"{target_url}/{word}"
    try:
        r = requests.get(url, timeout=2)
        if r.status_code != 404:
            print(f"[FOUND] /{word}  ->  Status: {r.status_code}")
    except:
        pass
