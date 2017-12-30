


import os, sys

import re


def paris():
	for new in all_trace:
		print 'find:', new
		s = new[0]
		e = new[4]
		if s: # tracing_mark_write B                                     
			item = (type, pid, time, dev, ino)=('enter',new[0], new[1], new[2], new[3])		
		elif e:            
			item = (type, pid, time, dev, ino)=('exit', new[4], new[5], new[6], new[7])
		if not map.has_key(pid):
			map[pid] = []
		map[pid].append(item)
		
	pairs=[]
	for k, v in map.iteritems():
		enter=None
		exit=None
		for (type, pid, time, dev, ino) in v:
			if type=='enter':
				if enter:
					print 'found unmatched enter:', enter
				enter = (enter_pid, enter_time, enter_dev, enter_ino)= (pid, time, dev, ino)				
				exit = None
			else:
				exit = (exit_pid, exit_time, exit_dev, exit_ino)= (pid, time, dev, ino)
				if not enter:
					print 'found unmatched exit:', exit
				else:
					if enter_pid == exit_pid and  enter_dev == exit_dev and enter_ino == exit_ino:
						r = (str(enter)+str(exit), round(float(exit[1])-float(enter[1]),3))
						pairs.append(r)
						exit=None
						enter=None

	pairs.sort(key = lambda x:x[1], reverse=True)
	max=pairs[0]
	#print 'max_duratin %s\t%s' % (max[0][2:12], max[1])
	sum = 0.0 
	for i in range(10):
		sum += float(pairs[i][1])
	#print 'top ten average: %s' % round(sum/10,3)
	print 'max_duratin %s\t%s\t%s' % (max[0][2:13], max[1], round(sum/10,3))
	for p in pairs:
		print 'duration %s \t  src: %s ' % (p[1],  p[0])
	


if __name__ == '__main__':
	f=open(sys.argv[1])
	
	lines=f.readlines()
	f.close()
	start_time=0.0
	# Binder_3-1790  ( 1676) [001] ...1   34951.344: block_getrq: 93,32 R 291592 + 80 [Binder_3]\n\
	#PackageManager-1630  ( 1607) [000] d..2 1679.0: block_rq_insert: 93,32 WS 0 () 506928 + 24 [PackageManager]\n\
	#nand-dev-rw-13351 (13351) [000] d..2 1710.789: block_rq_issue: 93,32 W 0 () 849664 + 248 [nand-dev-rw]\n\
	#nand-dev-rw-13351 (13351) [000] d..2 1710.648: block_rq_complete: 93,32 WS () 1071200 + 0 [0]\n\
	insert=re.compile(r'(\d+\.\d+): block_getrq: (\d+,\d+) (\S+) (\d+) \+ (\d+)\s+\[(\S+)\]')
	#insert=re.compile(r'(\d+\.\d+): block_rq_insert: (\d+,\d+) (\S+) \S+ \S+ (\d+) \+ (\d+)\s+\[(\S+)\]')
	#issue=re.compile(r'(\d+\.\d+): block_getrq: (\d+,\d+) (\S+) .... (\d+) \+ (\d+)')
	#complete=re.compile(r'(\d+\.\d+): block_rq_complete: (\d+,\d+) (\S+) .... (\d+) \+ (\d+)')
	complete_str=r'(\d+\.\d+): block_rq_complete: '
	
				   #|(\S+)\s+\(.....\)\s+\[\d+\]\s+\S+\s+(\d+\.\d+): block_rq_issue: (\d+,\d+) (\S+) \d \(\) (\d+) + (\d+)|(\S+)\s+\(.....\)\s+\[\d+\]\s+\S+\s+(\d+\.\d+): block_rq_complete: (\d+,\d+) (\S+) \d \(\) (\d+) + (\d+)')
	alllines = ''.join(lines)	   
	start = os.path.getsize('script.js')
	print start
	alllines = alllines[start:]
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
			pairs.append((str(new) + mc.group(), round(float(end_time) - float(time),3)))
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
	#print 'top ten average: %s' % round(sum/10,3)
	print 'max_duratin %s\t%s\t%s' % (max[0], max[1], round(sum/10,3))
	for p in pairs:
		print 'duration %s \t  src: %s ' % (p[1],  p[0])
	for l in all:
		print l
			
	
		
	
	
	
	
		
