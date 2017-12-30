import os, sys

import re

# zygote|system_server|com.android.systemui|com.android.launcher
if __name__ == '__main__':
	
	#system    1624  1268  759604 43668 ffffffff 4011c5a4 S system_server
	

	f=open(sys.argv[1])
	lines = f.readlines()
	f.close()
	for line in lines:
		m = re.search(r'\S+\s+(\d+)\s+\d+\s+\d+\s+\d+\s+\S+\s+\S+\sS\s+(' + sys.argv[2]+ r')', line)
		if m:		
			print m.group(1),

	