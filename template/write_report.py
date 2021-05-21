import sys

def write_report(conc,level,thold):
	names={'S':'Species','P':'Phylum','G':'Genus'}

	replacements = {'!LEVEL!':names[level],'!THOLD!':thold,'len_kraken':len(conc['kraken']),'len_centrifuge':len(conc['centrifuge']), 'len_clark':len(conc['clark'])}

	with open('template/template.html') as infile, open('report.html', 'w') as outfile:
		for line in infile:
			for src, target in replacements.items():
				line = line.replace(src, str(target))
			outfile.write(line)
