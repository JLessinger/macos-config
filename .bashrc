export EDITOR=emacs

function stt_both { setTerminalText 0 $@; }
function stt_tab { setTerminalText 1 $@; }
function stt_title { setTerminalText 2 $@; }

function cl {
    DIR=$1
    if [ -z "$1" ]; then
       DIR=$HOME
    fi      
    cd "$DIR" && ls;
}

function clean {
    DIR="$1"
    if [ -z "$1" ]; then
	DIR="."
    fi
    rm $DIR/*~
    rm $DIR/\#*
}

function cleanr {
    DIR="$1"
    if [ -z "$1" ]; then
	DIR="."
    fi
    find "$DIR" -name "*~" -delete
}

function touch_local_fs {
    F=".autosl-temp-file-"`date +%s | md5`
    touch $F
    rm $F
}

# java

export JAVA_HOME="/Library/Java/JavaVirtualMachines/jdk1.7.0_12.jdk/Contents/Home"
export ANT_HOME="/usr/local/Cellar/ant/1.9.2/libexec"

test -r /sw/bin/init.sh && . /sw/bin/init.sh

# python

#export PYTHONPATH="${PYTHONPATH}:/usr/local/lib/python2.7/site-packages"

# Setting PATH for Python 2.7
# The orginal version is saved in .profile.pysave
# export PATH="/Library/Frameworks/GTK+.framework/Versions/2.18.x11/Resources/bin:${PATH}"

## use anaconda libraries instead
#export PYTHONPATH="/usr/local/lib/python2.7/site-packages:/Library/Python/2.7/site-packages/"
#export PYTHONPATH="$PYTHONPATH:/System/Library/Frameworks/Python.framework/Versions/2.7/Extras/lib/python/"

## can we use both, defaulting to anaconda? this particular setting doesn't work
#export PYTHONPATH="/Users/jonathan/Library/anaconda2/lib/:$PYTHONPATH"

####aliases

####aliases (linux only?)
#alias cp='cp --backup=numbered'
#alias ln='ln --backup=numbered'
#alias mv='mv -f --backup=numbered'

export DYLD_LIBRARY_PATH=/usr/local/mysql-5.5.13-osx10.6-x86_64/lib/


#if [ -e /Users/jonathan/.nix-profile/etc/profile.d/nix.sh ]; then . /Users/jonathan/.nix-profile/etc/profile.d/nix.sh; fi # added by Nix installer

# iterm 

# $1 = type; 0 - both, 1 - tab, 2 - title
# rest = text
setTerminalText () {
    # echo works in bash & zsh
    local mode=$1 ; shift
    echo -ne "\033]$mode;$@\007"
}
stt_both  () { setTerminalText 0 $@; }
stt_tab   () { setTerminalText 1 $@; }
stt_title () { setTerminalText 2 $@; }

_dotfiles_scm_info()
{
  # find out if we're in a git or hg repo by looking for the control dir
    local d git hg
    d="$PWD"
    while test "$d" != "/" ; do
        if [ -f "$d/.githomedirmarker" ] ; then
            break
        fi
        if test -d "$d/.git" ; then
            git="$d"
            break
        fi
        if test -d "$d/.hg" ; then
            hg="$d"
            break
        fi
        # portable "realpath" equivalent
            d=$(cd "$d/.." && echo $PWD)
    done
    # weird echo constructs are to force a suffix of a space character
    # in the case where we find a branch; we don't output anything if
    # we don't find one
    if test -n "$hg" ; then
        if test -f $hg/.hg/bookmarks.current ; then
	    cur=`cat "$hg/.hg/bookmarks.current"`
        elif test -f $hg/.hg/branch ; then
	    cur=`cat "$hg/.hg/branch"`
        fi
	echo " ($cur)"
    elif test -n "$git" ; then
        if test -f "$git/.git/HEAD" ; then
	    local head=`cat "$git/.git/HEAD"`
            case "$head" in
                # ref:\ refs/heads/master)
                #     echo " (m)"
                #     ;;
                ref:\ refs/heads/*)
                    if test -n "$ZSH_VERSION" ; then
                        # older zsh doesn't support the bash substring syntax
                        echo " ($head[17,-1])"
                    else
                        echo " (${head:16})"
                    fi
                    ;;
                *)
                    # not sure what this is
                    echo " (${head:7})"
                    ;;
            esac
        fi
    fi
}

function _color_return {
    ret=$?
    if [ $ret = 0 ]; then
        echo "0"
    else
        echo "31"
    fi
    #return $ret
}

HISTSIZE=1000000
HISTFILESIZE=-1

# tmux
export EVENT_NOKQUEUE=1

PS1="\[\e[0;\$(_color_return)m\]\u\[\e[0m\]@\[\e[0;$((31 + $(hostname | cksum | cut -c1-3) % 6))m\]\h\[\e[0m\]:\w\[\e[0;33m\]\$(_dotfiles_scm_info)\[\e[0m\]$END "

PROMPT_COMMAND="touch_local_fs"

#export PATH="/Users/jonathan/Library/anaconda2/bin:$PATH"


# Avoid duplicates
export HISTCONTROL=ignoredups:erasedups
# When the shell exits, append to the history file instead of overwriting it
shopt -s histappend

# After each command, append to the history file and reread it
export PROMPT_COMMAND="${PROMPT_COMMAND:+$PROMPT_COMMAND$'\n'}history -a"
# read history
alias rh="history -c; history -r"

export PATH="/Users/jonathan/Library/miniconda3/bin:$PATH"
source "/Users/jonathan/Library/miniconda3/etc/profile.d/conda.sh"
