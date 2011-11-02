# Tarcisio Coutinho
# Centro de Informática - UFPE
# 
# Redes de Computadores - 2011.2


# Parametros Camada Transporte
#
# packetSize: Tamanho pacote (TCP e UDP)
# ttl: Time-to-live (TCP e UDP)
# windowSize: Janela de conexao TCP (Numero de pacotes)
# cwnd: Janela de congestionamento TCP (Numero de pacotes)
# windowInit: Janela inicial de congestionamento TCP
# maxBurst: Numero maximo de pacotes que o emissor pode enviar ao responder a um ACK

set packetSize 1000
set ttl 32
set windowSize 20
set cwnd 0
set windowInit 1
set maxBurst 10


# Parametros Camada Aplicacao
#
# rate: Taxa de envio de pacotes (CBR - Constant Bit Rate)
# interval: Intervalo de envio dos pacotes
# cbrPacketSize: Tamanho dos pacotes
# maxPackets: Numero maximo de pacotes gerados pela fonte (FTP)

set rate 448kb
set interval 0.005
set cbrPacketSize 500
set maxPackets 10000

# Cria um objeto simulator
set ns [new Simulator]

# Cores para os fluxos de dados ($ns color fid color) - fid: id do fluxo
$ns color 1 Blue
$ns color 2 Red

#Trace file
set tr [open out.tr w]
#set nf [open out.nam w]

# diz ao simulador para gravar os caminhos da simulação no formato de entrada do NAM
# $ns namtrace-all file-descriptor
$ns trace-all $tr
#$ns namtrace-all $nf


#Finish procedure
proc finish {} {
	global ns tr
#	global nf
	$ns flush-trace
	
#	close $nf
	close $tr
	
	#Executa animador
#	exec nam out.nam &
	exit 0
}

# Topology
#               n0 (tcp) (ftp)
# 2mbps, 10ms    \                           
#                 \     1.7 mbps, 20ms    (sink) - Receiver TCP
#                 n2 ----------------- n3 (null) - Receiver UDP
# 2mbps, 10ms     /
#                /
#               n1 (udp) (cbr) pkt size: 1kbyte, rate 1mbps
#             
#
#           +ftp                           -ftp
#    +cbr                                        -cbr
#  +--------+---------+----------+---------+-----+----+ 
#  0        1         2          3         4    4.5   5



#Create nodes
set n0 [$ns node]
set n1 [$ns node]
set n2 [$ns node]
set n3 [$ns node]

#Create links ($ns duplex-link node1 node2 bandwidth delay queue-type)
$ns duplex-link $n0 $n2 2Mb 10ms DropTail
$ns duplex-link $n1 $n2 2Mb 10ms DropTail
$ns duplex-link $n2 $n3 1.7Mb 20ms DropTail

$ns duplex-link-op $n0 $n2 orient right-down
$ns duplex-link-op $n1 $n2 orient right-up
$ns duplex-link-op $n2 $n3 orient right

#Tamanho da Fila (n2-n3) ($ns queue-limit node1 node2 number)
$ns queue-limit $n2 $n3 10

#Monitor da fila (n2-n3)
$ns duplex-link-op $n2 $n3 queuePos 0.5

#Setup TCP
set tcp [new Agent/TCP]

$tcp set class_ 2
$tcp set fid_ 1
$tcp set packetSize_ $packetSize
$tcp set ttl_ $ttl
$tcp set window_ $windowSize
$tcp set cwnd_ $cwnd
$tcp set windowInit_ $windowInit
$tcp set maxburst_ $maxBurst

$ns attach-agent $n0 $tcp
#Agente n3 (receiver)
set sink [new Agent/TCPSink]
# $ns attach-agent node agent
$ns attach-agent $n3 $sink
#Conexao entre eles ($ns connect agent1 agent2)
$ns connect $tcp $sink

#Setup UDP 
set udp [new Agent/UDP]
$ns attach-agent $n1 $udp

set null [new Agent/Null]
$ns attach-agent $n3 $null

#Conxao entre eles
$ns connect $udp $null
$udp set fid_ 2
$udp set packetSize_ $packetSize
$udp set ttl_ $ttl



#Application

#Setup FTP over TCP
set ftp [new Application/FTP]
$ftp attach-agent $tcp
$ftp set type_ FTP
$ftp set maxpkts_ $maxPackets

#Setup CBR(Constant bit-rate)  over UDP
set cbr [new Application/Traffic/CBR]
$cbr attach-agent $udp
$cbr set type_ CBR
$cbr set rate_ $rate
$cbr set interval_ $interval
$cbr set packetSize_ $cbrPacketSize

#Programando eventos
$ns at 0.1 "$cbr start"
$ns at 10.0 "$ftp start"
$ns at 20.0 "$ftp stop"
$ns at 30.0 "$cbr stop"

#desligar agentes Tcp e Sink
$ns at 32.0 "$ns detach-agent $n0 $tcp ; $ns detach-agent $n3 $sink"

#chamar metodo finish
$ns at 35 "finish"

#Executar simulacao
$ns run
