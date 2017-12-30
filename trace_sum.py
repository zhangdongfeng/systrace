import os, sys

import re

if __name__ == '__main__':
	#max_iowait dexopt	1179.794	359.0
	#max_duratin dexopt-1163	1176.892	181.278
	
	for file in  sys.argv[1:]:
		f=open(file)
		lines = f.readlines()
		f.close()
		for line in lines:
			m = re.search(r'max_iowait\s(.+)$|max_duratin\s(.+)$', line)
			if m:
				if m.group(1):
					print m.group(1),'\t',
				if m.group(2):
					print m.group(2)

	