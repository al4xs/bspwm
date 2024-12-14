import sys
import os

def generate(module: str, url: str):

    with open(module, "r") as f:
        data = f.read()
        data = data.replace("{{data}}", url)
        print(data)



if len(sys.argv) <= 1:
    print("Usage: py report.py <module> <url>")
    print("Please refer to the values that will be replaced with {{data}}")
else:
    generate(sys.argv[1], sys.argv[2])
