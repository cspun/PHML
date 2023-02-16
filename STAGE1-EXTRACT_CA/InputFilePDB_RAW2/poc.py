import glob
for file in glob.glob("./A_*.pdb"):
	CAfile=file[:-4]
	CAfile= CAfile+"_CA.pdb"
	newfile = open(CAfile,'w')
	oldfile = open(file, 'r')
	for line in oldfile:
		if line:
			words= line.split()
			if words[0]=="ATOM":
				if line[13:15]=='CA':
					newfile.write(line)
					
	newfile.close()
	oldfile.close()
