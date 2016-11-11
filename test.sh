#!/bin/sh

export PATH="/bin:/sbin:/usr/bin:/usr/sbin"
HERE=$(pwd)
#
# Realizar testes em ponto de troca de trafego
# Autor: Patrick Brandao <patrickbrandao@gmail.com>
#        www.patrick.eti.br
#
conf=""
mode=all
ethdev=""

vlan_tun=""
client_vlan_ipv4=""
client_vlan_ipv6=""
client_ipv4addr=""
client_ipv6addr=""
client_macaddr=""

_help(){
    echo "Testar participante de ponto de troca de trafego"
    echo
    echo "Use:"
    echo "$0 dev=ethX vlan4=NNN vlan6=NNN vlant=NNN ipv4=x.x.x.x ipv6=x::x mode=MMMM"
    echo
    echo "Opcoes:"
    echo "    conf=CFGFILE        Arquivo com configuracoes de teste"
    echo "    dev=DDD             Interface de rede do teste"
    echo "    mode=MMM            Modo do teste, padrao 'all', modos:"
    echo "                            all: Faz todos os testes"
    echo "                            arp: Faz testes de ARP"
    echo "                            mac: Faz testes de aprendizado de MAC"
    echo "                            pingflood: Faz testes de pps usando ping ICMP e ICMPv6"
    echo "                            flood: Envia trafego para inundar link do cliente"
    echo
    echo "    vlant=T:NNN         Informe a VLAN de transporte QinQ caso use, sintaxe: tipo:vid"
    echo "                           Tipo: 1q ou 1ad"
    echo "                           Exemplos simples: 1q:700, 1ad:2912"
    echo "                           Exemplos empilhados: 1ad:3444/1q:2999"
    echo
    echo "    vlan4=NNN           Informe a VLAN de IPv4 caso use"
    echo "    vlan6=NNN           Informe a VLAN de IPv6 caso use"
    echo
    echo "    ipv4=x.x.x.x        Informe o IPv4 do cliente"
    echo "    ipv6=x::x           Informe o IPv6 do cliente"
    echo "    mac=x:x:x:a:b:c     Informe o MAC-Address do cliente"
    echo
    exit 1
}
_abort(){ echo "Erro: $@"; exit 2; }

# Incluir arquivos
    # - bibliotecas
    [ -f lib.sh ] || _abort "Falha: lib.sh nao existe [$(pwd)]"
    . ./lib.sh

    # - configuracao local do servidor de testes
    [ -f "ix.conf" ] || _abort "Falha: ix.conf nao existe [$(pwd)]"
    . ./ix.conf

    # - configuracao padrao do cliente
    [ -f "client.conf" ] || _abort "Falha: client.conf nao existe [$(pwd)]"
    . ./client.conf


# Processar argumentos
while true; do
	# fim dos argumentos
	[ "x$1" = "x" ] && break
	[ "$1" = "h" -o "$1" = "help" -o "$1" = "-h" -o "$1" = "-help" -o "$1" = "--help" ] && _help
	# variaveis expontaneas
	[ -d "/sys/class/net/$1" ] && dev="$1" && shift && continue
	if [ -f "$1" ]; then
	    conf="$1"
	    [ -f "$conf" ] || _abort "Arquivo de configuracao nao encontrado: '$conf' [$(pwd)]"
	    . $conf
	    shift
	    continue
	fi
	# parametros
	optvar=$(echo "$1" | cut -f1 -d= -s); optvle=$(echo "$1" | cut -f2 -d= -s)
	echo "OPTVAR[$optvar] OPTVLE=[$optvle]"
	[ "$optvar" = "dev" ] && dev="$optvle" && shift && continue
	[ "$optvar" = "vlant" ] && vlan_tun="$optvle" && shift && continue
	[ "$optvar" = "vlan4" ] && client_vlan_ipv4="$optvle" && shift && continue
	[ "$optvar" = "vlan6" ] && client_vlan_ipv6="$optvle" && shift && continue
	[ "$optvar" = "ipv4" ] && client_ipv4addr="$optvle" && shift && continue
	[ "$optvar" = "ipv6" ] && client_ipv6addr="$optvle" && shift && continue
	[ "$optvar" = "mac" ] && client_macaddr="$optvle" && shift && continue
	[ "$optvar" = "mode" ] && mode="$optvle" && shift && continue
	[ "$optvar" = "dev" ] && dev="$optvle" && shift && continue

	if [ "$optvar" = "conf" ]; then
	    conf="$optvle"
	    [ -f "$conf" ] || _abort "Arquivo de configuracao nao encontrado: '$conf' [$(pwd)]"
	    . $conf
	    shift
	    continue
	fi
    done

