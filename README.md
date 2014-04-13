# dwiw2015.vim — Do What I Want In 2015

*Sensible Defaults For a Modern Text Editor*

Building on top of [Tim Pope's
sensible.vim](https://github.com/tpope/vim-sensible/), **dwiw2015 is a minimal
Vim distribution** that sets up Vim with the behavior and features that you
expect from a modern text editor.

Benefits at a glance:

* One-step install for Windows, Linux, and OS X
* No cruft in your `.vimrc`, since default settings are cleanly segregated into a plug-in
* Modern plug-in management with [Vundle](https://github.com/gmarik/Vundle.vim)
* Includes a **small**, [curated set of plug-ins](#modern-features) to provide modern text editor functionality
* Optimized for both Terminal and GUI Vim

If you've been using Vim exclusively for 20 years and you're happy to bring
your 1,000 line `.vimrc` to every machine you touch, this distribution might
not be for you. On the other hand, if you want to quickly get up and running
with a modern Vim configuration, or if you want to cut out all
of the boilerplate code from your `.vimrc`, you might be in the right place.

## Installation

### Linux, OS X, and Friends

One command will get you going:

    curl -sS https://raw.github.com/mkropat/vim-dwiw2015/master/bootstrap.sh | sh

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
include just the **dwiw2015.vim** plug-in by adding the following line to your
`.vimrc`:

    Bundle 'mkropat/vim-dwiw2015'

And then run the following inside Vim:

    :BundleInstall

## Default Settings

The authoritative source for the provided default settings is the
(well-documented) [source file itself](plugin/dwiw2015.vim).

### New Key Shortcuts

**dwiw2015.vim** adds in the most ubiquitous editor shortcuts, and makes some
old key mappings act a little more modern.

#### All Modes

Shortcut           | Description
-------------------|-------------------------------
<kbd>Ctrl-A</kbd>  | select all
<kbd>Ctrl-S</kbd>  | save
<kbd>Ctrl-Z</kbd>  | undo (GUI only)

#### Normal / Visual Mode

Shortcut           | Description
-------------------|-------------------------------
<kbd>Ctrl-Q</kbd>  | enter Visual Block mode
<kbd>Ctrl-V</kbd>  | paste from clipboard (GUI only)
<kbd>Ctrl-/</kbd>  | toggles commenting of selected line(s) (Terminal only; not all terminals supported)
<kbd>j</kbd>       | move down one line on the screen
<kbd>gj</kbd>      | move down one line in the file
<kbd>k</kbd>       | move up one line on the screen
<kbd>gk</kbd>      | move up one line in the file

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

### Plug-in Management

Install packages straight from Vim at any time with
[Vundle](https://github.com/gmarik/Vundle.vim).  For example, to install Tim
Pope's fantastic Git wrapper, available on Github at
[tpope/vim-fugitive](https://github.com/tpope/vim-fugitive), simply add `Bundle
'tpope/vim-fugitive'` to your `.vimrc` and run `:BundleInstall`.

To check for updates on all installed plugins, run `:BundleUpdate`.

### Fuzzy-Filename Open

With the [ctrlp plug-in](http://kien.github.io/ctrlp.vim/), pressing
<kbd>Ctrl-P</kbd> opens a fuzzy-filename finder window, for locating files
relative to the current file or working directory.  Start typing in any part of
the file you're looking for (a directory in the path, the filename, the file
extension), and a list of matching files will be presented to you to select
from.

### Find In Files

Vim already offers the `:grep` command for this, but `grep` is less than ideal
for searching text files in large directory structures because `grep` returns
results from irrelevant files (compiled files, version control internals etc.).

A better alternative is [The Silver
Searcher](http://geoff.greer.fm/2011/12/27/the-silver-searcher-better-than-ack/)
a.k.a. `ag`.  Using the [ag.vim plug-in](https://github.com/rking/ag.vim), you
can search straight from Vim with the command `:Ag <search terms>`.

Note: before `ag.vim` can be used, the The Silver Searcher must be installed.
Fortunately, packages exist for all the major platforms (called perhaps
`silversearcher-ag` or `the_silver_searcher`).

### Informative Statusline

**dwiw2015.vim** bundles the [vim-airline
plug-in](https://github.com/bling/vim-airline), which describes itself as:

> lean & mean status/tabline for vim that's light as air

Check out the [plug-in screenshots
page](https://github.com/bling/vim-airline/wiki/Screenshots) to get a feel for
what it offers.

### Toggle Line Commenting With a Single Keypress

Commenting out a block of code shouldn't be any harder than selecting it and
pressing a key.  Fortunately the [NERD Commenter
plug-in](https://github.com/scrooloose/nerdcommenter) offers just that.

To toggle commenting, use the shortcut <kbd>Ctrl-/</kbd> on the terminal (note:
this doesn't work in all terminals).  Or, failing that, use the plug-in's
default shortcut: <kbd>Leader</kbd>+<kbd>c</kbd>+<kbd>Space</kbd>.  (The default
<kbd>Leader</kbd> key is <kbd>\\</kbd>.)

### Indent Settings Auto-Detection

We all have our preferred idea of how far to indent and when to use tabs vs spaces, but when editing a file created by someone else, the important
thing is *to stay consistent with their indent settings*.  The [sleuth.vim
plug-in](https://github.com/tpope/vim-sleuth) inspects newly opened files and
sets the relevant settings (`shiftwidth` and `expandtab`) automatically.

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
