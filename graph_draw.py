import matplotlib.pyplot as plt
import csv
import argparse
import json
import pandas as pd

parser = argparse.ArgumentParser()
parser.add_argument('-p','--path',type=str)
args = parser.parse_args()
path_to_json = args.path
print(path_to_json)

def make_graph(json):
    for path, steps in zip(json['path'],json['steps']):
        print(type(path))
        csvfile = pd.read_csv(path)
        print(csvfile[csvfile.columns[:2]][0:steps])
        plt.plot(csvfile[csvfile.columns[0]][0:steps],csvfile[csvfile.columns[1]][0:steps])
        plt.xlabel(json['x'])
        plt.ylabel(json['y'])
        #print(json['legend'][count])
        plt.legend(json['legend'])
    plt.title(json['title'])
    plt.grid()
    plt.savefig(json['fname'],dpi=400)
    #plt.show()
    plt.clf()

with open(path_to_json) as f:
    data = json.load(f)
    make_graph(data)