# Padrao
    mtuipv6=$mtuipv4

# Criticar argumentos
    [ "x$dev" = "x" ] && _abort "Informe a interface"
    [ -d "/sys/class/net/$dev" ] || _abort "Interface '$dev' nao existe"
    [ "x$client_ipv4addr" = "x" ] && _abort "Informe o endereco IPv4 do cliente"
    [ "x$client_ipv6addr" = "x" ] && _abort "Informe o endereco IPv6 do cliente"
    [ "x$client_macaddr" = "x" ] && _abort "Informe o endereco MAC do cliente"

# Criticar ambiente
    _echon "Verificando comandos "
    _have_tools; sn="$?"
    if [ "$sn" = "0" ]; then
	_echosuc
    else
	_fail_abort "Ferramentas nao encontradas: [$TOOLNOTFOUND]" 42
    fi

echo
_echo_lighgreen  " IX Tools - Script de teste de ambiente"
echo
_echo_lighcyan_n "   Interface de rece local: "; _echo_lighpink "$dev"
_echo_lighcyan_n "                 MTU IPv4.: "; _echo_lighpink "$mtuipv4"
_echo_lighcyan_n "                 MTU IPv6.: "; _echo_lighpink "$mtuipv6"
_echo_lighcyan_n "              IPv4 Prefix.: "; _echo_lighpink "$v4prefix"
_echo_lighcyan_n "              IPv4 Local..: "; _echo_lighpink "$ipv4local"
echo
_echo_lighcyan_n "              IPv6 Prefix.: "; _echo_lighpink "$v6prefix"
_echo_lighcyan_n "              IPv6 Local..: "; _echo_lighpink "$ipv6local"
echo
_echo_lighcyan_n "         Local MAC Prefix.: "; _echo_lighpink "$macprefix"
_echo_lighcyan_n "         Local MAC Address: "; _echo_lighpink "$maclocal"
echo
_echo_lighgreen   " Cliente:"
_echo_lighcyan_n  "   VLAN de transporte.....: "; _echo_lighyellow "$vlan_tun"
_echo_lighcyan_n  "   MAC Address do cliente.: "; _echo_lighyellow "$client_macaddr [$(_macowner $client_macaddr)]"
_echo_lighcyan_n  "   VLAN do cliente - IPv4.: "; _echo_lighyellow "$client_vlan_ipv4"
_echo_lighcyan_n  "                     IPv4.: "; _echo_lighyellow "$client_ipv4addr"
echo
_echo_lighcyan_n  "   VLAN do cliente - IPv6.: "; _echo_lighyellow "$client_vlan_ipv6"
_echo_lighcyan_n  "                     IPv6.: "; _echo_lighyellow "$client_ipv6addr"
echo
echo


# Limpar interface
    _echon "Limpando interface '$dev' "
	(
	# remover enderecos, vlans, ipv6, etc... LIMPAR GERAL NA INTERFACE
	ip addr flush dev $dev; ip -6 addr flush dev $dev
	# remover vlans
	vdevs=$(cat /proc/net/vlan/config| awk '{print $1}' | egrep "$dev\.")
	for i in 1 2 3; do for v in $vdevs; do ip link del dev $v; done; done
	ifconfig $dev up
	) 2>/dev/null 1>/dev/null
    _echo_success

# Atribuir MAC local
    if [ "x$maclocal" != "x" ]; then
	_echon "Atribuindo mac '$maclocal' interface '$dev' "
	ip link set address "$maclocal" dev "$dev" 2>/dev/null; sn="$?"
	[ "$sn" = "0" ] || _fail_abort "Erro $sn ao atribuir mac '$maclocal' na interface '$dev'"
	_echo_success
    fi

