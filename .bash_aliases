
# pww 20070120
function nwst () {
	ls -alt $@ | head
}

# pww 20081008 - more convenient find
function fndi () {

	tgt="${1}"; shift
	echo find . -iname \*"${tgt}"\* "${@}"
	find . -iname \*"${tgt}"\* "${@}"
}


# pww 20051117 and 2020-03-26

alias ls="ls -F"
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
alias lt='ls -alt'

# pww 20180201 - 2020-03-30 if only if were that simple
# alias vi=vim
if isCygwin ; then
    # we keep the Windows path, which makes vim a GUI application,
    # while vi is actually vim and vim doesn't exist, because weird
    alias vim=vi
else
    # we have good vim, and our vimrc is set to incompatibility mode,
    # but just in case, make sure we are vimming
    alias vi=vim
fi

#pww 20070124
function grpkill () {
	if [ x = x"$1" ] ; then
		echo "Need an argument"
	else
		echo "Killing all $1"
		for pid in `ps ax | grep "$1" | cut -f 1 -d ' '` ;do
			kill $pid
		done
	fi
}

# 20120809
alias dfh="df -h"
alias dush="du -s -h"

# a better less  - should be in a conditional, per host
if [ -f /usr/share/vim/vim81/macros/less.sh ]; then
    # good, reasonably up to date host
    alias less='/usr/share/vim/vim81/macros/less.sh'
elif [ -f /usr/share/vim/vim80/macros/less.sh ]; then
    # Sphyrna Mac - we can do better, but this will work for now
    alias less='/usr/share/vim/vim80/macros/less.sh'
else
    echo; echo You may want to find less.sh manually, using pure less for now.; echo
fi

# 2020-03-26 - many CSDPAC-related aliases
# 2020-03-30 - trying a conditional

if [ -d ~/eclipse ]; then
    # the only machine I have Eclipse on is the Camunda dev one

        alias eclipse='nohup ~/eclipse/java-2019-122/eclipse/eclipse &>/dev/null &'
        alias camunda-modeler='nohup ~/camunda-modeler-3.6.0-linux-x64/camunda-modeler &>/dev/null &'
        alias munmod=camunda-modeler
        alias modeler=camunda-modeler

        alias camunda='~/bin/cammng'
        alias camundo='camunda start'
        alias camundead='camunda stop'
        alias munkick='camunda restart'

        alias warcopy='camunda warcopy'

        alias munda=camundo
        alias mundead=camundead
        alias munnew='camunda newwar'
        alias newwar=munnew
        alias whichwar='camunda lswars'
        alias whichwars=whichwar

        alias jump='cd ~/csdpac-workflows/template/tra-workflow'

fi
