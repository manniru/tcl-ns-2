#!/bin/bash

#rm out*
ns scripts/script1.tcl
clear
#echo Número Total de Pacotes Enviados `cat out.tr | grep ^+ | wc -l` > report.txt
awk -f fluxo_sum.awk -v FID=1 out.tr > report.txt
awk -f genthroughput_sum.awk out.tr >> report.txt

cat report.txt
cat report.txt >> sumarize.txt
echo '------' >> sumarize.txt
