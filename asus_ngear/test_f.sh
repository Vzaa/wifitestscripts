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

run_test_2() {
    dut=$1
    ch=$2
    bw=$3
    ant=$4
    ttype=$5
    vht=$6
    sinkipa=$7

    band="2g"

    exec_cmd $dut down
    exec_cmd $dut up24
    exec_cmd $dut 24chbw $ch $bw
    exec_cmd $dut 24_${ant}

    sleep 3
    test_ping $sinkip
    if [[ $ttype == "tcp" ]]; then
        iperf -c $sinkipa -i1 -t${IPERFDUR} -P 5 > "$LOGDIR/${sinkipa}_${band}_${bw}_${ant}_${ttype}_${vht}.log" 
    elif [[ $ttype == "udp" ]]; then
        iperf -c $sinkipa -i1 -t${IPERFDUR} -u -b 800m > "$LOGDIR/${sinkipa}_${band}_${bw}_${ant}_${ttype}_${vht}.log" 
    fi
    sleep 5
}

run_test_dual_2() {
    dut=$1
    ch=$2
    bw=$3
    ant=$4
    ttype=$5
    vht=$6
    sinkipa=$7
    sinkipb=$8

    band="2g"

    exec_cmd $dut down
    exec_cmd $dut up24
    exec_cmd $dut 24chbw $ch $bw
    exec_cmd $dut 24_${ant}

    sleep 3
    test_ping $sinkipa
    test_ping $sinkipb
    if [[ $ttype == "tcp" ]]; then
        iperf -c $sinkipa -i1 -t${IPERFDUR} -P 5 > "$LOGDIR/dual_a_${sinkipa}_${sinkipb}_${band}_${bw}_${ant}_${ttype}_${vht}.log" &
        iperf -c $sinkipb -i1 -t${IPERFDUR} -P 5 > "$LOGDIR/dual_b_${sinkipa}_${sinkipb}_${band}_${bw}_${ant}_${ttype}_${vht}.log" 
    elif [[ $ttype == "udp" ]]; then
        iperf -c $sinkipa -i1 -t${IPERFDUR} -u -b 800m > "$LOGDIR/dual_a_${sinkipa}_${sinkipb}_${band}_${bw}_${ant}_${ttype}_${vht}.log" &
        iperf -c $sinkipb -i1 -t${IPERFDUR} -u -b 800m > "$LOGDIR/dual_b_${sinkipb}_${sinkipb}_${band}_${bw}_${ant}_${ttype}_${vht}.log"
    fi
    sleep 5
}

run_test_trip_2() {
    dut=$1
    ch=$2
    bw=$3
    ant=$4
    ttype=$5
    vht=$6
    sinkipa=$7
    sinkipb=$8
    sinkipc=$9

    band="2g"

    exec_cmd $dut down
    exec_cmd $dut up24
    exec_cmd $dut 24chbw $ch $bw
    exec_cmd $dut 24_${ant}

    sleep 3
    test_ping $sinkipa
    test_ping $sinkipb
    test_ping $sinkipc
    if [[ $ttype == "tcp" ]]; then
        iperf -c $sinkipa -i1 -t${IPERFDUR} -P 5 > "$LOGDIR/trip_a_${sinkipa}_${sinkipb}_${sinkipc}_${band}_${bw}_${ant}_${ttype}_${vht}.log" &
        iperf -c $sinkipb -i1 -t${IPERFDUR} -P 5 > "$LOGDIR/trip_b_${sinkipa}_${sinkipb}_${sinkipc}_${band}_${bw}_${ant}_${ttype}_${vht}.log" &
        iperf -c $sinkipc -i1 -t${IPERFDUR} -P 5 > "$LOGDIR/trip_c_${sinkipa}_${sinkipb}_${sinkipc}_${band}_${bw}_${ant}_${ttype}_${vht}.log" 
    elif [[ $ttype == "udp" ]]; then
        iperf -c $sinkipa -i1 -t${IPERFDUR} -u -b 800m > "$LOGDIR/trip_a_${sinkipa}_${sinkipb}_${sinkipc}_${band}_${bw}_${ant}_${ttype}_${vht}.log" &
        iperf -c $sinkipb -i1 -t${IPERFDUR} -u -b 800m > "$LOGDIR/trip_b_${sinkipa}_${sinkipb}_${sinkipc}_${band}_${bw}_${ant}_${ttype}_${vht}.log" &
        iperf -c $sinkipc -i1 -t${IPERFDUR} -u -b 800m > "$LOGDIR/trip_c_${sinkipa}_${sinkipb}_${sinkipc}_${band}_${bw}_${ant}_${ttype}_${vht}.log" 
    fi
    sleep 5
}

run_test_5() {
    dut=$1
    ch=$2
    bw=$3
    ant=$4
    ttype=$5
    vht=$6
    sinkipa=$7

    band="5g"

    if [[ $vht == "ac" ]]; then
        exec_cmd $dut ac_on
    elif [[ $vht == "n" ]]; then
        exec_cmd $dut ac_off
    fi

    exec_cmd $dut down24
    exec_cmd $dut up
    exec_cmd $dut chbw $ch $bw
    exec_cmd $dut $ant

    sleep 3
    test_ping $sinkip
    if [[ $ttype == "tcp" ]]; then
        iperf -c $sinkipa -i1 -t${IPERFDUR} -P 5 > "$LOGDIR/${sinkipa}_${band}_${bw}_${ant}_${ttype}_${vht}.log" 
    elif [[ $ttype == "udp" ]]; then
        iperf -c $sinkipa -i1 -t${IPERFDUR} -u -b 800m > "$LOGDIR/${sinkipa}_${band}_${bw}_${ant}_${ttype}_${vht}.log" 
    fi
    sleep 5
}

