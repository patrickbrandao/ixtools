
#
#
#
# Biblioteca de funcoes shell-script
#
#
#
#--------------------------------- Definicao de cores ANSI
    # Cores
    ANSI_RESET='\033[0m'
    ANSI_BLACK="0;30"; ANSI_DARKBLACK="1;30"
    ANSI_RED="0;31"; ANSI_LRED="1;31"
    ANSI_GREEN="0;32"; ANSI_LGREEN="1;32"
    ANSI_ORANGE="0;33"
    ANSI_YELLOW="1;33"
    ANSI_BLUE="0;34"; ANSI_LBLUE="1;34"
    ANSI_PINK="0;35"; ANSI_LPINK="1;35"
    ANSI_CYAN="0;36"; ANSI_LCYAN="1;36"
    ANSI_GRAY="0;37"
    ANSI_WHITE="1;37"

    # Reset
    ANSI_RESET='\033[0m'           # Text Reset
    ANSI_BLINK='\e[5m'				# Blink
    ANSI_LIGHT='\x1B'

    # Regular Colors
    ANSI_BLACK='\033[0;30m'        # Black
    ANSI_RED='\033[0;31m'          # Red
    ANSI_GREEN='\033[0;32m'        # Green
    ANSI_YELLOW='\033[0;33m'       # Yellow
    ANSI_BLUE='\033[0;34m'         # Blue
    ANSI_PINK='\033[0;35m'         # Purple
    ANSI_CYAN='\033[0;36m'         # Cyan
    ANSI_WHITE='\033[0;37m'        # White

    # Light
    #echo -e "\x1B[96m foobar \x1B[0m" # cyan
    ANSI_LIGHT_BLACK='\x1B[90m'        # Black
    ANSI_LIGHT_RED='\x1B[91m'          # Red
    ANSI_LIGHT_GREEN='\x1B[92m'        # Green
    ANSI_LIGHT_YELLOW='\x1B[93m'       # Yellow
    ANSI_LIGHT_BLUE='\x1B[94m'         # Blue
    ANSI_LIGHT_PINK='\x1B[95m'         # Purple
    ANSI_LIGHT_CYAN='\x1B[96m'               # Cyan
    ANSI_LIGHT_WHITE='\x1B[97m'              # White

    # Bold
    ANSI_BOLD_BLACK='\033[1;30m'       # Black
    ANSI_BOLD_RED='\033[1;31m'         # Red
    ANSI_BOLD_GREEN='\033[1;32m'       # Green
    ANSI_BOLD_YELLOW='\033[1;33m'      # Yellow
    ANSI_BOLD_BLUE='\033[1;34m'        # Blue
    ANSI_BOLD_PINK='\033[1;35m'        # Purple
    ANSI_BOLD_CYAN='\033[1;36m'        # Cyan
    ANSI_BOLD_WHITE='\033[1;37m'       # White

    # Underline
    ANSI_UNDER_BLACK='\033[4;30m'       # Black
    ANSI_UNDER_RED='\033[4;31m'         # Red
    ANSI_UNDER_GREEN='\033[4;32m'       # Green
    ANSI_UNDER_YELLOW='\033[4;33m'      # Yellow
    ANSI_UNDER_BLUE='\033[4;34m'        # Blue
    ANSI_UNDER_PINK='\033[4;35m'        # Purple
    ANSI_UNDER_CYAN='\033[4;36m'        # Cyan
    ANSI_UNDER_WHITE='\033[4;37m'       # White

    # Blink Colors
    ANSI_BLACK='\033[5;30m'        # Black
    ANSI_RED='\033[5;31m'          # Red
    ANSI_GREEN='\033[5;32m'        # Green
    ANSI_YELLOW='\033[5;33m'       # Yellow
    ANSI_BLUE='\033[5;34m'         # Blue
    ANSI_PINK='\033[5;35m'         # Purple
    ANSI_CYAN='\033[5;36m'         # Cyan
    ANSI_WHITE='\033[5;37m'        # White

    # Background
    ANSI_BG_BLACK='\033[40m'       # Black
    ANSI_BG_RED='\033[41m'         # Red
    ANSI_BG_GREEN='\033[42m'       # Green
    ANSI_BG_YELLOW='\033[43m'      # Yellow
    ANSI_BG_BLUE='\033[44m'        # Blue
    ANSI_BG_PINK='\033[45m'        # Purple
    ANSI_BG_CYAN='\033[46m'        # Cyan
    ANSI_BG_WHITE='\033[47m'       # White

