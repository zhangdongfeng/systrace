


import os, sys

import re


def paris():
	pairs=[]
	enter=None
	exit=None
	for new in all_trace:
		print 'find:', new
		s = new[0]
		e = new[4]
		if s: # tracing_mark_write B                                     
			enter= new
			exit=None
		elif e:            
			if not enter:
				print 'error', new        
				continue
			exit = new
			if enter[0] != exit[4] or enter[2] != exit[6] or enter[3] != exit[7]:
				print 'not match'
				continue
			r = (str(enter)+str(exit), round(float(exit[5])-float(enter[1]),3)) 
			pairs.append(r)
	pairs.sort(key = lambda x:x[1], reverse=True)
	max=pairs[0]
	#print 'max_duratin %s\t%s' % (max[0][2:12], max[1])
	sum = 0.0 
	for i in range(10):
		sum += float(pairs[i][1])
	#print 'top ten average: %s' % round(sum/10,3)
	print 'max_duratin %s\t%s\t%s' % (max[0][2:12], max[1], round(sum/10,3))
	for p in pairs:
		print 'duration %s \t  src: %s ' % (p[1],  p[0])
	


if __name__ == '__main__':
	f=open(sys.argv[1])
	
	lines=f.readlines()
	f.close()
	start_time=0.0
	# <...>-1654  (-----) [002] ...1  21872.649: ext4_sync_file_enter: dev 93,32 ino 786 parent 76 datasync 0\n\
	# <...>-1654  (-----) [002] ...1  21889.574: ext4_sync_file_exit: dev 93,32 ino 786 ret 0\n\
	
	pat=re.compile(r'(\S+)\s+\(.....\)\s+\[\d+\]\s+\S+\s+(\d+\.\d+): ext4_sync_file_enter: dev (\d+,\d+) ino (\d+) parent \d+ datasync|(\S+)\s+\(.....\)\s+\[\d+\]\s+\S+\s+(\d+\.\d+): ext4_sync_file_exit: dev (\d+,\d+) ino (\d+) ret')
	alllines = ''.join(lines)	   
	start = os.path.getsize('script.js')
	print start
	alllines = alllines[start:]
	all_trace =pat.findall(alllines)
	
	map= {}
	all=[]
	for new in all_trace:
		all.append(new)
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
	for l in all:
		print l
	
		
	
	
	
	
		
