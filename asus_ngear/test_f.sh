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
    ping -c 10 $IP

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
    sinkip=$1
    sleep 3
    test_ping $sinkip
    iperf -c $sinkip -i1 -t${IPERFDUR} -u -b 800m > "$LOGDIR/${sinkip}_${bf}_${band}_${bw}_${cur_pwr}_${ant}.log"
    #iperf -c $sinkip -i1 -t${IPERFDUR} -P 5 > "$LOGDIR/${sinkip}_${bf}_${band}_${bw}_${cur_pwr}_${ant}.log"
    sleep 5
}

run_test_dual() {
    sinkipa=$1
    sinkipb=$2
    sleep 3
    test_ping $sinkipa
    test_ping $sinkipb
    iperf -c $sinkipa -i1 -t${IPERFDUR} -u -b 800m > "$LOGDIR/dual_${sinkipa}_${bf}_${band}_${bw}_${cur_pwr}_${ant}.log" &
    iperf -c $sinkipb -i1 -t${IPERFDUR} -u -b 800m > "$LOGDIR/dual_${sinkipb}_${bf}_${band}_${bw}_${cur_pwr}_${ant}.log"
    #iperf -c $sinkipa -i1 -t${IPERFDUR} -P 5 > "$LOGDIR/dual_${sinkipa}_${bf}_${band}_${bw}_${cur_pwr}_${ant}.log" &
    #iperf -c $sinkipb -i1 -t${IPERFDUR} -P 5 > "$LOGDIR/dual_${sinkipb}_${bf}_${band}_${bw}_${cur_pwr}_${ant}.log"
    sleep 5
}

DUTA="192.168.1.101"
PORT=12345
SINKA="192.168.1.22"
SINKB="192.168.1.177"
#MYIP="192.168.2.100"
IPERFDUR=10

PWR_LEVELS="18"
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

#BF 3x3 80 MHz Power Levels 10, 13, 16, 20 dBm 5 GHz
bf="bf"; bw="80"; band="5g"; ant="3x3"
exec_cmd $DUTA bf_on
exec_cmd $DUTA chbw 48 80
exec_cmd $DUTA 3x3
run_test $SINKA
run_test $SINKB
run_test_dual $SINKA $SINKB

bf="bf"; bw="40"; band="5g"; ant="3x3"
exec_cmd $DUTA bf_on
exec_cmd $DUTA chbw 48 40
exec_cmd $DUTA 3x3
run_test $SINKA
run_test $SINKB
run_test_dual $SINKA $SINKB

bf="bf"; bw="20"; band="5g"; ant="3x3"
exec_cmd $DUTA bf_on
exec_cmd $DUTA chbw 48 20
exec_cmd $DUTA 3x3
run_test $SINKA
run_test $SINKB
run_test_dual $SINKA $SINKB

bf="bf"; bw="80"; band="5g"; ant="2x2"
exec_cmd $DUTA bf_on
exec_cmd $DUTA chbw 48 80
exec_cmd $DUTA 2x2
run_test $SINKA
run_test $SINKB
run_test_dual $SINKA $SINKB

bf="bf"; bw="40"; band="5g"; ant="2x2"
exec_cmd $DUTA bf_on
exec_cmd $DUTA chbw 48 40
exec_cmd $DUTA 2x2
run_test $SINKA
run_test $SINKB
run_test_dual $SINKA $SINKB

bf="bf"; bw="20"; band="5g"; ant="2x2"
exec_cmd $DUTA bf_on
exec_cmd $DUTA chbw 48 20
exec_cmd $DUTA 2x2
run_test $SINKA
run_test $SINKB
run_test_dual $SINKA $SINKB

bf="bf"; bw="80"; band="5g"; ant="1x1"
exec_cmd $DUTA bf_on
exec_cmd $DUTA chbw 48 80
exec_cmd $DUTA 1x1
run_test $SINKA
run_test $SINKB
run_test_dual $SINKA $SINKB

bf="bf"; bw="40"; band="5g"; ant="1x1"
exec_cmd $DUTA bf_on
exec_cmd $DUTA chbw 48 40
exec_cmd $DUTA 1x1
run_test $SINKA
run_test $SINKB
run_test_dual $SINKA $SINKB

bf="bf"; bw="20"; band="5g"; ant="1x1"
exec_cmd $DUTA bf_on
exec_cmd $DUTA chbw 48 20
exec_cmd $DUTA 1x1
run_test $SINKA
run_test $SINKB
run_test_dual $SINKA $SINKB
