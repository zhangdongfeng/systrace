


import os, sys

import re

if __name__ == '__main__':
	f=open(sys.argv[1])
	
	lines=f.readlines()
	f.close()
	start_time=0.0
	
	#PackageManager-1630  ( 1607) [000] d..2 1679.0: block_rq_insert: 93,32 WS 0 () 506928 + 24 [PackageManager]\n\
	#nand-dev-rw-13351 (13351) [000] d..2 1710.789: block_rq_issue: 93,32 W 0 () 849664 + 248 [nand-dev-rw]\n\
	#nand-dev-rw-13351 (13351) [000] d..2 1710.648: block_rq_complete: 93,32 WS () 1071200 + 0 [0]\n\
	insert=re.compile(r'(\d+\.\d+): block_rq_issue: (\d+,\d+) (\S+) \S+ \S+ (\d+) \+ (\d+)\s+\[(\S+)\]')
	#issue=re.compile(r'(\d+\.\d+): block_rq_issue: (\d+,\d+) (\S+) .... (\d+) \+ (\d+)')
	#complete=re.compile(r'(\d+\.\d+): block_rq_complete: (\d+,\d+) (\S+) .... (\d+) \+ (\d+)')
	complete_str=r'(\d+\.\d+): block_rq_complete: '
	
				   #|(\S+)\s+\(.....\)\s+\[\d+\]\s+\S+\s+(\d+\.\d+): block_rq_issue: (\d+,\d+) (\S+) \d \(\) (\d+) + (\d+)|(\S+)\s+\(.....\)\s+\[\d+\]\s+\S+\s+(\d+\.\d+): block_rq_complete: (\d+,\d+) (\S+) \d \(\) (\d+) + (\d+)')
	alllines = ''.join(lines)	   
	#start = os.path.getsize('script.js')
	#print start
	#alllines = alllines[start:]
	all_trace =insert.findall(alllines)
	all=[]
	pairs=[]	
	for new in all_trace:		
		all.append(new)
		(time, dev, rw, sector, len, name) = new
		if rw == 'FWFS' or rw == 'FWS':
			continue
		mi = re.search(time, alllines)		
		alllines = alllines[mi.end():]
		cs= complete_str + dev + ' ' + rw + r' \S+ '   + sector  + r' \+ ' + r'(\d+)' 
		mc = re.search(cs, alllines)
		if mc:
			(end_time, end_len) = (mc.group(1), mc.group(2))
			pairs.append((str(new) + mc.group(),float(end_time) - float(time)))
			#print  float(end_time) - float(time), new
			if len != end_len:
				print 'len not match', new, mc.group()
			#print mc.group(1), mc.group(2)
		else:
			print 'not found complete', new
		
	pairs.sort(key = lambda x:x[1], reverse=True)
	max=pairs[0]
	
	sum = 0.0 
	for i in range(10):
		sum += float(pairs[i][1])
	
	
	#print 'max_duratin %s\t%s\t%s' % (max[0], max[1], round(sum/10,3))
	for p in pairs:
		sum += float(p[1])
		
	print 'top ten average: %s' % sum
		
	for l in all:
		print l
			
	
		
	
	
	
	
		
