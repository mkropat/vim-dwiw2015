# dwiw2015.vim — Do What I Want In 2015

*Sensible Defaults For a Modern Text Editor*

Building on top of [Tim Pope's
sensible.vim](https://github.com/tpope/vim-sensible/), **dwiw2015 is a minimal
Vim distribution** that sets up Vim with the behavior and features that you
expect from a modern text editor.

Benefits at a glance:

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

It should be safe to run — even on an existing Vim set up. Outside of the
Vundle plug-ins installed into `~/.vim/bundle/`, only three files are affected:

* `~/.vimrc` — a one line hook is added to call `dwiw-loader.vim`
* `~/.vim/dwiw-loader.vim` (do not modify) — script to load Vundle and then call `bundles.vim`
* `~/.vim/bundles.vim` (safe to add local modifications) — a list of Vundle plug-ins

Re-running the `bootstrap.sh` script is safe — it simply resumes the
installation and checks for updates on any plug-ins already installed.

### Windows

Windows users can use the [Plug-in Only](#plug-in-only) install for now. *I'm
considering creating a bootstrap option for Windows. Perhaps as a [Chocolatey
package](https://chocolatey.org/)?*

### Plug-in Only

If you already have Vundle set up and the plug-ins you want installed, you can
include just the **dwiw2015.vim** plug-in by adding the following line to your
`.vimrc`:

    Bundle 'mkropat/vim-dwiw2015'

And then run:

    vim +BundleInstall +qall

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

Shortcut           | Description
-------------------|-------------------------------
<kbd>Enter</kbd>   | insert blank line above current
<kbd>Ctrl-L</kbd>  | clear search term highlighting

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

### Overriding the Defaults

Care has been taken to include only default settings that are likely to appeal
to a wide number of users. It's inevitable toes will be stepped on though.

Because **dwiw2015.vim** loads as a plug-in, that means — by default — it
loads *after* your `.vimrc`, which makes anything it sets override the previous
setting.  The way to get around this is to add a line to your `.vimrc` that
forces **dwiw2015.vim** to load before you set your settings:

    runtime! plugin/dwiw2015.vim
    " <your settings here>

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

A better alternative is [ack](http://beyondgrep.com/).  Using the [ack.vim
plug-in](http://www.vim.org/scripts/script.php?script_id=2572), you can search
with `ack` straight from Vim by entering `:Ack <search terms>`.

Before the `ack.vim` can be used, the `ack` program must be installed.
Fortunately, packages exist for all the major platforms (called either `ack` or
`ack-grep`).

In the near future, this will probably be replaced with
[ag.vim](https://github.com/rking/ag.vim), now that [The Silver
Searcher](https://github.com/ggreer/the_silver_searcher) is becoming widely
available.

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
