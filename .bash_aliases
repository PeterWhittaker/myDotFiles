
# pww 20070120
function nwst () {
	ls -alt $@ | head
}

# pww 2020-08-14 - type most of this a lot.
fndg () {
    shopt -s nocasematch
    [[ $1 == "-dobin" ]] && { binOpt=""; shift; } || binOpt="-I"
    startIn=.
    [[ ! -z $2 ]] && { startIn=$1; shift; }
    [[ -z $1 ]] && { echo "No target specified, cannot proceed."; return; }
    tgt=$1
    echo find . -type f -exec grep -i -H "${tgt}" {} \;
    find ${startIn} -type f -exec grep $binOpt -i -H "${tgt}" {} \; 2> /dev/null
}

# pww 20081008 - more convenient find, when just looking for files/folders
function fndi () {

	tgt="${1}"; shift
	echo find . -iname \*"${tgt}"\* "${@}"
	find . -iname \*"${tgt}"\* "${@}" 2> /dev/null
    [[ -z $tgt ]] && { echo; echo "No target was specified, did the results surprise?"; }
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

# if available, use a better less
vimrntm=$(vim -u NONE -es -c '!echo $VIMRUNTIME' -c q)
vimless=${vimrntm}/macros/less.sh
[[ -x ${vimless} ]] && alias less=${vimless} || { \
    echo; echo You may want to find less.sh manually, using pure less for now.; echo; }

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

# 2020-03-31 - easier SSH key management, especially for git
# requires that the key file be specified
alias addkeys='eval "$(ssh-agent -s)"; ssh-add'
