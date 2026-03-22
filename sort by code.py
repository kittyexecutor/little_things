import re
import argparse

parser = argparse.ArgumentParser(description="Read file")
parser.add_argument("-p","--path", type=str, required=True, help="Use -p or --path to set file path for read data")

args = parser.parse_args()

# regex for lines that start with an HTTP code
code_pattern = re.compile(r"^(\d{3})\b")

# regex for https://...
url_pattern = re.compile(r"(https://\S+)")

with open(args.path, "r", encoding="utf-8") as f:
    for line in f:
        line = line.strip()

        # find status code at start of line
        code_match = code_pattern.match(line)
        if not code_match:
            continue

        status_code = code_match.group(1)

        # find https url in the line
        url_match = url_pattern.search(line)
        if not url_match:
            continue

        url = url_match.group(1)

        # append url into file like 200.txt, 404.txt, etc.
        output_file = f"{status_code}.txt"
        with open(output_file, "a", encoding="utf-8") as out:
            out.write(url + "\n")



