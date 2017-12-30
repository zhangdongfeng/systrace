import os, sys

import re

if __name__ == '__main__':
	f=open(sys.argv[1])
	
	lines = []
	fl=f.readlines()
	begin = None
	for line in fl:
		if not re.search('global_dirty_state|mm_vmscan_lru_shrink_inactive|mm_page_free|mm_vmscan_lru_isolate|mm_filemap_delete_from_page_cache|mm_shrink_slab_start|mm_shrink_slab_end|mm_page_alloc|mm_filemap_add_to_page_cache|mm_page_alloc|mm_page_free_batched|writeback_|kfree|kmalloc|kmem_|sys_exit|sys_enter|kswapd0', line):
				lines.append(line.rstrip())
	for line in lines:
		print line
	