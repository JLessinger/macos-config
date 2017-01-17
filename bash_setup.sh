USG_MSG="usage: bash_setup.sh [-b] -s (mac|ubuntu)
\t-b : bypass interactive confirmation; just execute\n"

function abort {
    printf "$1" >&2
    exit 1
}

#  in:
#    nothing
#  out:
#    nothing
#  side effects:
#    cancels with status 0 iff not confirmed
function confirm {
    if [ "$BYPASS" == false ] ; then
	printf "WARNING: overwrites stuff. Set up unix environment? (y/n)\n"
	read resp
	resp=${resp,,}
	case "$resp" in
	    y|ye|yes) # pass through
	    ;;
	    *) printf "canceling\n"
	       exit 0
	       ;;
	esac
    fi
}

function execute_mac {
    printf "executing mac setup...\n"
    cp .bashrc ~/ && . ~/.bashrc
    cp .bash_profile ~/
    cp .inputrc ~/ && ~/.inputrc
    cp .gitconfig_mac ~/.gitconfig
    /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
    brew install emacs --with-cocoa
}

function execute_ubuntu {
    cp .bashrc ~/ && . ~/.bashrc
    cp .bash_profile ~/
    cp .inputrc ~/ && ~/.inputrc
    cp .gitconfig_ubuntu ~/.gitconfig
    sudo apt-get update && sudo apt-get install emacs
}


function confirm_execute {
    confirm
    if [ "$SYSTEM" == "mac" ]; then
	execute_mac
    elif [ "$SYSTEM" == "ubuntu" ]; then
	execute_ubuntu
    fi
}

function verify_confirm_execute {
    if [ "$SYSTEM" == "mac" ] || [ "$SYSTEM" == "ubuntu" ]; then
	confirm_execute "$@"
    else
	abort "$USG_MSG"
    fi
}

function parse_verify_confirm_execute {
    OPTIND=1         # Reset in case getopts has been used previously in the shell.

    # Initialize our own variables:
    BYPASS=false
    REPLICATE=false
    SYSTEM=""

    while getopts "s:bh" opt; do
	case "$opt" in
	    # fill in options
	    s)
		SYSTEM=$OPTARG ;;
	    b)
		BYPASS=true ;;
            h)
		printf "$USG_MSG"
		exit 0 ;;
	    *)
		abort "$USG_MSG"
	esac
    done

    shift $((OPTIND-1))

    [ "$1" = "--" ] && shift

    # get rid of trailing / to make the rest easier
    args=( "$@" )
    args[0]="${1%/}"
    args[1]="${2%/}"
    set "${args[@]}"
    verify_confirm_execute "$@"
}

parse_verify_confirm_execute "$@"
