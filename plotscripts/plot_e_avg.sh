PWR_LEVELS="18 16 13 10"
BFS="bf nobf"
ANTS="1x1 2x2 3x3"
LOGDIR=$1

grep_avg() {
    tail -n 1 $1 | grep -o "[0-9]\+\.\?[0-9]* .bits/sec" | grep -o "[0-9]\+\.\?[0-9]*"
}

put_dat() {
    head -n -1 $1 | grep -o "[0-9]\+\.\?[0-9]* .bits/sec" | grep -o "[0-9]\+\.\?[0-9]*" > ${1}.dat
}

#bf="bf"; bw="80"; band="5g"; ant="3x3"

band="5g"
bw="80"

for bf in $BFS; do
    for ant in $ANTS; do
        datfl="$LOGDIR/${bf}_${ant}_avg.dat"
        rm $datfl
        for cur_pwr in $PWR_LEVELS; do 
            filename="$LOGDIR/${bf}_${band}_${bw}_${cur_pwr}_${ant}.log"
            avg=`grep_avg  $filename`
            echo "$cur_pwr, $avg" >> $datfl
        done
    done
done

cd $LOGDIR
gnuplot ../plot_e_ac_avg.plt
ps2pdf avg_ac.eps
cd -


BANDS="2g 5g"
bw="20"
bf="nobf"
ANTS="1x1 2x2"

for band in $BANDS; do
    for ant in $ANTS; do
        datfl="$LOGDIR/${bf}_${ant}_${band}_20_avg.dat"
        rm $datfl
        for cur_pwr in $PWR_LEVELS; do 
            filename="$LOGDIR/${bf}_${band}_${bw}_${cur_pwr}_${ant}.log"
            avg=`grep_avg  $filename`
            echo "$cur_pwr, $avg" >> $datfl
        done
    done
done

cd $LOGDIR
gnuplot ../plot_e_n_avg.plt
ps2pdf avg_n.eps
cd -
