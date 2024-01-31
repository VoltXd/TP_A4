import csv
import matplotlib.pyplot as plt
import numpy as np

sizes = [1000, 100000, 10000000, 100000000]
tt1_seq = np.zeros((15, 4))
tt1_para = np.zeros((15, 4))
tt2_seq = np.zeros((15, 4))
tt2_para = np.zeros((15, 4))
rows = []


with open('result.csv') as csv_file:
    csv_reader = csv.reader(csv_file, delimiter=';')
    line_count = 0
    for row in csv_reader:
        line_count += 1
        rows.append(row)
    
    j = 0
    for i in range(1, line_count, 2):
        tt1_seq[int(rows[i][1]) - 2][j] = float(rows[i][2])
        tt1_para[int(rows[i][1]) - 2][j] = float(rows[i][3])
        tt2_seq[int(rows[i][1]) - 2][j] = float(rows[i][4])
        tt2_para[int(rows[i][1]) - 2][j] = float(rows[i][5])
        if int(rows[i][1]) - 2 == 14:
            j += 1

plt.figure(figsize=(12,6))
plt.plot(sizes, tt1_seq[0], marker="*", label=f"seq")
for i in range(15):
    if i + 2 <= 4:
        plt.plot(sizes, tt1_para[i], marker="o", label=f"para:{i+2}")
    else:
        plt.plot(sizes, tt1_para[i], linestyle=":", marker="+", label=f"para:{i+2}")
plt.legend()
plt.xscale("log")
plt.yscale("log")
plt.xlabel("Size")
plt.ylabel("Duration [ms]")
plt.show()
plt.figure(figsize=(12,6))
plt.plot(sizes, tt2_seq[0], marker="*", label=f"seq")
for i in range(15):
    if i + 2 <= 4:
        plt.plot(sizes, tt2_para[i], marker="o", label=f"para:{i+2}")
    else:
        plt.plot(sizes, tt2_para[i], linestyle=":", marker="+", label=f"para:{i+2}")
plt.legend()
plt.xscale("log")
plt.yscale("log")
plt.xlabel("Size")
plt.ylabel("Duration [ms]")
plt.show()