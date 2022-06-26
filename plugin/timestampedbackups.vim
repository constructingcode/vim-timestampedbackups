" AUTHOR: Ted Lavarias <constructingcode@gmail.com>
"	  https://github.com/tedlava
"	  https://github.com/constructingcode
" VERSION: 1.0
" DESCRIPTION:
" Creates timestamped backup files in a hidden directory.  The following
" variables may be configured in the user's init.vim or .vimrc file:
"
"	  g:timestampedbackup_enabled -> Enable/disable plugin without
"	  uninstalling.  Default is 1.  Setting to 0 will disable.
"
"	  g:timestampedbackup_max_filesize -> Max filesize in bytes.  Default is
"	  10485760 (which is 10 Mebibytes, ~200,000 lines of code).  Files larger
"	  than this will not be backed up.
"
"	  g:timestampedbackup_dir -> Subdirectory that will be created to hold backup
" files.  Default is ".backups"
"
"	  g:timestampedbackup_total -> Total backups to be saved for each file.
" Default is 5 (current + 4 historical backups)
"
"	  g:timestampedbackup_sep -> Separator between the file name and the
" timestamp.  Default is "__"
"



function! TimestampedBackup()
	let g:timestampedbackup_enabled = get(g:, "timestampedbackup_enabled", 1)
	let g:timestampedbackup_max_filesize = get(g:, "timestampedbackup_max_filesize", 10485760)
	if g:timestampedbackup_enabled && wordcount()['bytes'] <= g:timestampedbackup_max_filesize
		let g:timestampedbackup_dir = get(g:, "timestampedbackup_dir", ".backups")
		let g:timestampedbackup_total = get(g:, "timestampedbackup_total", 5)
		let g:timestampedbackup_sep = get(g:, "timestampedbackup_sep", "__")
		let fname_split = split(expand('%'), '\.')
		let fname = g:timestampedbackup_dir . '/' . expand('%') . g:timestampedbackup_sep . strftime('%Y%m%dT%H%M%S')
		if len(fname_split) > 1
			" Add file extension so syntax highlighting still works
			let fname = fname . '.' . fname_split[-1]
		endif
		call mkdir(g:timestampedbackup_dir,  'p')
		if has("win32") || has ("win64")
			execute '!attrib +h "' . g:timestampedbackup_dir . '"'
		endif
		silent execute 'write' fname
		let all_backups = filter(split(globpath(g:timestampedbackup_dir, expand('%') . g:timestampedbackup_sep . '*'), '\n'), '!isdirectory(v:val)')
		call sort(all_backups)
		" Creates a total of 5 backups: current + 4 historical backups
		if len(all_backups) > g:timestampedbackup_total
			for old_fname in all_backups[:-g:timestampedbackup_total - 1]
				call delete(old_fname)
			endfor
		endif
	endif
endfunction

autocmd BufWritePost * call TimestampedBackup()
