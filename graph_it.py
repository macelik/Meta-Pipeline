#!/usr/bin/env python
from argparse import ArgumentParser
import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
from template import write_report

def check_positive(value):
	ivalue = float(value)
	if ivalue <= 0:
		raise parser.error("%s is an invalid positive int value" % value)
	return ivalue
parser = ArgumentParser(description="Compare Kraken2, Centrifuge and Clark results")
parser.add_argument("-l", 
					choices=["S", "G", "P"],
					default="P", type=str, help="Level to be plotted")
parser.add_argument("-t", type=check_positive,required=True,
					help="Minimum percentage")
parser.add_argument("-i", type=str, required=True,
					help="results directory")



args = parser.parse_args()

level= args.l
thold=args.t
d=args.i
#d += '/'

def parse_data(data):
	pyhlum={}
	pyhlum_raw={}
	for x in data:
		if x[3] == level:
			pyhlum_raw[x[5].lstrip()]=x[0].lstrip()
			if float(x[0].lstrip()) > thold:
				pyhlum[x[5].lstrip()]=x[0].lstrip()
				continue
		if x[3] == 'U':
			pyhlum[x[5].lstrip()]=x[0].lstrip()
			pyhlum_raw[x[5].lstrip()]=x[0].lstrip()
			continue
	return pyhlum,pyhlum_raw

def parse_clark(data3):
	clark={}
	clark_u={}
	a=0
	if level == 'G' or level == 'P':
		if level =='G':
			a=5
		else:
			a=1
		for x,y in zip(data3['Lineage'],data3['Proportion_All(%)']):
			if x == 'UNKNOWN':
				clark['unclassified']=y
				continue
			if x.split(';')[a] != '':
				if x.split(';')[a] not in clark:
					p=x.split(';')[a]
					clark[p]=y
				else:
					clark[p]+=y
				
	elif level == 'S':
		
		for x,y in zip(data3['Name'],data3['Proportion_All(%)']):
			
			if x == 'UNKNOWN':
				clark['unclassified']=y
				continue
			else:
				if x not in clark:
					clark[x]=y
					continue
				else:
					clark[x]+=y
		
	for x in clark:
		if float(clark[x]) > thold:
			clark_u[x]=clark[x]
	return clark_u,clark

def conc(kraken,centrifuge,clark):
	conc={}
	for k,v in kraken.items():
		if 'kraken' not in conc:
			conc['kraken']={}
			conc['kraken'][k]=float(v)
		else:
			conc['kraken'][k]=float(v)
	for k,v in centrifuge.items():
		if 'centrifuge' not in conc:
			conc['centrifuge']={}
			conc['centrifuge'][k]=float(v)
		else:
			conc['centrifuge'][k]=float(v)
	for k,v in clark.items():
		if 'clark' not in conc:
			conc['clark']={}
			conc['clark'][k]=v
		else:
			conc['clark'][k]=v
	return conc

def conc_raw(kraken,centrifuge,clark):
	conc_raw={}
	for k,v in phylum1_raw.items():
		if float(v) == 0:
			continue
		if 'kraken' not in conc_raw:
			conc_raw['kraken']={}
			conc_raw['kraken'][k]=float(v)
		else:
			conc_raw['kraken'][k]=float(v)
	for k,v in phylum2_raw.items():
		if float(v) == 0:
			continue
		if 'centrifuge' not in conc_raw:
			conc_raw['centrifuge']={}
			conc_raw['centrifuge'][k]=float(v)
		else:
			conc_raw['centrifuge'][k]=float(v)
	for k,v in phylum3_raw.items():
		if float(v) == 0:
			continue
		if 'clark' not in conc_raw:
			conc_raw['clark']={}
			conc_raw['clark'][k]=v
		else:
			conc_raw['clark'][k]=v
	return conc_raw

def lets_plot(conc):
	df_group=pd.DataFrame.from_dict(conc, orient='columns')

	df_group.plot.bar(edgecolor = 'white',figsize=(18, 10))
	plt.title('differences',color = 'black')
	plt.xticks(color = 'black')
	plt.yticks(color = 'black')
	plt.xlabel('Phylum',color = 'black')
	plt.ylabel('Percentage',color = 'black')
	plt.legend(title = 'Tool', fontsize = 12)
	plt.tight_layout()
	plt.savefig('{}/bar_grouped.png'.format(d))
	return df_group

krak = d + '/krakreport'
data = np.loadtxt(krak, delimiter='\t', skiprows=False, dtype=str)
cent = d + '/cent.to.kreport.txt'
data2 = np.loadtxt(cent, delimiter='\t', skiprows=False, dtype=str)
data3 = pd.read_csv(d + '/abundance.csv', sep=',', comment='#', na_values=['Nothing'])


phylum1,phylum1_raw=parse_data(data)
phylum2,phylum2_raw=parse_data(data2)
phylum3,phylum3_raw=parse_clark(data3)

conc=conc(kraken,centrifuge,clark)
conc_raw=conc_raw(kraken,centrifuge,clark)
df_group=lets_plot(conc)
df_group=df_group.replace(np.nan, 'None')
df_group.to_csv(r'{}/Comparsion_Table.txt'.format(d), sep='\t', mode='a')
df_group_raw=pd.DataFrame.from_dict(conc_raw, orient='columns')
df_group_raw=df_group_raw.replace(np.nan, 'None')
df_group_raw.to_csv(r'{}/Comparsion_Raw_Table.txt'.format(d), sep='\t', mode='a')

write_report.write_report(conc,level,thold,d)