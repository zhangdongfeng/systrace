


import os, sys

import re

def findByIno(disk,ino):
	inum = int(ino,16)
	if disk == '16':
		f=os.popen('adb shell busybox find /system -inum ' + str(inum))	
	elif disk == '32':
		f=os.popen('adb shell busybox find /data -inum ' + str(inum))
	else:
		print disk, ino
		return 
	ret=  f.readline()
	f.close()
	return ret.strip()
	
def print_ino(matches):
	inos = {}
	for new in matches:				
		(disk, ino, ofs) = new
		#print new		
		if (disk,ino) not in inos:
			inos[(disk,ino)]=[int(ofs)]
			#print 'found------------------------', disk, ino, inos[(disk,ino)]
		else:
			inos[(disk,ino)].append(int(ofs))
			#print 'add', disk, ino, ofs
	
	
	items = inos.items()
	items.sort(key = lambda x: len(x[1]), reverse=True)

	for ((disk,ino),ofs) in items:		
		print findByIno(disk,ino)
		print disk, ino,  len(ofs)
		#sortofs= sorted(ofs)
		#print sortofs
		ofs.sort()
		print ofs
		
		count=1
		cursor=0
		for pos in ofs:			
			if cursor + 4096 != pos:				
				#print '-', cursor,':', count,			
				#print pos, 
				cursor=pos
				count=1
			else:
				cursor += 4096
				count+=1				
				
		#print '-', pos,
	
	
if __name__ == '__main__':
	f=open(sys.argv[1])
	
	lines=f.readlines()
	f.close()

	#(-----) [003] d..2 8123.667: mm_filemap_delete_from_page_cache: dev 93:32 ino 38 page=c0ecb5c0 pfn=93742 ofs=9990144\n\
	#(-----) [003] ...2 8076.65: mm_filemap_add_to_page_cache: dev 93:32 ino 38 page=c0ca2ee0 pfn=23031 ofs=10309632\n\
	
	cache_del=re.compile(r'mm_filemap_delete_from_page_cache: dev 93:(\d+) ino (\d+) page=\w+ pfn=\d+ ofs=(\d+)');
	cache_add=re.compile(r'mm_filemap_add_to_page_cache: dev 93:(\d+) ino (\d+) page=\w+ pfn=\d+ ofs=(\d+)');
	
	alllines = ''.join(lines)	   	
	all_del =cache_del.findall(alllines)			
	all_add =cache_add.findall(alllines)
	

	print 'all add ino:'
	print_ino(all_add)
	
	
	print '\n\n\nall del ino:'			
	print_ino(all_del)
		
	