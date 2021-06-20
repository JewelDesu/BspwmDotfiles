#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
PS1='[\u@\h \W]\$ '
neofetch
(cat ~/.cache/wal/sequences &)
cat ~/.cache/wal/sequences 
source ~/.cache/wal/colors-tty.sh

export VITASDK=/usr/local/vitasdk
export PATH=”$HOME/.emacs.d/bin:$PATH”
export PATH=$VITASDK/bin:$PATH # add vitasdk tool to $PATH
