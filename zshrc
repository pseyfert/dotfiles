### APPEARANCE

## PROMPT
#
# * If I open a shell in a shell in a shell, I want to see how deep I'm in.
#
# * the prompt should indicate if the previous command failed (status code)
#
# * the prompt should show the current directory in a copy&pastable manner
#   (with double click in most terminals)
#   -> white space after the end of the path
#
# currently I have it set up to:
# pseyfert@robusta ~/Downloads > ls
# <username>@<hostname> <cwd> > <commandline>
#
# the greater sign grows with $SHLVL after some offset (the topmost shell in
# the callstack defines an environment variable)

# if TOPSHLVL is not set, set it to SHLVL
if (( ! ${+TOPSHLVL} )) ; then
  export TOPSHLVL=${SHLVL}
fi

PROMPT="%(?..%? )%(!.ROOT.%n)@%m:%~ "
for (( indent = ${TOPSHLVL} ; indent <= ${SHLVL} ; ++indent )); do PROMPT="${PROMPT}>"; done
PROMPT="${PROMPT} "

# display time at the right end of the command line
RPROMPT="%*"

## TERMINAL (attract attention visually when needed)
#
# Have a bell-character put out, everytime a command finishes. This will set the urgent-hint,
# if the terminal is configured accordingly
# thanks to @stapelberg
bellchar=$'\a'
zle-line-init () { echo -n "$bellchar" }
zle -N zle-line-init

## AUDIBLE TERMINAL
# http://stackoverflow.com/questions/171563/whats-in-your-zshrc
setopt NO_BEEP

### INPUT

## ^S
#
# disable freezing the terminal with ^S
#
# this can be an annoyance for some, though freezing the
# printount w/o interrupting the program is more important to me
# at the moment.
#
# stty stop undef

## VI MODE
#
# enable zle vi mode
bindkey -v

## HISTORY SEARCH
#
# use emacs backward search (^R is way too common)
bindkey '^R' history-incremental-pattern-search-backward
# search based on what's already entered
# https://unix.stackexchange.com/questions/97843/
# (just on a key near it)
bindkey '^T' history-beginning-search-backward
# in vi cmd mode shift+k should open the man page of the current command

## MAN PAGE FOR CURRENT COMMAND
#
bindkey -M vicmd K run-help

## ALIAS REPLACEMENT
#
# expand aliases with CTRL+SPACE
# http://blog.patshead.com/2012/11/automatically-expaning-zsh-global-aliases---simplified.html
globalias() {
   if [[ $LBUFFER =~ '[A-Za-z0-9]+$' ]]; then
     zle _expand_alias
   fi
   zle self-insert
}

zle -N globalias

bindkey " " magic-space
bindkey "^ " globalias
bindkey -M isearch " " magic-space

## SHIFT+TAB (reverse tabbing)
#
# http://stackoverflow.com/questions/815686/

bindkey '^[[Z' reverse-menu-complete

export CLICOLOR_FORCE=1
export CMAKE_GENERATOR="Ninja"
export CMAKE_EXPORT_COMPILE_COMMANDS=ON

# when completing filenames, always also suggest directories, do not suggest "just any file"
zstyle ':completion:*' file-patterns '%p:globbed-files *(-/):directories'

fpath=(~/.local/share/zsh/completions $fpath)
autoload -Uz compinit
compinit

# command specific completion settings
source $HOME/.zsh/zshcomps

expand-or-complete-with-dots() {
    echo -n -e "\e[37m...\e[0m\033[3D"
    zle expand-or-complete
    zle redisplay
}
zle -N expand-or-complete-with-dots
bindkey '\t' expand-or-complete-with-dots

# print a huge number of blank lines when clearing terminal
# (i.e. insert a visible separation in what you see when scrolling back)
flush() {
  timeout 0.03s yes
  zle clear-screen
}

zle -N flush

bindkey "^L" flush

push-line-and-insert() {
  zle push-line
  zle vi-insert
}

zle -N push-line-and-insert
bindkey -a "^Y" push-line-and-insert
bindkey -v "^Y" push-line

[[ -f $HOME/.zsh/zshfunctions ]] && source $HOME/.zsh/zshfunctions
[[ -f $HOME/.zsh/zshaliases ]] && source $HOME/.zsh/zshaliases
[[ -f $HOME/.zsh/zsh.$HOST ]] && source $HOME/.zsh/zsh.$HOST

export MANPATH=$HOME/.local/share/man
