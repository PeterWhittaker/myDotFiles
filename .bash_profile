# pww .bash_profile - invoke .bashrc, do all the interesting stuff there
# pww .bashrc exits if the shell is non-interactive once it has done
# "profile"-like things

# include .bashrc if it exists
if [ -f ~/.bashrc ]; then
    . ~/.bashrc
fi

