#!/bin/bash
#===============================================================================
#
#          FILE: color.sh
# 
#   DESCRIPTION: yaourt's library to manage colors
# 
#       OPTIONS:  ---
#  REQUIREMENTS:  ---
#          BUGS:  ---
#         NOTES:  ---
#        AUTHOR:   Julien MISCHKOWITZ (wain@archlinux.fr) 
#       VERSION:  1.0
#===============================================================================

initcolor(){
# no special caracter for textonly mode
if [ "$COLORMODE" = "--textonly" ]; then
	TERMINALTITLE=0
	return 0
else
	# font type
	COL_BOLD="\033[38;5;223m"
	COL_INVERT="\033[7m"
	COL_BLINK="\033[38;5;196m"
	NO_COLOR="\033[0m"

	# No italic out of Xorg or under screen
	if [ ! -z "$DISPLAY" ] && [ "${TERM:0:6}" != "screen" ]; then
		COL_ITALIQUE="\033[3m"
		local _colitalique="\033[3m\\"
	fi
fi


# Color list
case $COLORMODE in
	"--nocolor")
	COL_WHITE="\033[0m"
	COL_YELLOW="\033[0m"
	COL_RED="\033[0m"
	COL_CYAN="\033[0m"
	COL_GREEN="\033[0m"
	COL_PINK="\033[0m"
	COL_BLUE="\033[0m"
	COL_BLACK="\033[0m"
	COL_MAGENTA="\033[0m"
	;;
	"--lightbg")
	COL_WHITE="\033[1;37m"
	COL_RED="\033[1;31m"
	COL_CYAN="\033[1;36m"
	COL_GREEN="\033[1;32m"
	COL_PINK="\033[1;35m"
	COL_BLUE="\033[1;34m"
	COL_BLACK="\033[1;30m"
	COL_MAGENTA="\033[1;35m"
	COL_YELLOW="$COL_CYAN"
	;;
	*)
	COL_WHITE="\033[38;5;40m"
	COL_YELLOW="\033[38;5;215m"
	COL_RED="\033[38;5;196m"
	COL_CYAN="\033[38;5;36m"
	COL_GREEN=" \033[38;5;197m-> \033[38;5;44m"
	COL_PINK="\033[38;5;197m"
	COL_BLUE="\033[38;5;38m"
	COL_BLACK="\033[38;5;234m"
	COL_MAGENTA="\033[38;5;177m"
	;;
esac

# Color functions
COL_INSTALLED="\033[38;5;110m" # show [installed] packages
COL_ARROW="$COL_YELLOW" # show ==>
COL_NUMBER="$COL_INVERT$COL_YELLOW" # show number) in listing
COL_CORE="\033[38;5;202m"
COL_EXTRA="\033[38;5;203m"
COL_LOCAL="\033[38;5;196m"
COL_COMMUNITY="\033[38;5;118m"
COL_UNSTABLE="$_colitalique$COL_RED"
COL_REPOS="\033[38;5;113m"
COL_GROUP="\033[38;5;121m"
}
list(){
	echo -e "${COL_ARROW}$1${NO_COLOR}" >&2
}
plain(){
	echo -e "${COL_BOLD}$*${NO_COLOR}" >&2
}
msg(){
	echo -e "${COL_GREEN}==> ${NO_COLOR}${COL_BOLD}$*${NO_COLOR}" >&2
}
warning(){
	echo -e "${COL_YELLOW}==> WARNING: ${NO_COLOR}${COL_BOLD}$*${NO_COLOR}" >&2
}
prompt(){
        echo -e "${COL_ARROW}==>  ${NO_COLOR}${COL_BOLD}$*${NO_COLOR}" >&2
	echo -e "${COL_ARROW}==>  ${NO_COLOR}${COL_BOLD} ----------------------------------------------${NO_COLOR}" >&2
	echo -ne "${COL_ARROW}==>${NO_COLOR}" >&2
}
promptlight(){
	echo -ne "${COL_ARROW}==>${NO_COLOR}" >&2
}
error(){
	echo -e "${COL_RED}""Error""${NO_COLOR}"": $*\n"
	return 1
}
colorizeoutputline(){		
	if [ "$COLORMODE" = "--textonly" ]; then
		local line=`echo $* | sed -e 's#^core/#&#g' \
		-e 's#^extra/#&#g' \
        	-e 's#^community/#&#g' \
        	-e 's#^unstable/#&#g' \
        	-e 's#^local/#&#g' \
        	-e 's#^[a-z0-9-]*/#&#g'`
	else
	local line=`echo $* | sed -e 's#^core/#\\'${COL_CORE}'     &\\'${NO_COLOR}'#g'\
	-e 's#^extra/#\\'${COL_EXTRA}'    &\\'${NO_COLOR}'#g'\
        -e 's#^community/#\\'${COL_COMMUNITY}'&\\'${NO_COLOR}'#g' \
        -e 's#^unstable/#\\'${COL_UNSTABLE}'&\\'${NO_COLOR}'#g' \
        -e 's#^local/#\\'${COL_LOCAL}'    &\\'${NO_COLOR}'#g' \
        -e 's#^[a-z0-9-]*/#\\'${COL_REPOS}'      &\\'${NO_COLOR}'#g'`
	fi
	echo $line
}
cleanoutput(){
if [ $TERMINALTITLE -eq 0 -o -z "$DISPLAY"  ]; then
	return 0
fi
tput sgr0
}

