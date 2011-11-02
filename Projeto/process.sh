#!/bin/bash

PROTOCOL=TCP
SIZE=512
CONF=$PROTOCOL_$SIZE

#rm out*
ns scripts/script1.tcl
clear
#echo Número Total de Pacotes Enviados `cat out.tr | grep ^+ | wc -l` > report.txt
awk -f fluxo_sum.awk -v FID=1 out.tr > report.txt

cat report.txt
cat report.txt >> sumarize.txt
echo '------' >> sumarize.txt

# 
awk -f awk/fluxo.awk -v FID=1 out.tr | awk '{print $5" "$2}' > delay_pacotes_tempo_$CONF.txt
mv delay_pacotes_tempo_$CONF.txt dados/

# Tempo X Taxa Transmissao
awk -f awk/fluxo.awk -v FID=1 out.tr | awk '{print $5" "$12}' > banda_tempo_$CONF.txt
mv banda_tempo_$CONF.txt dados/