# Timestamped Backups
For Vim or Neovim, automatically save timestamped backups in a hidden directory
after every write.


### Description
I don't like how text editors only save a single backup of a file as
"examplefile.vim~" so I created my own Vim/Neovim plugin to save multiple
backups in a hidden backup directory.  There are a few user-configurable
options that can be specified in your .vimrc or init.vim.  The defaults will
create a .backups/ directory in the same location as the file being written to
disk.  The defaults will save 5 backups (a copy of the current file and 4
historical backups) in the following format with the ISO 8601 basic format
timestamp appended (extended format may have some characters that may conflict
with some operating systems):

        examplefile.vim__20220619T152340.vim
        examplefile.vim__20220624T131757.vim
        examplefile.vim__20220624T133643.vim
        examplefile.vim__20220626T125754.vim
        examplefile.vim__20220626T133609.vim

Shell scripts are saved without an extension:

        mybashscript__20220619T152340
        mybashscript__20220624T131757
        mybashscript__20220624T133643
        mybashscript__20220626T125754
        mybashscript__20220626T133609

This naming scheme always preserves the original file name before the separator
(which is also configurable) and also preserves syntax highlighting when
opening up a backup file for editing.  Backups are only performed on files less
than or equal 10 MiB (which is about 200,000 lines of code, if your average
line length is about 55 characters).  The max backup file size is also
configurable.  This is to prevent backups of very large files that are
typically not source code, such as server logs or CSV files of giant datasets
that are GiB in size!


### Installation

##### vim-plug
Add the following to the vim-plug section of your .vimrc or init.vim:

        Plug 'constructingcode/vim-timestampedbackups'

##### Manual installation (Linux/Unices)

1. In a terminal window, create the following directory structure (if not
   already existing), then navigate to it:

    For Vim:
            ~/.vim/pack/*/start
    (* may be any name, e.g. ~/.vim/pack/foobar/start)

    For Neovim:
            ~/.local/share/nvim/site/pack/*/start
    (* may be any name, e.g. ~/.local/share/nvim/site/pack/foobar/start)

2. Clone the plugin in the above directory:

            $ git clone https://github.com/constructingcode/vim-timestampedbackups

3. Restart Vim/Neovim


### Options
All of the following options can be omitted from your vim config file if you
wish to run the plugin with the defaults:

- *g:timestampedbackup_enabled* -> Enable/disable plugin without
uninstalling.  Default is 1.  Setting to 0 will disable.

- *g:timestampedbackup_max_filesize* -> Max filesize in bytes.  Default is
10485760 (which is 10 MiB, ~200,000 lines of code).  Files larger
than this will not be backed up.

- *g:timestampedbackup_dir* -> Subdirectory that will be created to hold backup
files.  Default is ".backups"

- *g:timestampedbackup_total* -> Total backups to be saved for each file.
Default is 5 (current + 4 historical backups)

- *g:timestampedbackup_sep* -> Separator between the file name and the
timestamp.  Default is "__"

