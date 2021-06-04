import csv
import argparse
import json
import pandas as pd
import numpy as np

parser = argparse.ArgumentParser()
parser.add_argument('-p','--path',type=str)
args = parser.parse_args()
path_to_json = args.path

def count(json):
    print("|",end='')
    for path in json['path']:
        csvfile = pd.read_csv(path)
        #print(csvfile[csvfile.columns[:2]][0:json['steps']])
        #reward.append((np.mean(csvfile[csvfile.columns[1]][0:json['steps']]),np.std(csvfile[csvfile.columns[1]][0:json['steps']])))
        mean = np.round(np.mean(csvfile[csvfile.columns[1]][0:json['steps']]),3)
        std = np.round(np.std(csvfile[csvfile.columns[1]][0:json['steps']]),3)
        print(mean,u"\u00B1",std,"|",end='')
    print('')

with open(path_to_json) as f:
    data = json.load(f)
    count(data)