# Aplicar MTU de producao
    _echon " > Ajustando MTU "
	# aplicar maior MTU possivel
	#-for maxmtu in 12000 96000 9000 8000 7000 6000 5000 4000 3000 2000 1600 1530 1528 1526 1524 1516 1500; do
	#-	ifconfig $dev mtu $maxmtu 2>/dev/null && break
	#-done
	#-echoc -n "(max mtu $maxmtu)"
	ifconfig $dev mtu $mtuipv4 2>/dev/null; sn="$?"
	[ "x$sn" = "x0" ] || _fail_abort "Falhou ao definir MTU em $mtuipv4 ifcfg-err=$sn" 11
	_echo_lighgreen_n " (official mtu $mtuipv4)"
	ip link set up dev $dev promisc on 2>/dev/null
    _echo_success


# Configurando VLANS

    # VLANS DE TRANSPORTE
    masterdev="$dev"
    if [ "x$vlan_tun" != "x" ]; then
	_echo " > Criando VLAN de transporte"
	tmp=$(echo $vlan_tun | sed 's#\/# #g')
	for v in $tmp; do
	    proto=$(echo $v | cut -f1 -d: -s)
	    vid=$(echo $v | cut -f2 -d: -s)
	    e=q
	    [ "$proto" = "1q" -o "$proto" = "8021q" -o "$proto" = "q" ] && proto="802.1q" && e=q
	    [ "$proto" = "1ad" -o "$proto" = "8021ad" -o "$proto" = "ad" -o "$proto" = "a" ] && proto="802.1ad" && e=a
	    [ "$proto" = "802.1q" -o "$proto" = "802.1ad" ] || _abort "Protocolo desconhecido: $proto"
	    vdev="$masterdev.$e$vid"
	    _echon "   - $masterdev proto $proto vid $vid ==> $vdev "
	    vcmd="ip link add link $masterdev name $vdev type vlan proto $proto id $vid"
	    xerr=$(eval "$vcmd" 2>/dev/null 1>/dev/null); sn="$?"
	    [ "$sn" = "0" ] || _fail_abort "Erro $sn ao criar VLAN ($vcmd)"
	    ifconfig $vdev up 2>/dev/null; ip link set up dev $vdev 2>/dev/null
	    ifconfig $vdev mtu $mtuipv4 2>/dev/null; sn="$?"
	    [ "x$sn" = "x0" ] || _fail_abort "Falhou ao definir MTU em $mtuipv4 na $vdev ifcfg-err=$sn" 11
	    masterdev="$vdev"
	    ip link set up dev $vdev promisc on 2>/dev/null
	    _echo_success
	done
    fi

    # VLANS DO CLIENTE
    # IPv4
    v4dev="$masterdev"
    if [ "x$client_vlan_ipv4" = "x" ]; then
	# Sem vlan especifica para IPv4
	_echo " ! IPv4 sem vlan propria, interface '$v4dev'"
    else
	# Criar vlan IPv4
	_echon " > Criando VLAN para IPv4"
	v4dev="$dev.$client_vlan_ipv4"
	vcmd="ip link add link $masterdev name $v4dev type vlan proto 802.1q id $client_vlan_ipv4"
	xerr=$(eval "$vcmd" 2>/dev/null 1>/dev/null); sn="$?"
	[ "$sn" = "0" ] || _fail_abort "Erro $sn ao criar VLAN IPv4 ($vcmd)"
	ifconfig $v4dev up 2>/dev/null; ip link set up dev $v4dev 2>/dev/null
	ifconfig $v4dev mtu $mtuipv4 2>/dev/null; sn="$?"
	[ "x$sn" = "x0" ] || _fail_abort "Falhou ao definir MTU em $mtuipv4 na $v4dev ifcfg-err=$sn" 11
	_echo_lighgreen_n " ($v4dev on $masterdev)"
	ip link set up dev $v4dev promisc on 2>/dev/null
	_echo_success
    fi
    # IPv6
    v6dev="$masterdev"
    if [ "x$client_vlan_ipv6" = "x" ]; then
	# Sem vlan especifica para IPv6
	_echo " ! IPv6 sem vlan propria, interface '$v6dev'"
    else
	# Criar vlan IPv6
	_echon " > Criando VLAN para IPv6"
	v6dev="$dev.$client_vlan_ipv6"
	vcmd="ip link add link $masterdev name $v6dev type vlan proto 802.1q id $client_vlan_ipv6"
	xerr=$(eval "$vcmd" 2>/dev/null 1>/dev/null); sn="$?"
	[ "$sn" = "0" ] || _fail_abort "Erro $sn ao criar VLAN IPv6 ($vcmd)"
	ifconfig $v6dev up 2>/dev/null; ip link set up dev $v6dev 2>/dev/null
	ifconfig $v6dev mtu $mtuipv6 2>/dev/null 1>/dev/null; sn="$?"
	[ "x$sn" = "x0" ] || _fail_abort "Falhou ao definir MTU em $mtuipv6 na $v6dev ifcfg-err=$sn" 11
	_echo_lighgreen_n " ($v6dev on $masterdev)"
	ip link set up dev $v6dev promisc on 2>/dev/null
	_echo_success
    fi

