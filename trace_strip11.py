import os, sys

import re

if __name__ == '__main__':
	f=open(sys.argv[1])
	
	lines = []
	fl=f.readlines()
	begin = None
	for line in fl:
		if not re.search('93,16|sched_switch|sched_wakeup|dev 93:16|launcher|mm_filemap_delete_from_page_cache|mm_filemap_add_to_page_cache', line):
			lines.append(line.rstrip())
	for line in lines:
		print line
	