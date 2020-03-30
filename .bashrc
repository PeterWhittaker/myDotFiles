# pww .bashrc - everything starts here, though not everything finishes here
# pww .bash_profile just calls this, this does a few "always" things, then
# this checks for interactivity, exiting if not interactive, continuing on
# to do interactive things otherwise

# first, good practices that always make sense
umask 022

# next, some helper functions related to platform, because some "always"
# things are platform-dependent

function isWSL {
    false
}
function isCygwin {
    false
}
function isLinux {
    false
}
function isMacOS {
    false
}

case $OSTYPE in
    darwin*)
        function isMacOS {
            true
        }
        ;;
    cygwin*)
        function isCygwin {
            true
        }
        ;;
    linux-gnu*)
        function isLinux {
            true
        }
        case $(uname -r) in
            *Microsoft)
                function isWSL {
                    true
                }
                ;;
            *)
                :
                ;;
        esac
        ;;
    *)
        echo; echo "What OS is this?"; echo
        ;;
esac

if [ -z "${PATH}" ]; then
    # there should be a default path, but in some weird cases, perhaps not
    # set a reasonable default
    PATH=/usr/bin:/bin:/usr/sbin:/sbin
    export PATH
fi

# now things get interesting....
# I have to check when I need this
# isMacOS && PATH=/usr/local/bin:"${PATH}" # take advantage of brew recipes

# always prepend my bin, if it exists
# set PATH to includes my bin if it exists
if [ -d ~/bin ] ; then
    PATH=~/bin:"${PATH}"
fi

# If not running interactively, stop here, we've done enough
case $- in
    *i*)
        # this is an interactive shell, continue
        :
        ;;
      *)
        # this shell is not interactive, we're done
        return
        ;;
esac

# don't put consecutive duplicate lines in the history.
# we're OK with lines beginning with space
HISTCONTROL=ignoredups

# append to the history file, don't overwrite it
shopt -s histappend

# keep a lot of history, we're fond of it
HISTSIZE=2000
HISTFILESIZE=4000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# if I am using less, make it more friendly
# better search result positioning in the viewport
LESS="-j22"
# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

# incorporate this Cygwin PS1
# '\[\e]0;\w\a\]\n\[\e[32m\]\u@\h \[\e[33m\]\w\[\e[0m\]\n\$ '
if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
#    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# colored GCC warnings and errors
#export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# source my useful functions if it exists
[ -f ~/.bashMyFuncs ] && source ~/.bashMyFuncs || { echo Cannot proceed; exit 1; }

# Alias definitions.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

