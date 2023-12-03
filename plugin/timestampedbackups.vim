" Copyright (c) 2022 Ted Lavarias
" MIT License, see LICENSE for more details.
" AUTHOR: Ted Lavarias <constructingcode@gmail.com>
"	  https://github.com/tedlava
"	  https://github.com/constructingcode
"	  https://www.constructingcode.com
" DESCRIPTION:
" For Vim or Neovim, automatically save timestamped backups in a hidden
" directory after every write.  See README.md for more details.


function! TimestampedBackup()
	let g:timestampedbackup_enabled = get(g:, "timestampedbackup_enabled", 1)
	let g:timestampedbackup_max_filesize = get(g:, "timestampedbackup_max_filesize", 10485760)
	if g:timestampedbackup_enabled && wordcount()['bytes'] <= g:timestampedbackup_max_filesize
		let g:timestampedbackup_dir = get(g:, "timestampedbackup_dir", ".history")
		let g:timestampedbackup_total = get(g:, "timestampedbackup_total", 5)
		let g:timestampedbackup_sep = get(g:, "timestampedbackup_sep", "__")
		lcd %:p:h
		let fname_split = split(expand('%'), '\.')
		let fname = g:timestampedbackup_dir . '/' . expand('%') . g:timestampedbackup_sep . strftime('%Y%m%dT%H%M%S')
		if len(fname_split) > 1
			" Add file extension so syntax highlighting still works
			let fname = fname . '.' . fname_split[-1]
		endif
		call mkdir(g:timestampedbackup_dir,  'p')
		if has("win32") || has ("win64")
			silent execute '!attrib +h "' . g:timestampedbackup_dir . '"'
		endif
		silent execute 'keepalt write' fname
		let all_backups = filter(split(globpath(g:timestampedbackup_dir, expand('%') . g:timestampedbackup_sep . '*'), '\n'), '!isdirectory(v:val)')
		call sort(all_backups)
		if len(all_backups) > g:timestampedbackup_total
			" Delete older backups (vimscript end-slice index is inclusive)
			for old_fname in all_backups[ : -g:timestampedbackup_total - 1]
				call delete(old_fname)
			endfor
		endif
	endif
endfunction


if !exists("timestampedbackup_autocommand_loaded")
	let timestampedbackup_autocommand_loaded = 1
	autocmd BufWritePost * call TimestampedBackup()
endif
