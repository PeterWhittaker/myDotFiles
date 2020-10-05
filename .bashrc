# pww .bashrc - everything starts here, though not everything finishes here
# pww .bash_profile just calls this, this does a few "always" things, then
# this checks for interactivity, exiting if not interactive, continuing on
# to do interactive things otherwise

# first, good practices that always make sense
umask 022

# next, some helper functions related to platform, because some "always"
# things are platform-dependent

# NOTE: Export these, because they get used in scripts

set -a
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
set +a

function isBash5plus {
    case ${BASH_VERSINFO[0]} in
        1|2|3|4)
            false
            ;;
        5)
            true
            ;;
        *)
            echo "Validate bash version before proceeding."
            false
            ;;
    esac
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

isInPath () {
    path="$1"
    want="$2"
    extras=$3

    # we need exactly two arguments; anything else is probably a quoting problem
    if [[ -z "$path" || -z "$want" || -n "$extras" ]]; then
        echo "$FUNCNAME requires PATH WANT; called with '$path' '$want' $3; doing nothing"
        return 1
    fi

    # if $path is empty, $want obviously isn't present
    [[ -z "${!path}" ]] && return 1

    # replace any ~ with $HOME, to be on the safe side
    [[ "$want" == *"~"* ]] && want="${want/#\~/$HOME}"

    if [[ "${!path}" != *"$want"* ]]; then
        # echo "NEED: no '$want' in '${!path}'" 
        return 1
    else
        # echo "GOOD: '$want' is in '${!path}'"
        return 0
    fi
}

checkFor () {
    path="$1"
    want="$2"
    extras=$3

    if [[ -z "$path" || -z "$want" || -n "$extras" ]]; then
        echo "$FUNCNAME requires PATH WANT; called with '$path' '$want' $3; doing nothing"
        return 1
    fi

    # if the desired folder doesn't exist, return - nothing to add
    [[ -d "$want" ]] || return

    # if the wanted folder is in the path, return - nothing to add
    isInPath "$path" "$want" && return

    # we only get here if we need to add to the path
    # now we need to know what type of path it is
    case $path in
        PATH)
            export PATH="${want}:${!path}"
            ;;
        PKG_CONFIG_PATH)
            export PKG_CONFIG_PATH="${want}:${!path}"
            ;;
        LDFLAGS)
            export LDFLAGS="-L${want} ${!path}"
            ;;
        CPPFLAGS)
            export CPPFLAGS="-I${want} ${!path}"
            ;;
    esac
}

# Take full advantage of BREW, if on Mac OS and if it installed
if isMacOS; then

    # linked brew formula
    checkFor PATH /usr/local/bin
    
    # ic4uc items
    checkFor PATH "/usr/local/opt/icu4c/bin"
    checkFor PATH "/usr/local/opt/icu4c/sbin"
    checkFor LDFLAGS /usr/local/opt/icu4c/lib"
    checkFor CPPFLAGS /usr/local/opt/icu4c/include"

    # ruby items
    checkFor PATH "/usr/local/opt/ruby/bin"
    checkFor LDFLAGS "/usr/local/opt/ruby/lib"
    checkFor CPPFLAGS "/usr/local/opt/ruby/include"

    # python items
    # switch/change/remove these PATH items as necessary
    # I'm never using python 2, so default to 3
    checkFor PATH "/usr/local/opt/python/libexec/bin"
    # keep the 3 executables for conversions
    checkFor PATH "/usr/local/opt/python/bin"
    checkFor LDFLAGS "/usr/local/opt/python/lib"
    checkFor PKG_CONFIG_PATH "/usr/local/opt/python/lib/pkgconfig"

    # sqlite items - installed with brew install python
    # commented out for now because unsure if needed
    #checkFor PATH "/usr/local/opt/sqlite/bin"
    #checkFor LDFLAGS "/usr/local/opt/sqlite/lib"
    #checkFor CPPFLAGS "/usr/local/opt/sqlite/include"

    # openssl items
    checkFor PATH "/usr/local/opt/openssl/bin"
    checkFor LDFLAGS "/usr/local/opt/openssl/lib"
    checkFor CPPFLAGS "/usr/local/opt/openssl/include"
    checkFor PKG_CONFIG_PATH "/usr/local/opt/openssl/lib/pkgconfig"

