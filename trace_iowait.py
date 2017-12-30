


import os, sys

import re

if __name__ == '__main__':
	f=open(sys.argv[1])
	
	lines=f.readlines()
	f.close()
	start_time=0.0
	# nand-dev-rw-63    (   63) [002] d..5  13603.927: sched_stat_iowait: comm=PackageManager pid=1671 delay=121750 [ns]\n\
	pat=re.compile(r'(\d+\.\d+): sched_stat_iowait: comm=(\S+) pid=(\d+) delay=(\d+)')
	alllines = ''.join(lines)	   
	start = os.path.getsize('script.js')
	print start
	alllines = alllines[start:]
	all_trace =pat.findall(alllines)
	
	
	
	all_trace.sort(key = lambda x:int(x[3]), reverse=True)
	
	max=all_trace[0]
	#print 'max_iowait %s\t%s' % (max[1], round(float(max[3])/1000000,3))
	sum = 0 
	for i in range(10):
		sum += int(all_trace[i][3])/1000000
	#print 'top ten average: %s' % round(sum/10,3)
	print 'max_iowait %s\t%s\t%s' % (max[1], round(float(max[3])/1000000,3), round(sum/10,3))
	total_iowait=0.0
	for l in all_trace:
		total_iowait += int(l[3])/1000000
	print 'total iowait %s' % round(total_iowait, 3)
 	for l in all_trace:		
		print l,  round(int(l[3])/1000000, 3)
		

	