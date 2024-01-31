import csv
import matplotlib.pyplot as plt
import numpy as np
from matplotlib.lines import Line2D

DICT_RES_TO_NAME = { 1241*376:"000009.png", 3282*5114:"img_1.jpg", 2268*4032:"img_2.jpg", 3072*4608:"img_3.jpg", 3999*3999:"img_4.jpg", 2656*3976:"img_5.jpg" }
LIST_RES = list(DICT_RES_TO_NAME.keys())
LIST_RES.sort()
LIST_WINSIZE = [3, 5, 7, 9]
LIST_FEAT = [64, 1024, 4096]
LIST_THREADS = [1, 2, 3, 4]
N_SAMPLES = 10

# Order: time = { winsize:{ n_feat:{ n_thread:{ res:time } } } }
dict_t_convolve = {}
dict_t_eigen = {}

for ws in LIST_WINSIZE:
    dict_t_convolve[ws] = {}
    dict_t_eigen[ws] = {}
    for feat in LIST_FEAT:
        dict_t_convolve[ws][feat] = {}
        dict_t_eigen[ws][feat] = {}
        for thread in LIST_THREADS:
            dict_t_convolve[ws][feat][thread] = {}
            dict_t_eigen[ws][feat][thread] = {}
            for name in DICT_RES_TO_NAME.values():
                dict_t_convolve[ws][feat][thread][name] = 0
                dict_t_eigen[ws][feat][thread][name] = 0

# print(dict_t_convolve)

with open('result_fin.csv', "r") as csv_file:
    csv_reader = csv.reader(csv_file, delimiter=';')
    rows = []
    line_count = 0
    for row in csv_reader:
        line_count += 1
        if line_count == 1:
            continue
        rows.append(row)
    
    ws = 0
    feat = 0
    thread = 0
    name = ""
    for i, row in enumerate(rows):
        subline_count = i % 21
        if subline_count == 0:
            ws = int(row[0])
            feat = int(row[1])
            thread = int(row[3])
            name = row[2]
        elif subline_count < 11:
            dict_t_convolve[ws][feat][thread][name] += float(row[0])
        else:
            dict_t_eigen[ws][feat][thread][name] += float(row[0])

for ws in LIST_WINSIZE:
    for feat in LIST_FEAT:
        for thread in LIST_THREADS:
            for name in DICT_RES_TO_NAME.values():
                dict_t_convolve[ws][feat][thread][name] /= N_SAMPLES
                dict_t_eigen[ws][feat][thread][name] /= N_SAMPLES

DICT_MARKERS = { LIST_WINSIZE[0]:'o', LIST_WINSIZE[1]:'+', LIST_WINSIZE[2]:'*', LIST_WINSIZE[3]:'x' }
DICT_LINE = { LIST_FEAT[0]:'-', LIST_FEAT[1]:':', LIST_FEAT[2]:'-.' }
DICT_COLOR = { LIST_THREADS[0]:'black', LIST_THREADS[1]:'y', LIST_THREADS[2]:'g', LIST_THREADS[3]:'r' }
LEGEND_ELEMENTS = [Line2D([0], [0], marker="o", color="black", markerfacecolor="black"),
                   Line2D([0], [0], marker="+", color="black", markerfacecolor="black"),
                   Line2D([0], [0], marker="*", color="black", markerfacecolor="black"),
                   Line2D([0], [0], marker="x", color="black", markerfacecolor="black"),
                   Line2D([0], [0], linestyle="-", color="black"),
                   Line2D([0], [0], linestyle=":", color="black"),
                   Line2D([0], [0], linestyle="-.", color="black"),
                   Line2D([0], [0], color="black"),
                   Line2D([0], [0], color="y"),
                   Line2D([0], [0], color="g"),
                   Line2D([0], [0], color="r")]
LEGEND_LABELS = [f"WS:{LIST_WINSIZE[0]}", 
                 f"WS:{LIST_WINSIZE[1]}", 
                 f"WS:{LIST_WINSIZE[2]}", 
                 f"WS:{LIST_WINSIZE[3]}", 
                 f"N_features:{LIST_FEAT[0]}",
                 f"N_features:{LIST_FEAT[1]}",
                 f"N_features:{LIST_FEAT[2]}",
                 f"Threads:{LIST_THREADS[0]}",
                 f"Threads:{LIST_THREADS[1]}",
                 f"Threads:{LIST_THREADS[2]}",
                 f"Threads:{LIST_THREADS[3]}"]
for ws in LIST_WINSIZE:
    for feat in LIST_FEAT:
        for thread in LIST_THREADS:
            plt.plot(LIST_RES, [dict_t_eigen[ws][feat][thread][DICT_RES_TO_NAME[res]] for res in LIST_RES], color=DICT_COLOR[thread], marker=DICT_MARKERS[ws], linestyle=DICT_LINE[feat])#, label=f"WS:{ws}, MaxFeat:{feat}, Threads:{thread}")      
plt.xscale("log")
plt.yscale("log")
plt.xlabel("Résolution [pixels]")
plt.ylabel("Temps \"compute_eigenvalues\" [ms]")
plt.legend(LEGEND_ELEMENTS, LEGEND_LABELS)
plt.show()

for ws in LIST_WINSIZE:
    for feat in LIST_FEAT:
        for thread in LIST_THREADS:
            plt.plot(LIST_RES, [dict_t_convolve[ws][feat][thread][DICT_RES_TO_NAME[res]] for res in LIST_RES], color=DICT_COLOR[thread], marker=DICT_MARKERS[ws], linestyle=DICT_LINE[feat])#, label=f"WS:{ws}, MaxFeat:{feat}, Threads:{thread}")      
plt.xscale("log")
plt.yscale("log")
plt.xlabel("Résolution [pixels]")
plt.ylabel("Temps \"compute_convolve\" [ms]")
plt.legend(LEGEND_ELEMENTS, LEGEND_LABELS)
plt.show()

# CPP
T_CPU = 1.0 / (3.2 * 10**9)
for ws in LIST_WINSIZE:
    for feat in LIST_FEAT:
        for thread in LIST_THREADS:
            plt.plot(LIST_RES, [(dict_t_convolve[ws][feat][thread][DICT_RES_TO_NAME[res]] + dict_t_eigen[ws][feat][thread][DICT_RES_TO_NAME[res]]) / res / T_CPU for res in LIST_RES], color=DICT_COLOR[thread], marker=DICT_MARKERS[ws], linestyle=DICT_LINE[feat])#, label=f"WS:{ws}, MaxFeat:{feat}, Threads:{thread}")      

plt.xlabel("Résolution [pixels]")
plt.ylabel("CPP")
plt.legend(LEGEND_ELEMENTS, LEGEND_LABELS)
plt.show()