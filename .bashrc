export EDITOR=`which emacs`

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

# java

export JAVA_HOME="/Library/Java/JavaVirtualMachines/jdk1.7.0_12.jdk/Contents/Home"
export ANT_HOME="/usr/local/Cellar/ant/1.9.2/libexec"

test -r /sw/bin/init.sh && . /sw/bin/init.sh

# python

# Setting PATH for Python 2.7
# The orginal version is saved in .profile.pysave
PATH="/Library/Frameworks/GTK+.framework/Versions/2.18.x11/Resources/bin:${PATH}"

## use anaconda libraries instead
#export PYTHONPATH="/usr/local/lib/python2.7/site-packages:/Library/Python/2.7/site-packages/"
#export PYTHONPATH="$PYTHONPATH:/System/Library/Frameworks/Python.framework/Versions/2.7/Extras/lib/python/"

## can we use both, defaulting to anaconda? this particular setting doesn't work
#export PYTHONPATH="/Users/jonathan/Library/anaconda2/lib/:$PYTHONPATH"

####aliases


export DYLD_LIBRARY_PATH=/usr/local/mysql-5.5.13-osx10.6-x86_64/lib/

# added by Anaconda2 4.0.0 installer
export PATH="/Users/jonathan/Library/anaconda2/bin:$PATH"

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

# tmux
export EVENT_NOKQUEUE=1
