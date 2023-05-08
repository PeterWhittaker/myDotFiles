
# pww 20070120
function nwst () {
	ls -alt $@ | head
}

# pww 2020-08-14 - type most of this a lot.
fndg () {
    binOpt="-I"; wordOpt=""
    caseOpt="-i"
    while true; do
        if [[ -z $1 || $1 =~ ^[^-+] ]]; then break; fi
        case $1 in
            +i)
                caseOpt=""
                ;;
            -B)
                binOpt=""
                ;;
            -w)
                wordOpt="-w"
                ;;
            *)
                echo "Unrecognized option '${1}', cannot proceed."
                return 1
                ;;
        esac
        shift
    done
    # if there are multiple arguments, the last one is the search
    # target, the rest control where and how find searches....
    if [[ -z $2 ]]; then
        startIn=.
    else
        startIn=''
        while [[ ! -z $2 ]]; do
            startIn+="$1 "
            shift
        done
    fi
    [[ -z $1 ]] && { echo "No target specified, cannot proceed."; return; }
    tgt=$1
    echo find ${startIn} -type f -exec grep $binOpt $wordOpt $caseOpt -H "${tgt}" {} \;
    find ${startIn} -type f -exec grep $binOpt $wordOpt $caseOpt -H "${tgt}" {} \; 2> /dev/null
}

# pww 20081008 - more convenient find, when just looking for files/folders
function fndi () {
    if [[ -z $2 ]]; then
        startIn=.
    else
        startIn=''
        while [[ ! -z $2 ]]; do
            startIn+="$1 "
            shift
        done
    fi
    [[ -z $1 ]] && { echo "No target specified, cannot proceed."; return; }
    tgt="${1}"; shift;
    echo find ${startIn} -iname \*"${tgt}"\* "${@}"
    find ${startIn} -iname \*"${tgt}"\* "${@}" 2> /dev/null
    [[ -z $tgt ]] && { echo; echo "No target was specified, did the results surprise?"; }
}


# pww 20051117 and 2020-03-26

alias ls="ls -F"
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
alias lt='ls -alt'
# Don't do this, just always pump diff through less,
# which is actually the vim macro
# alias diff='diff --color=always'

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

        alias jumpt='pushd ~/csdpac-workflows/template/tra-workflow'
        alias jumps='pushd ~/csdpac-workflows/template/sample-verity-workflow'

fi

# 2020-03-31 - easier SSH key management, especially for git
# requires that the key file be specified
alias addkeys='eval "$(ssh-agent -s)"; ssh-add'

# 2022-09-26 && 2022-10-18 - for Verity development under AlmaLinux
go () {
    [[ -z $1 ]] && tgt='~' || tgt=${1%%/}
    done=""
    declare index=0
    for dir in $(dirs); do
        [[ $tgt == $dir ]] && { pushd +${index}; done="y"; break; }
        (( index++ ))
    done
    [[ -z $done ]] && pushd $tgt
}

alias gbe='go /var/sphyrna/verity/backend'
alias gb=gbe
alias gfe='go /var/sphyrna/verity/frontend'
alias gf=gfe
alias gv='go /var/sphyrna/verity/'
alias gp='go /var/sphyrna/processes'
alias gbld='go /var/sphyrna/build'
alias gdb='go /var/sphyrna/ongdb-service'
alias gbootstrap='go /var/sphyrna/vm-bootstrap'
alias tmv='tmux new -A -s Verity'
alias tmd='tmux new -A -s Development'

