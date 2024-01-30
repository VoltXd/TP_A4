import csv
import matplotlib.pyplot as plt
import numpy as np

sizes = [1000, 100000, 10000000, 100000000]
tsum_seq = np.zeros((15, 4))
tsum_para = np.zeros((15, 4))
tsum_para_dyn = np.zeros((15, 4))
tsum_para_ato = np.zeros((15, 4))
tsum_para_crit = np.zeros((15, 4))
rows = []


with open('result.csv') as csv_file:
    csv_reader = csv.reader(csv_file, delimiter=';')
    line_count = 0
    for row in csv_reader:
        line_count += 1
        rows.append(row)
    
    j = 0
    for i in range(1, line_count, 2):
        tsum_seq[int(rows[i][1]) - 2][j] = float(rows[i][2])
        tsum_para[int(rows[i][1]) - 2][j] = float(rows[i][3])
        tsum_para_dyn[int(rows[i][1]) - 2][j] = float(rows[i][4])
        tsum_para_ato[int(rows[i][1]) - 2][j] = float(rows[i][5])
        tsum_para_crit[int(rows[i][1]) - 2][j] = float(rows[i][6])
        if int(rows[i][1]) - 2 == 14:
            j += 1

plt.plot(sizes, tsum_seq[0], marker="*", label=f"seq")
for i in range(15):
    if i + 2 <= 8:
        plt.plot(sizes, tsum_para[i], marker="o", label=f"para:{i+2}")
    else:
        plt.plot(sizes, tsum_para[i], linestyle=":", marker="+", label=f"para:{i+2}")
plt.legend()
plt.xscale("log")
plt.yscale("log")
plt.show()
plt.plot(sizes, tsum_seq[0], marker="*", label=f"seq")
for i in range(15):
    if i + 2 <= 8:
        plt.plot(sizes, tsum_para_dyn[i], marker="o", label=f"para_dyn:{i+2}")
    else:
        plt.plot(sizes, tsum_para_dyn[i], linestyle=":", marker="+", label=f"para_dyn:{i+2}")
plt.legend()
plt.xscale("log")
plt.yscale("log")
plt.show()
plt.plot(sizes, tsum_seq[0], marker="*", label=f"seq")
for i in range(15):
    if i + 2 <= 8:
        plt.plot(sizes, tsum_para_ato[i], marker="o", label=f"para_ato:{i+2}")
    else:
        plt.plot(sizes, tsum_para_ato[i], linestyle=":", marker="+", label=f"para_ato:{i+2}")
plt.legend()
plt.xscale("log")
plt.yscale("log")
plt.show()
plt.plot(sizes, tsum_seq[0], marker="*", label=f"seq")
for i in range(15):
    if i + 2 <= 8:
        plt.plot(sizes, tsum_para_crit[i], marker="o", label=f"para_crit:{i+2}")
    else:
        plt.plot(sizes, tsum_para_crit[i], linestyle=":", marker="+", label=f"para_crit:{i+2}")
plt.legend()
plt.xscale("log")
plt.yscale("log")
plt.show()