# - IP local
	_echon " > Ativando enderecos locais "

	# ipv4
	prefixlen4=$(echo $v4prefix | cut -f2 -d'/')
	v4addr="$ipv4local/$prefixlen4"
	ip addr add $v4addr brd + dev $v4dev 2>/dev/null; sn="$?"
	[ "$sn" = "0" ] || _fail_abort "Erro $sn ao adicionar IPv4 $v4addr em $v4dev"
	_echo_lighgreen_n " ($v4addr)"

	# ipv6
	prefixlen6=$(echo $v6prefix | cut -f2 -d'/')
	v6addr="$ipv6local/$prefixlen6"
	ip -6 addr add $v6addr dev $v6dev 2>/dev/null; sn="$?"
	[ "$sn" = "0" ] || _fail_abort "Erro $sn ao adicionar IPv6 $v6addr em $v6dev"
	_echo_lighgreen_n " ($v6addr)"
	_echo_success

echo
_echo_lighgreen   " Iniciando homologacao"
#usleep 500000
echo

# Iniciar geracao de relatorio
    mkdir -p $HERE/output 2>/dev/null
    repfile="$HERE/output/$(date "+%Y-%m-%d-%H%M%S").txt"
    echo -n > $repfile
#----------------------------------------------------------------------- IPv4 ARP-Ping
	_echon "TEST :: Ping ARP IPv4 para $client_ipv4addr "
	#arping -I $v4dev -c 2 "$client_ipv4addr" 2>/dev/null 1>/dev/null; sn="$?"
	arping -I $v4dev -c 1 "$client_ipv4addr" 2>/dev/null 1>/dev/null; sn="$?"
	if [ "$sn" = "0" ]; then
	    _echo_good
	else
	    _echo_bad
	fi
	echo "ipv4arping;$sn;$client_ipv4addr" >> $repfile
#----------------------------------------------------------------------- IPv4 Ping
	_echon "TEST :: Ping ICMP IPv4 para $client_ipv4addr "
	ping -c 1 "$client_ipv4addr" 2>/dev/null 1>/dev/null; sn="$?"
	if [ "$sn" = "0" ]; then
	    _echo_good
	else
	    _echo_bad
	fi
	echo "ipv4ping;$sn;$client_ipv4addr" >> $repfile
#----------------------------------------------------------------------- IPv4 ARP e MAC-MATCH
	_echon "TEST :: ARP-MAC de $client_ipv4addr "
	v4mac=$(ip nei show $client_ipv4addr | sed 's#lladdr#/#g' | cut -f2 -d'/' | awk '{print $1}')
	sn=0
	if [ "x$v4mac" = "x" ]; then
	    _echo_bad
	    sn=1
	else
	    _echo_lighgreen_n " (mac=$v4mac)"
	    _echo_good
	fi
	echo "ipv4arpmac;$sn;$client_ipv4addr" >> $repfile

	# Comparar macs
	rmac=$(echo $client_macaddr | tr '[:lower:]' '[:upper:]')
	amac=$(echo $v4mac | tr '[:lower:]' '[:upper:]')
	_echon "TEST :: MAC check "
	sn=0
	if [ "x$rmac" = "x$amac" ]; then
	    _echo_lighgreen_n "($amac)"
	    _echo_good
	else
	    _echo_lighyellow_n "($amac != $rmac)"
	    _echo_bad
	    sn=1
	fi
	v4mac="$amac"
	echo "ipv4macmatch;$sn;$client_macaddr/$v4mac" >> $repfile

