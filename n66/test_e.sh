#!/bin/bash

test_ping() {
    IP=$1
    res=1
    for try in {1..40}; do
        ping -c 1 $IP
        res=$?
        if [ $res -eq "0" ]; then
            break
        fi
        echo cannot ping $IP, trying again in 5 seconds...
        sleep 5
    done

}

exec_cmd() {
    echo $*
    cmd="$2 $3 $4 $5 $6"
    res=1
    while [ $res -ne "0" ]; do
        echo $cmd | nc -w 1 $1 $PORT
        res=$?
    done
}

run_test() {
    for cur_pwr in $PWR_LEVELS; do 
        exec_cmd $DUTA pwr $cur_pwr
        sleep 3
        res=1
        test_ping $SINKIP
        exec_cmd $DUTA start_rssi $STA_MAC
        iperf -c $SINKIP -i1 -t${IPERFDUR} -P 5 > "$LOGDIR/${bf}_${band}_${bw}_${cur_pwr}_${ant}.log"
        exec_cmd $DUTA stop_rssi
        sleep 5
        nc $DUTA 1234 > "$LOGDIR/${bf}_${band}_${bw}_${cur_pwr}_${ant}_rssi.log"
        sleep 1
    done
}

run_test_24() {
    for cur_pwr in $PWR_LEVELS; do 
        exec_cmd $DUTA 24pwr $cur_pwr
        sleep 3
        res=1
        test_ping $SINKIP
        exec_cmd $DUTA 24_start_rssi $STA_MAC
        iperf -c $SINKIP -i1 -t${IPERFDUR} -P 5 > "$LOGDIR/${bf}_${band}_${bw}_${cur_pwr}_${ant}.log"
        exec_cmd $DUTA stop_rssi
        sleep 5
        nc $DUTA 1234 > "$LOGDIR/${bf}_${band}_${bw}_${cur_pwr}_${ant}_rssi.log"
        sleep 1
    done
}

DUTA="192.168.1.1"
PORT=12345
SINKIP="192.168.1.101"
#MYIP="192.168.2.100"
IPERFDUR=900
IFNAME=wl1

PWR_LEVELS="18 16 13 10"
STA_MAC="5C:F9:38:9B:FE:5C" # mac air
#STA_MAC="00:1C:BF:6F:A8:8C" # ibm thinkpad
#STA_MAC="all"

LOGDIR=$1
if [ -x "$LOGDIR" ]; then
    echo $LOGDIR exists, quting..
    exit
fi

mkdir $LOGDIR


#turn off 2.4 G
exec_cmd $DUTA down24


#No BF 3x3 20 MHz Power Levels 10, 13, 16, 20 dBm 5 GHz
bf="nobf"; bw="20"; band="5g"; ant="3x3"
exec_cmd $DUTA 3x3
exec_cmd $DUTA chbw 48 20
run_test

#No BF 2x2 20 MHz Power Levels 10, 13, 16, 20 dBm 5 GHz
bf="nobf"; bw="20"; band="5g"; ant="2x2"
exec_cmd $DUTA 2x2
exec_cmd $DUTA chbw 48 20
run_test

#No BF 1x1 20 MHz Power Levels 10, 13, 16, 20 dBm 5 GHz
bf="nobf"; bw="20"; band="5g"; ant="1x1"
exec_cmd $DUTA 1x1
exec_cmd $DUTA chbw 48 20
run_test

#Turn off 5 G
#Turn on 2.4 G 
exec_cmd $DUTA down
exec_cmd $DUTA up24
exec_cmd $DUTA 24chbw 1 20

#No BF 3x3 20 MHz Power Levels 10, 13, 16, 20 dBm 2.4 GHz
bf="nobf"; bw="20"; band="2g"; ant="3x3"
exec_cmd $DUTA 24_3x3
run_test_24

#No BF 2x2 20 MHz Power Levels 10, 13, 16, 20 dBm 2.4 GHz
bf="nobf"; bw="20"; band="2g"; ant="2x2"
exec_cmd $DUTA 24_2x2
run_test_24

#No BF 1x1 20 MHz Power Levels 10, 13, 16, 20 dBm 2.4 GHz
bf="nobf"; bw="20"; band="2g"; ant="1x1"
exec_cmd $DUTA 24_1x1
run_test_24