fi

# always prepend my bin, if it exists and is not already there
checkFor PATH ~/bin

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

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# if I am using less, make it more friendly
# better search result positioning in the viewport
# always respect color (good for git diff)
# this should be an environment variable
#export LESS="${LESS:+$LESS} -j22 -r"
export LESS="${LESS:+$LESS} -j22 -R -F -S -X"
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

if [ "$color_prompt" = yes ]; then
    if [ isCygwin ]; then
        # need to understand the codes, figure why the default prompt
        # doesn't work on Cygwin - color disappears....
        PS1='\[\e]0;\w\a\]\n\[\e[32m\]\u@\h \[\e[33m\]\w\[\e[0m\]\n\$ '
    else
        # add some new lines to make it prettier
        PS1='\n${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\n\$ '
    fi
else
    # add some new lines to make it prettier
    PS1='\n${debian_chroot:+($debian_chroot)}\u@\h:\w\n\$ '
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

# for the moment, until we figure this out properly, hard set it here, seems to work everywhere
PS1='\n\[\e]0;\u@\h: \w\a\]${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\n\! \$ '
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
# if these exist, we want them in the environment
set -a
[ -f ~/.bashMyFuncs ] && source ~/.bashMyFuncs || echo "Could not find ~/.bashMyFuncs"
set +a

# Alias definitions.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# very specific case
[[ -f ~/myBinFiles/getMyGitsrc ]] && . ~/myBinFiles/getMyGitsrc

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

function _setAndReloadHistory {
    lastTenHist=$(history 10)
    builtin history -a
    builtin history -c
    builtin history -r
}

function listHist {
    echo "$lastTenHist"
}

##############################################
# Manage shell history - there is lot here....
# It is last, because for reasons I do not yet grok,
# everything that occurs after this in this file is
# recorded in my command history, which I find odd.
if isBash5plus; then

    # preserve shell history
    set -o history
    # preserve multiline commands...
    shopt -s cmdhist
    # preserve multiline command as literally as possible
    shopt -s lithist
    # reedit failed history substitutions
    shopt -s histreedit
    # enforce careful mode... we'll see how this goes
    shopt -s histverify

    # timestamp all history entries
    # from stackexchange: The format '%FT%T ' shows the time but only when using the history command
    # HISTTIMEFORMAT='%FT%T '
    HISTTIMEFORMAT='%Y-%m-%d:%H:%M '

    # not the default, we like to be explicit that we are not using defaults
    HISTFILE=~/.bash_eternal_history
    # preserve all history, forever
    HISTSIZE=-1
    # preserve all history, forever, on disk
    HISTFILESIZE=-1
    # record only one instance of a command repeated after itself
    HISTCONTROL=ignoredups

    # preserve history across/between shell sessions...
    # ...when the shell exits...
    shopt -s histappend
    # ...and after every command...
    PROMPT_COMMAND="${PROMPT_COMMAND:+$PROMPT_COMMAND; } _setAndReloadHistory"

else

    # This is tricky - what is the best pre-5 approach?
    # For now, do nothing, accept shell and system defaults,
    # knowing that on Mac OS, at least, the presence of 
    #   .bash_sessions_disable
    # is going to disable session-based history preservation
    echo 'Validate history management strategy for this platform.'
    echo "Current settings are:"
    set | grep -i hist
    [[ isMacOS ]] && echo "You may need to change to a brew-installed shell."
    # Defaults on Mac OS with
    # GNU bash, version 3.2.57(1)-release (x86_64-apple-darwin19)
    #HISTFILE=/Users/pww/.bash_history
    #HISTFILESIZE=500
    #HISTSIZE=500
    # shopt -s history
    # shopt -s histexpand
fi