#----------------------------------------------------------------------- Ping paralelo
    #for xcount in 10 50 100 200 400 600 800 1000 2000 3000 4000 5000 6000 7000 8000 9000 10000; do
    for xcount in 10 50 100 200 400 600 800 1000; do
    #for xcount in 10 50 100 200 400; do
	_echon "TEST :: Paralel Ping $xcount para $client_ipv4addr "

	out=$(fping $client_ipv4addr -b 1440 -c $xcount -e -H 1 -i 1 -q -p 1 -R 2>&1 | cut -f2 -d= | cut -f1 -d'%')
	out=$(echo $out)
	loss=$(echo $out | cut -f3 -d'/')
	
	if [ "$loss" = "0" ]; then
	    echo "ipv4ping$xcount;$client_ipv4addr/$out" >> $repfile
	    _echo_lighgreen_n "(loss $loss %)"
	    _echo_good
	else
	    echo "ipv4ping$xcount;$client_ipv4addr/$out" >> $repfile
	    _echo_lighyellow_n "(loss $loss %)"
	    echo_bad
	fi
    done

#----------------------------------------------------------------------- Flood ARP-Request
#
    # Gerar lista de ips na rede IPv4
    _echon "TEST :: Gerando lista de IPs ($v4prefix) "
    v4tmplist="/tmp/ixtools-v4list-$RANDOM"
    echo -n > $v4tmplist
    v4net=$(echo $v4prefix | cut -f1 -d'/')
    v4bits=$(echo $v4prefix | cut -f2 -d'/')
    v4subnets=$(_ipv4subnets $v4bits)
    [ "$v4subnets" -lt "1" ] && _abort "Falha ao calcular subnets"
    v4a=$(echo $v4net | cut -f1 -d.)
    v4b=$(echo $v4net | cut -f2 -d.)
    v4c=$(echo $v4net | cut -f3 -d.)
    v4x=$(($v4c+$v4subnets))
    v4x=$(($v4x-1))
    v4count=0
    #echo -n "[seq $v4c 1 $v4x]"
    for snet in $(seq $v4c 1 $v4x); do
	_echon "."
	for v4d in $(seq 0 1 255); do
		ip="$v4a.$v4b.$snet.$v4d"
		echo "$ip" >> $v4tmplist
		v4count=$(($v4count+1))
	done
    done
    _echon "($v4count)"
    
    # remover da lista:
    # - ip local
    # - ip do cliente
    tmp="/tmp/ixtools-tmp-$RANDOM"
    cat $v4tmplist | while read x; do
	[ "$x" = "$client_ipv4addr" ] && continue
	[ "$x" = "$ipv4local" ] && continue
	echo $x
    done > $tmp
    cat $tmp > $v4tmplist
    rm $tmp 2>/dev/null

    # Gerar um MAC falso para cada IP
    v4maclist="/tmp/ixtools-v4mac-$RANDOM"
    echo -n > $v4maclist
    macp="$macprefix:00"
    ma=10
    mb=10
    for ip in $(cat $v4tmplist); do
	mac="$macp:${ma:(-2)}:${mb:(-2)}"
	echo "$ip;$mac" >> $v4maclist
	mb=$(($mb+1))
	[ "$mb" -ge "99" ] && mb=10 && ma=$(($ma+1))
    done

    echo_success


    _echon "TEST :: ARP-Request Flood to $client_macaddr (demora) "
    
    for ipmac in $(cat $v4maclist); do
	ip=$(echo $ipmac | cut -f1 -d';')
	mac=$(echo $ipmac | cut -f2 -d';')
	$HERE/tools/arp-send.sh $v4dev \
	    $client_ipv4addr $ip \
	    $mac $client_macaddr \
	&& continue
    done
    echo_success

echo; echo; echo; echo
echo "Relatorio:"
cat $repfile
echo

