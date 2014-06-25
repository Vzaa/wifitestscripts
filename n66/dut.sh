#!/bin/sh
IFNAME=eth2
IFNAME24=eth1
PORT=12345


log_rssi() {
    ifname=$1
    mac=$2
    logfile="/tmp/rssi.log"
    signalfl="/tmp/signal"
    rm $logfile

    while true;
    do
        #rssi=`wl -i ${ifname} sta_info ${mac} | grep rssi`
        rssi=`wl -i ${ifname} rssi ${mac}`
        nrate=`wl -i ${ifname} nrate`
        echo $rssi $nrate >> $logfile
        if [ -f $signalfl ] ; then
            rm $signalfl
            break
        fi
        sleep 3
    done

    cat $logfile | ./nc -c -l -p 1234 
}

set_power() {
    val=$2
    #wl -i ${IFNAME} down
    wl -i ${IFNAME} txpwr1 -d -o $val
    #wl -i ${IFNAME} up
}

set_power24() {
    val=$2
    #wl -i ${IFNAME24} down
    wl -i ${IFNAME24} txpwr1 -d -o $val
    #wl -i ${IFNAME24} up
}

set_ch_bw24() {
    ch=$2
    bw=$3
    wl -i ${IFNAME24} down
    #wl -i ${IFNAME} chanspec -c ${ch} -b $band -w $bw
    wl -i ${IFNAME24} chanspec ${ch}/${bw}
    wl -i ${IFNAME24} up
}

set_ch_bw() {
    ch=$2
    bw=$3
    wl -i ${IFNAME} down
    #wl -i ${IFNAME} chanspec -c ${ch} -b $band -w $bw
    wl -i ${IFNAME} chanspec ${ch}/${bw}
    wl -i ${IFNAME} up
}

set_ch_bw_o() {
    ch=$2
    bw=$3
    band=$4
    wl -i ${IFNAME} down
    wl -i ${IFNAME} chanspec -c ${ch} -b $band -w $bw
    wl -i ${IFNAME} up
}

start_rssi_24() {
    mac=$2
    log_rssi ${IFNAME24} $mac &
}

start_rssi() {
    mac=$2
    log_rssi $IFNAME $mac &
}

stop_rssi() {
    mac=$2
    touch /tmp/signal
}

bf_on() {
    wl -i ${IFNAME} txbf 1
}

bf_off() {
    wl -i ${IFNAME} txbf 0
}

ac_on() {
    wl -i ${IFNAME} down
    wl -i ${IFNAME} vhtmode 1
    wl -i ${IFNAME} up
}

ac_off() {
    wl -i ${IFNAME} down
    wl -i ${IFNAME} vhtmode 0
    wl -i ${IFNAME} up
}

set_1x1_24() {
    wl -i ${IFNAME24} down
    wl -i ${IFNAME24} rxchain 1
    wl -i ${IFNAME24} txchain 1
    wl -i ${IFNAME24} up
}

set_2x2_24() {
    wl -i ${IFNAME24} down
    wl -i ${IFNAME24} rxchain 3
    wl -i ${IFNAME24} txchain 3
    wl -i ${IFNAME24} up
}

set_3x3_24() {
    wl -i ${IFNAME24} down
    wl -i ${IFNAME24} rxchain 7
    wl -i ${IFNAME24} txchain 7
    wl -i ${IFNAME24} up
}

set_1x1() {
    wl -i ${IFNAME} down
    wl -i ${IFNAME} rxchain 1
    wl -i ${IFNAME} txchain 1
    wl -i ${IFNAME} up
}

set_2x2() {
    wl -i ${IFNAME} down
    wl -i ${IFNAME} rxchain 3
    wl -i ${IFNAME} txchain 3
    wl -i ${IFNAME} up
}

set_3x3() {
    wl -i ${IFNAME} down
    wl -i ${IFNAME} rxchain 7
    wl -i ${IFNAME} txchain 7
    wl -i ${IFNAME} up
}

down() {
    wl -i ${IFNAME} down
}

up() {
    wl -i ${IFNAME} up
}

down24() {
    wl -i ${IFNAME24} down
}

up24() {
    wl -i ${IFNAME24} up
}


while true
do
    command=`./nc -c -l -p $PORT`
    echo $command
    case $command in
        24pwr*)
            echo got 24power cmd
            set_power24 $command
            ;;
        pwr*)
            echo got power cmd
            set_power $command
            ;;
        "ac_on")
            echo got ac on
            ac_on
            ;;
        "ac_off")
            echo got ac off
            ac_off
            ;;
        "bf_on")
            echo got bf on
            bf_on
            ;;
        "bf_off")
            echo got bf off
            bf_off
            ;;
        "down")
            echo got down
            down
            ;;
        "up")
            echo got up
            up
            ;;
        "up24")
            echo got up24
            up24
            ;;
        "down24")
            echo got down24
            down24
            ;;
        chbw*)
            echo got channel cmd
            set_ch_bw $command
            ;;
        24chbw*)
            echo got channel cmd
            set_ch_bw24 $command
            ;;
        o_chbw*)
            echo got channel_o cmd
            set_ch_bw_o $command
            ;;
        "24_1x1")
            echo got 1x1_24
            set_1x1_24
            ;;
        "24_2x2")
            echo got 2x2_24
            set_2x2_24
            ;;
        "24_3x3")
            echo got 3x3_24
            set_3x3_24
            ;;
        "1x1")
            echo got 1x1
            set_1x1
            ;;
        "2x2")
            echo got 2x2
            set_2x2
            ;;
        "3x3")
            echo got 3x3
            set_3x3
            ;;
        24_start_rssi*)
            echo got rssi
            start_rssi_24 $command
            ;;
        start_rssi*)
            echo got rssi
            start_rssi $command
            ;;
        stop_rssi)
            echo got stop rssi
            stop_rssi
            ;;
        "exit")
            exit
            ;;
        *)
            echo unkown command
            ;;
    esac
done
