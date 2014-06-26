PWR_LEVELS="18 16 13 10"
BFS="bf nobf"
ANTS="1x1 2x2 3x3"
LOGDIR=$1

grep_avg() {
    tail -n 1 $1 | grep -o "[0-9]\+\.\?[0-9]* .bits/sec" | grep -o "[0-9]\+\.\?[0-9]*"
}

put_dat() {
    head -n -1 $1 | grep SUM | grep -o "[0-9]\+\.\?[0-9]* .bits/sec" | grep -o "[0-9]\+\.\?[0-9]*" > ${1}.dat
    #head -n -1 $1 | grep -o "[0-9]\+\.\?[0-9]* .bits/sec" | grep -o "[0-9]\+\.\?[0-9]*" > ${1}.dat
}

#bf="bf"; bw="80"; band="5g"; ant="3x3"

BANDS="2g 5g"
bw="20"
bf="nobf"
ANTS="1x1 2x2 3x3"

pdflist=""
datlist=""

for cur_pwr in $PWR_LEVELS; do 
    echo "
    set term post color 'Courier' 12 
    set style line 1 lc rgb '#0060ad' linetype 1 lw 2
    set style line 2 lc rgb '#aa60ad' linetype 1 lw 2
    set style line 3 lc rgb '#0000ad' linetype 1 lw 2
    set style line 4 lc rgb '#112233' linetype 1 lw 2
    set style line 5 lc rgb '#00aa00' linetype 1 lw 2
    set style line 6 lc rgb '#bb00aa' linetype 1 lw 2
    set grid
    set title '20 MHz 11n ${cur_pwr} dBm'
    set xlabel 'Time (seconds)' 
    set ylabel 'Throughput (MBits/s)' 
    set xtics 60
    set output '${LOGDIR}/${cur_pwr}_n.eps' 
    set yrange [0:300] 
    plot \\" > tmp.plt

    style=1

    for band in $BANDS; do
        for ant in $ANTS; do
            filename="$LOGDIR/${bf}_${band}_${bw}_${cur_pwr}_${ant}.log"
            put_dat $filename
            echo "\"${filename}.dat\" title '${band} ${ant}' with lines linestyle ${style}, \\" >> tmp.plt
            datlist="$datlist ${filename}.dat"
            style=$((style + 1))
        done
    done
    gnuplot tmp.plt
    ps2pdf ${LOGDIR}/${cur_pwr}_n.eps ${LOGDIR}/${cur_pwr}_n.pdf
    pdflist="$pdflist ${LOGDIR}/${cur_pwr}_n.pdf"
    rm ${LOGDIR}/${cur_pwr}_n.eps 
done
pdfunite $pdflist ${LOGDIR}/time_n.pdf
rm $pdflist $datlist tmp.plt
