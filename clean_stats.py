stats = open("./semifinal_stats.txt", 'r')
output = open("./final_stats.txt", 'w')
for i, line in enumerate(stats):
    if i == 0:
        output.write(line)
    elif not i == 0 and not line.startswith("S"):
            output.write(line)
