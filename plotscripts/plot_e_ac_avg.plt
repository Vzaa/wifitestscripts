set term post color 'Courier' 12 
set style line 1 lc rgb '#0060ad' lt 1 lw 2 pt 7 pi -1 ps 1.5 
set style line 2 lc rgb '#aa60ad' lt 1 lw 2 pt 2 pi -1 ps 1.5 
set style line 3 lc rgb '#0000ad' lt 1 lw 2 pt 3 pi -1 ps 1.5 
set style line 4 lc rgb '#112233' lt 1 lw 2 pt 4 pi -1 ps 1.5 
set style line 5 lc rgb '#00aa00' lt 1 lw 2 pt 5 pi -1 ps 1.5 
set style line 6 lc rgb '#bb00aa' lt 1 lw 2 pt 6 pi -1 ps 1.5 
set grid
set title '80 MHz 11ac'
set xlabel 'Power (dBm)' 
set ylabel 'Throughput (MBits/s)' 
set xtics 1
set ytics 10
set output 'avg_ac.eps' 
set xrange [9:19] 
set yrange [0:200] 

plot \
 'bf_1x1_avg.dat'   title '1x1 BF' with linespoints ls 1, \
 'bf_2x2_avg.dat'   title '2x2 BF' with linespoints ls 2, \
 'bf_3x3_avg.dat'   title '3x3 BF' with linespoints ls 3, \
 'nobf_1x1_avg.dat' title '1x1 No BF' with linespoints ls 4, \
 'nobf_2x2_avg.dat' title '2x2 No BF' with linespoints ls 5, \
 'nobf_3x3_avg.dat' title '3x3 No BF' with linespoints ls 6, \
