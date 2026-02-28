from os.path import expanduser

file0 = expanduser('~/source0.txt')
file1 = expanduser('~/source1.txt')
file2 = expanduser('~/source2.txt')
output = expanduser('~/dest.txt')

with open(file0, "r") as f0, open(file1, "r") as f1, open(file2, "r") as f2:
    data = set(f0.read().splitlines() + f1.read().splitlines() + f2.read().splitlines())

sorted_data = sorted(data)
print("\n".join(sorted_data))

with open(output, "w") as out:
    out.write("\n".join(sorted_data))