run_test_dual_5() {
    dut=$1
    ch=$2
    bw=$3
    ant=$4
    ttype=$5
    vht=$6
    sinkipa=$7
    sinkipb=$8

    band="5g"

    if [[ $vht == "ac" ]]; then
        exec_cmd $dut ac_on
    elif [[ $vht == "n" ]]; then
        exec_cmd $dut ac_off
    fi

    exec_cmd $dut down24
    exec_cmd $dut up
    exec_cmd $dut chbw $ch $bw
    exec_cmd $dut $ant
    sleep 3
    test_ping $sinkipa
    test_ping $sinkipb
    if [[ $ttype == "tcp" ]]; then
        iperf -c $sinkipa -i1 -t${IPERFDUR} -P 5 > "$LOGDIR/dual_a_${sinkipa}_${sinkipb}_${band}_${bw}_${ant}_${ttype}_${vht}.log" &
        iperf -c $sinkipb -i1 -t${IPERFDUR} -P 5 > "$LOGDIR/dual_b_${sinkipa}_${sinkipb}_${band}_${bw}_${ant}_${ttype}_${vht}.log" 
    elif [[ $ttype == "udp" ]]; then
        iperf -c $sinkipa -i1 -t${IPERFDUR} -u -b 800m > "$LOGDIR/dual_a_${sinkipa}_${sinkipb}_${band}_${bw}_${ant}_${ttype}_${vht}.log" &
        iperf -c $sinkipb -i1 -t${IPERFDUR} -u -b 800m > "$LOGDIR/dual_b_${sinkipb}_${sinkipb}_${band}_${bw}_${ant}_${ttype}_${vht}.log"
    fi
    sleep 5
}

run_test_trip_5() {
    dut=$1
    ch=$2
    bw=$3
    ant=$4
    ttype=$5
    vht=$6
    sinkipa=$7
    sinkipb=$8
    sinkipc=$9

    band="5g"

    if [[ $vht == "ac" ]]; then
        exec_cmd $dut ac_on
    elif [[ $vht == "n" ]]; then
        exec_cmd $dut ac_off
    fi

    exec_cmd $dut down24
    exec_cmd $dut up
    exec_cmd $dut chbw $ch $bw
    exec_cmd $dut $ant
    sleep 3
    test_ping $sinkipa
    test_ping $sinkipb
    test_ping $sinkipc
    if [[ $ttype == "tcp" ]]; then
        iperf -c $sinkipa -i1 -t${IPERFDUR} -P 5 > "$LOGDIR/trip_a_${sinkipa}_${sinkipb}_${sinkipc}_${band}_${bw}_${ant}_${ttype}_${vht}.log" &
        iperf -c $sinkipb -i1 -t${IPERFDUR} -P 5 > "$LOGDIR/trip_b_${sinkipa}_${sinkipb}_${sinkipc}_${band}_${bw}_${ant}_${ttype}_${vht}.log" &
        iperf -c $sinkipc -i1 -t${IPERFDUR} -P 5 > "$LOGDIR/trip_c_${sinkipa}_${sinkipb}_${sinkipc}_${band}_${bw}_${ant}_${ttype}_${vht}.log" 
    elif [[ $ttype == "udp" ]]; then
        iperf -c $sinkipa -i1 -t${IPERFDUR} -u -b 800m > "$LOGDIR/trip_a_${sinkipa}_${sinkipb}_${sinkipc}_${band}_${bw}_${ant}_${ttype}_${vht}.log" &
        iperf -c $sinkipb -i1 -t${IPERFDUR} -u -b 800m > "$LOGDIR/trip_b_${sinkipa}_${sinkipb}_${sinkipc}_${band}_${bw}_${ant}_${ttype}_${vht}.log" &
        iperf -c $sinkipc -i1 -t${IPERFDUR} -u -b 800m > "$LOGDIR/trip_c_${sinkipa}_${sinkipb}_${sinkipc}_${band}_${bw}_${ant}_${ttype}_${vht}.log" 
    fi
    sleep 5
}

PORT=12345
IPERFDUR=10

DUTA="192.168.1.101"
SINKA="192.168.1.22"
SINKB="192.168.1.177"
SINKC="192.168.1.178"

LOGDIR=$1
if [ -x "$LOGDIR" ]; then
    echo $LOGDIR exists, quting..
    exit
fi

mkdir $LOGDIR

run_test_5      $DUTA 48 80 3x3 tcp ac $SINKA
run_test_5      $DUTA 48 80 3x3 tcp ac $SINKB
run_test_5      $DUTA 48 80 3x3 tcp ac $SINKC

run_test_dual_5 $DUTA 48 80 3x3 tcp ac $SINKA $SINKB
run_test_dual_5 $DUTA 48 80 3x3 tcp ac $SINKA $SINKC
run_test_dual_5 $DUTA 48 80 3x3 tcp ac $SINKB $SINKC

run_test_trip_5 $DUTA 48 80 3x3 tcp ac $SINKA $SINKB $SINKC