# Funcoes independentes estilo toolbox
    _ansi_reset(){ echo -n -e "${ANSI_RESET}"; }
    _echo_success(){ echo -en "\\033[71G"; echo -en "$ANSI_LIGHT_WHITE["; echo -en "$ANSI_BOLD_GREEN  OK  $ANSI_RESET"; echo -e "$ANSI_LIGHT_WHITE]$ANSI_RESET"; }
    _echo_failure(){ echo -en "\\033[71G"; echo -en "$ANSI_BG_RED $ANSI_BLINK"; echo -en "$ANSI_BOLD_WHITE$ANSI_LIGHT FAILED $ANSI_RESET"; echo -e "$ANSI_LIGHT_WHITE$ANSI_RESET"; }
    _echo_passed(){ echo -en "\\033[71G"; echo -en "$ANSI_BG_GREEN "; echo -en "$ANSI_BOLD_WHITE$ANSI_LIGHT PASSED $ANSI_RESET"; echo -e "$ANSI_LIGHT_WHITE$ANSI_RESET"; }
    _echo_good(){ echo -en "\\033[71G"; echo -en "$ANSI_BG_GREEN "; echo -en "$ANSI_BOLD_BLACK$ANSI_LIGHT  GOOD  $ANSI_RESET"; echo -e "$ANSI_LIGHT_WHITE$ANSI_RESET"; }
    _echo_bad(){ echo -en "\\033[71G"; echo -en "$ANSI_BG_RED $ANSI_BLINK"; echo -en "$ANSI_BOLD_WHITE$ANSI_LIGHT  BAD   $ANSI_RESET"; echo -e "$ANSI_LIGHT_WHITE$ANSI_RESET"; }
    _echo_warn(){ echo -en "\\033[71G"; echo -en "$ANSI_BG_WHITE"; echo -en "$ANSI_BOLD_RED$ANSI_LIGHTWARNING$ANSI_RESET"; echo -e "$ANSI_LIGHT_WHITE$ANSI_RESET"; }
    _echo_unknow(){ echo -en "\\033[71G"; echo -en "$ANSI_BG_WHITE"; echo -en "$ANSI_LIGHT_BLACK UNKNOW $ANSI_RESET"; echo -e "$ANSI_LIGHT_WHITE$ANSI_RESET"; }

    _echo_lighred_n(){ echo -ne "${ANSI_LIGHT_RED}$@$ANSI_RESET"; }
    _echo_lighgreen_n(){ echo -ne "${ANSI_LIGHT_GREEN}$@$ANSI_RESET"; }
    _echo_lighyellow_n(){ echo -ne "${ANSI_LIGHT_YELLOW}$@$ANSI_RESET"; }
    _echo_lighcyan_n(){ echo -ne "${ANSI_LIGHT_CYAN}$@$ANSI_RESET"; }
    _echo_lighpink_n(){ echo -ne "${ANSI_LIGHT_PINK}$@$ANSI_RESET"; }

    _echo_lighred(){ echo -e "${ANSI_LIGHT_RED}$@$ANSI_RESET"; }
    _echo_lighgreen(){ echo -e "${ANSI_LIGHT_GREEN}$@$ANSI_RESET"; }
    _echo_lighyellow(){ echo -e "${ANSI_LIGHT_YELLOW}$@$ANSI_RESET"; }
    _echo_lighpink(){ echo -e "${ANSI_LIGHT_PINK}$@$ANSI_RESET"; }
    _echo_lighcyan(){ echo -e "${ANSI_LIGHT_CYAN}$@$ANSI_RESET"; }

    _setcolor(){
	case "$1" in
	    'black')
		echo -en "${ANSI_LIGHT_BLACK}$";
		;;
	    'red')
		echo -en "${ANSI_LIGHT_RED}$";
		;;
	    'green')
		echo -en "${ANSI_LIGHT_GREEN}";
		;;
	    'yellow')
		echo -en "${ANSI_LIGHT_YELLOW}";
		;;
	    'blue')
		echo -en "${ANSI_LIGHT_BLUE}";
		;;
	    'pink')
		echo -en "${ANSI_LIGHT_PINK}";
		;;
	    'cyan')
		echo -en "${ANSI_LIGHT_CYAN}";
		;;
	    'white')
		echo -en "${ANSI_LIGHT_WHITE}";
		;;
	    *)
		echo -en "$ANSI_RESET";
	esac
    }

    # retornar ao inicio da linha
    _linereturn(){ echo -ne "\r"; }

    # imprimir ponto dependendo do erro na stdno
    _echo_xdot(){
	if [ "x$1" = "x1" ]; then
	    echo -ne "${ANSI_LIGHT_RED}x$ANSI_RESET"
	else
	    echo -ne "$ANSI_LIGHT_GREEN.$ANSI_RESET"
	fi
    }
    # Verificar se e' numerico
    _is_int(){
	echo "$1" | egrep '^[0-9]+$' 1>/dev/null && return 0
	return 1
    }

    # Apenas caracteres dentro de um grupo: permite (a-z, A-Z, 0-9, _, ., -, /)
    _str_group_d(){
	echo "$1" | egrep '^[a-zA-Z0-9_\./@-]+$' 1>/dev/null && return 0
	return 1
    }

    # Obter timestamp
    _timestamp(){
	date "+%s"
    }
    # verificar se o numero esta num range
    _in_numrange(){
	_in_num="$1"
	_in_min="$2"
	_in_max="$3"
	[ "$_in_num" -lt "$_in_min" ] && return 1
	[ "$_in_num" -gt "$_in_max" ] && return 2
	return 0
    }

    _dot_dir=1; _dot_count=0; _dot_limit=40
    _dot_loading(){
	if [ "$_dot_dir" = "1" ]; then
	    if [ "$_dot_count" = "40" ]; then
		_dot_dir=0
	    else
		echo -n "."
		_dot_count=$(($_dot_count+1))
	    fi
	else
	    if [ "$_dot_count" = "0" ]; then
		_dot_dir=1
	    else
		echo -ne "\b \b\b "
		_dot_count=$(($_dot_count-1))
	    fi
	fi
    }
    _dot_reset(){ _dot_dir=1; _dot_count=0; _dot_limit=40; }

    # Teste
    #-		_str_group_d "aaaa00022888fffxxxx" && echo "Teste 1 OK"
    #-		_str_group_d "aaaa0002@2888fffxxxx@" && echo "Teste 2 OK"
    #-		_str_group_d "-aaaa000228-88fffxxxx-" && echo "Teste 3 OK"
    #-		_str_group_d "/aaaa000228/8@8fff-x.xxx" && echo "Teste 4 OK"
    #-		_str_group_d "aaaa00022888fffxxxx/" && echo "Teste 5 OK"
    #-		_str_group_d "/aaaa00022888fffxxxx" && echo "Teste 6 OK"
    #-		_str_group_d "@aaaa00022888fFfxxxx" && echo "Teste 7 OK"
    #-		_str_group_d "aaaa00022888fffxxxx@" && echo "Teste 8 OK"
    # Teste
    #-	_ansi_reset
    #-		echo -n "Teste _echo_success "; _echo_xdot; _echo_xdot; _echo_xdot 1; _echo_xdot 0; _echo_xdot 1;
    #-		_echo_success
    #-		echo -n "Teste _echo_failure "
    #-		_echo_failure
    #-		echo -n "Teste _echo_unknow "
    #-		_echo_unknow
    #-		echo
    #-		echo -n "Toolbox echo_success "; echo_xdot; echo_xdot; echo_xdot 1; echo_xdot 0; echo_xdot 1;
    #-		echo_success
    #-		echo -n "Toolbox echo_failure "
    #-		echo_failure
    #-		echo -n "Toolbox echo_unknow "
    #-		echo_unknow

    # Testar se ambiente local tem as ferramentas Slackmini
    TOOLNOTFOUND=""
    _have_tools(){
	_tools="
	    uname
	    cat cp curl cut chmod chown df du echo egrep grep
	    find free head ifconfig ip iptables ip6tables
	    kill killall ln ls mkdir modprobe more mv mysql ntpdate nslookup
	    ping ps rm rmdir sed sh sleep tail tc timeout touch	vconfig
	"
	for _t in $_tools; do
	    which "$_t" 2>/dev/null 1>/dev/null && continue
	    TOOLNOTFOUND="$_t $TOOLNOTFOUND"
	done
	TOOLNOTFOUND=$(echo $TOOLNOTFOUND)
	[ "x$TOOLNOTFOUND" = "x" ] && return 0
	return 52
    }
    # Listar ferramentas nao encontradas

    # Texto de inicio de linha
    _echounk(){ [ "$QUIET" = "1" ] && return; _echo_unknow; }
    _echosuc(){ [ "$QUIET" = "1" ] && return; _echo_success; }
    _echofai(){ [ "$QUIET" = "1" ] && return; _echo_failure; }
    _echony(){ [ "$QUIET" = "1" ] && return; _echo_lighyellow_n "$@"; }
    _echong(){ [ "$QUIET" = "1" ] && return; _echo_lighgreen_n "$@"; }
    _echon(){ [ "$QUIET" = "1" ] && return; _echo_lighcyan_n "$@"; }
    _echodx(){ [ "$QUIET" = "1" ] && return; _echo_xdot "$1"; }
    _echo(){ [ "$QUIET" = "1" ] && return; _echo_lighcyan "$@"; }
    _abort(){ [ "$QUIET" = "1" ] && exit $2; echo; echo; _echo_lighpink "ABORTADO"; _echo_lighyellow "$1"; echo; echo; exit $2; }
    _abortn(){ [ "$QUIET" = "1" ] && exit $2; _echo_failure; _abort "$1" $2; }

    _fail_abort(){
	 [ "$QUIET" = "1" ] && return $2
	 _echo_lighyellow " $1"
	 exit $2
    }
    _fail_continue(){
	 [ "$QUIET" = "1" ] && return $2
	 _echo_lighpink " > Problema detectado:"
	 _echo_lighyellow " $1"
	 return $2
    }
    _fail_continue_n(){
	 [ "$QUIET" = "1" ] && return $2
	 _echo_warn
	 _fail_continue "$1" $2; 
    }

    # substituir strings
    _str_replace(){
	_str="$1"
	_old="$2"
	_new="$3"
	echo "$_str" | sed "s#$_old#$_new#g; s#$_old#$_new#g"
    }
    # retirar espacos
    _trim(){
	_str="$1"
	_str=$(echo $_str)
	_str=$(echo $_str)
	echo $_str
    }
    # Testar expressao regular
    _str_regex(){
	_str="$1"
	_reg="$2"
	_tst=$(echo "$_str" | egrep "$_reg")
	[ "x$_tst" = "x" ] && return 1
	return 0
    }

    # Obter fabricante do mac
    _macowner(){
	mo="$1"
	#echo "MAC: [$mo]"
	moh=$(echo $mo | sed 's#[^0-9a-fA-F]##g' | cut -b1-6)
	#echo "MOH: [$moh]"
	mow=$(cat /usr/share/nmap/nmap-mac-prefixes | egrep -i "^$moh" | head -1)
	#echo "MOW: [$mow]"
	echo $mow
    }

    # Obter numero de redes /24 em um prefixo
    _ipv4subnets(){
	xn="$1"
	[ "$xn" = "24" ] && echo 1 && return
	[ "$xn" = "23" ] && echo 2 && return
	[ "$xn" = "22" ] && echo 4 && return
	[ "$xn" = "21" ] && echo 8 && return
	[ "$xn" = "20" ] && echo 16 && return
	[ "$xn" = "19" ] && echo 32 && return
	[ "$xn" = "18" ] && echo 64 && return
	[ "$xn" = "17" ] && echo 128 && return
	echo 0
	return 1
    }
    
    # obter ultimos 2 bytes
    _hexb(){ x="00$1"; echo ${x:(-2)}; } 


