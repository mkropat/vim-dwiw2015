# dwiw2015.vim — Do What I Want In 2015

*Sensible Defaults For A Modern Text Editor*

Building on top of [Tim Pope's
sensible.vim](https://github.com/tpope/vim-sensible/), **vim-dwiw is a minimal
Vim distribution** that sets up Vim with the behavior and features that you
would expect from a modern text editor.

Benefits at a glance:

- One-step install for Windows, Linux, and OS X
- No cruft in your `.vimrc`, since default settings are cleanly segregated into a plug-in
- Modern plug-in management with [Vundle](https://github.com/gmarik/Vundle.vim)
- Includes a __small__ [curated set of plug-ins](#modern-features) to provide modern text editor functionality
- Optimized for both Terminal and GUI Vim

Vim-dwiw is well suited for new Vim users.  It smoothes out the roughest of
edges of Vim (the stuff that no longer makes sense today), but in a way that
doesn't try to change or go far beyond the core Vim behavior.

And for experienced users, vim-dwiw cuts out the boilerplate code that you and
everyone else puts in their `.vimrc`, making it that much easier to get Vim
configured on a new machine.

## Installation

### Linux, OS X, and Friends

One command will get you going:

    curl -sS https://raw.githubusercontent.com/mkropat/vim-dwiw2015/master/bootstrap.sh | sh

It should be safe to run — even on an existing Vim set up. See the [bootstrap
script source](bootstrap.sh) for details.

### Windows

Assuming you have [Chocolatey](http://chocolatey.org/) installed, open a
command prompt and run:

    cinst vim-dwiw2015

It should be safe to run — even on an existing Vim set up. See the [bootstrap
script source](bootstrap.ps1) for details.

Alternatively, you can download the [bootstrap script](bootstrap.ps1) and run
it manually from the PowerShell console:

    & .\bootstrap.ps1

### Plug-in Only

If you already have Vundle set up and the plug-ins you want installed, you can
include just the **dwiw2015.vim** plug-in by adding the following lines to your
`.vimrc`:

    Plugin 'tpope/vim-sensible'
    Plugin 'mkropat/vim-dwiw2015'

(dwiw2015.vim pairs best with vim-sensible)

And then run the following from Vim:

    :PluginInstall

## Updating

If you've already installed vim-dwiw, you can update the **dwiw2015.vim**
plug-in and all other installed plugins to the latest version by running the
following from Vim:

    :PluginUpdate

## Default Settings

The authoritative source for the provided default settings is the
(well-documented) [source file itself](plugin/dwiw2015.vim).

### New Key Shortcuts

Vim-dwiw adds in the most ubiquitous editor shortcuts, and makes some
old key mappings act a little more modern.

#### All Modes

Shortcut           | Description
-------------------|-------------------------------
<kbd>Ctrl-A</kbd>  | select all
<kbd>Ctrl-S</kbd>  | save
<kbd>Ctrl-Z</kbd>  | undo (GUI only)

#### Normal / Visual Mode

Shortcut               | Description
-----------------------|-------------------------------
<kbd>Ctrl-Q</kbd>      | enter Visual Block mode
<kbd>Ctrl-V</kbd>      | paste from clipboard (GUI only)
<kbd>Ctrl-/</kbd>      | toggles commenting of selected line(s) (Terminal only; not all terminals supported)
<kbd>Q</kbd>`{motion}` | format specified lines (like `gq`)
<kbd>gQ</kbd>          | enter Ex mode (since `Q` is re-mapped)
<kbd>j</kbd>           | move down one line on the screen
<kbd>gj</kbd>          | move down one line in the file
<kbd>k</kbd>           | move up one line on the screen
<kbd>gk</kbd>          | move up one line in the file

#### Normal Mode Only

Shortcut                  | Description
--------------------------|-------------------------------
<kbd>&amp;</kbd>          | repeat last `:s` substitue (preserves flags)
<kbd>Y</kbd>              | yank to end of line (to be consistent with <kbd>C</kbd> and <kbd>D</kbd>)
<kbd>Enter</kbd>          | insert blank line above current
<kbd>Ctrl-Tab</kbd>       | switch to next tab (GUI only)
<kbd>Ctrl-Shift-Tab</kbd> | switch to previous tab (GUI only)
<kbd>Ctrl-L</kbd>         | clear search term highlighting

#### Visual Mode Only

Shortcut           | Description
-------------------|-------------------------------
<kbd>Ctrl-C</kbd>  | copy selection to clipboard (GUI only)
<kbd>Ctrl-X</kbd>  | cut selection to clipboard (GUI only)

#### Insert Mode

Shortcut             | Description
---------------------|-------------------------------
<kbd>Tab</kbd>       | indent at beginning of line, otherwise autocomplete
<kbd>Shift-Tab</kbd> | select previous autocompletion
<kbd>Ctrl-Q</kbd>    | insert literal character
<kbd>Ctrl-V</kbd>    | paste from clipboard (GUI only)

### Overriding the Defaults

Add your custom settings to `.vimrc` **after** the hook line `source …
dwiw-loader.vim`. The `dwiw-loader.vim` script pre-loads both the
`dwiw2015.vim` and `sensible.vim` plugins, allowing you to set custom overrides
in your `.vimrc`.

## Modern Features

Vim-dwiw ships with a number of plug-ins out-of-the-box:

- [ag.vim](https://github.com/rking/ag.vim) — like `grep`, but better
- [ctrlp.vim](https://github.com/kien/ctrlp.vim) — fuzzy file, buffer, mru, tag, etc finder
- [vim-airline](https://github.com/bling/vim-airline) — lean & mean status/tabline for Vim that's light as air
- [vim-commentary](https://github.com/tpope/vim-commentary) — comment and un-comment lines easily
- [vim-sensible](https://github.com/tpope/vim-sensible) — defaults everyone can agree on
- [vim-sleuth](https://github.com/tpope/vim-sleuth) — heuristically set buffer options
- [Vundle](https://github.com/gmarik/Vundle.vim) — the plug-in manager for Vim

### Plug-in Management

Install packages straight from Vim at any time with
[Vundle](https://github.com/gmarik/Vundle.vim).  For example, to install Tim
Pope's fantastic Git wrapper, available on Github at
[tpope/vim-fugitive](https://github.com/tpope/vim-fugitive), simply add the
following line to your `.vimrc`:

    Plugin 'tpope/vim-fugitive'

Then run `:PluginInstall`.

To update all installed plugins to the latest version, run `:PluginUpdate`.

### Fuzzy-Filename Open

![Screenshot](http://i.imgur.com/ElV0Tjr.png)

Vim's built-in file opener and swtiching (see `:help :e` and `:help :b`) works
fine, but for truly fast file-switching you need a fuzzy-file opener, like the
[ctrlp plug-in](http://kien.github.io/ctrlp.vim/).  Pressing <kbd>Ctrl-P</kbd>
in normal mode activates the the plug-in.  Once activated, start typing any
part of the filename you're interested (`partial/paths` work too) and press
<kbd>Enter</kbd> to open the file.

### Find In Files

![Screenshot](http://i.imgur.com/4N8XtLR.png)

Vim already provides an interface to the `grep` command with `:grep`, however
the `grep` command is less than ideal for searching most directories, because
it automatically searches inside lots of irrelevant filetypes (like compiled
files, version control internals, etc.).

A better alternative is [The Silver
Searcher](http://geoff.greer.fm/2011/12/27/the-silver-searcher-better-than-ack/)
a.k.a. `ag`.  Using the [ack.vim plug-in](https://github.com/mileszs/ack.vim)
(configured for `ag`), you can search straight from Vim with the command `:Ack
<search terms>`.

Note: before `ag.vim` can be used, the The Silver Searcher must be installed.
Fortunately, packages exist for all the major platforms (called perhaps
`silversearcher-ag` or `the_silver_searcher`) and it's installed automatically
for you on Windows by Chocolatey!

### Informative Statusline

![Screenshot](http://i.imgur.com/3NcgspK.png)

Vim-dwiw includes the [vim-airline
plug-in](https://github.com/bling/vim-airline), which packs a whole lot of
information into your status while looking great at the same time.

### Toggle Line Commenting With a Single Keypress

(Terminal Only) Press <kbd>Ctrl-/</kbd> to comment out the current line (or
un-comment it, if it's currently commented out).  Select multiple lines in
Visual mode and press <kbd>Ctrl-/</kbd> to comment them all out.

(All Versions) Or more powerfully, use Vim motions with <kbd>gc</kbd> to
comment out any sized block of code:

- <kbd>gcap</kbd> — comment out the current paragraph
- <kbd>gcG</kbd> — comment out the rest of the file
- etc.

### Auto-Detection of Indent Settings

We all have our preferred idea of how far to indent and when to use tabs vs
spaces, but when editing a file created by someone else, the important thing is
*to stay consistent with their indent settings*.  The [sleuth.vim
plug-in](https://github.com/tpope/vim-sleuth) inspects newly opened files and
sets the relevant settings (`shiftwidth` and `expandtab`) automatically.

## Troubleshooting

#### Slow Scrolling

If you experience slow scrolling in `:list` mode in a file with long lines, the
issue may be a result of [the font in use misisng certain
characters](https://code.google.com/p/vim/issues/detail?id=210).  As a
workaround, you can set the following in your `.vimrc` to display ascii
characters (which are present in any font):

    set listchars=tab:>\ ,trail:-,extends:>,precedes:<,nbsp:+

## Inspiration

I may be proficient at editing with Vim, but I'm a novice when it comes to Vim
customization.  Without reading other people's `.vimrc` files and plug-in
source code, I'd have gotten nowhere.  Particular shout-outs go to:

* Tim Pope's [vim-sensible](https://github.com/tpope/vim-sensible) and [vimrc](https://github.com/tpope/tpope/blob/master/.vimrc)
* Gary Bernhardt's [vimrc](https://github.com/garybernhardt/dotfiles/blob/master/.vimrc)
* Steve Losh's [Learn Vimscript the Hard Way](http://learnvimscriptthehardway.stevelosh.com/), [Vim blog post](http://stevelosh.com/blog/2010/09/coming-home-to-vim/) and [vimrc](https://bitbucket.org/sjl/dotfiles/src/tip/vim/vimrc)
* Bailey Ling's [vimrc](https://github.com/bling/dotvim/blob/master/vimrc)
* Steve Francia's [everything and the kitchen sink Vim distribution](http://vim.spf13.com/)

## License

Copyright © Michael Kropat.  Distributed under the same terms as Vim itself.
See `:help license`.
