


import os, sys

import re

if __name__ == '__main__':
	f=open(sys.argv[1])
	
	lines=f.readlines()
	f.close()
	start_time=0.0
	pat=re.compile('\[\w+\] .+ (\d+\.\d+):')
	for l in lines:		
		s=pat.search(l)
		if s:
			time=float(s.group(1))
			if(start_time == 0.0):
				start_time = time				
				#print 'start time: %s \n' %  start_time
			time=round((time-start_time)*1000, 3)
			l=re.sub('\d+\.\d+',str(time),l)
			print l.rstrip()			
		else:			
			print l
		

	