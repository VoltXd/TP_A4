import csv
import matplotlib.pyplot as plt

sizes = [1000, 100000, 10000000, 100000000]
tt1_para = [[None] * 4]*15
rows = []


with open('result.csv') as csv_file:
    csv_reader = csv.reader(csv_file, delimiter=';')
    line_count = 0
    for row in csv_reader:
        line_count += 1
        rows.append(row)
    
    j = 0
    for i in range(1, line_count, 2):
        val = float(rows[i][3])
        tt1_para[int(rows[i][1]) - 2][j] = (val)
        if int(rows[i][1]) - 2 == 14:
            j += 1

print(tt1_para)
plt.plot(sizes, tt1_para[0])
plt.plot(sizes, tt1_para[1])
plt.plot(sizes, tt1_para[2])
plt.plot(sizes, tt1_para[3])
plt.xscale("log")
plt.show()