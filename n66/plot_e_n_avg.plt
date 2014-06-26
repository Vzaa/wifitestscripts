set term post color 'Courier' 12 
set style line 1 lc rgb '#0060ad' lt 1 lw 2 pt 7 pi -1 ps 1.5 
set style line 2 lc rgb '#aa60ad' lt 1 lw 2 pt 2 pi -1 ps 1.5 
set style line 3 lc rgb '#0000ad' lt 1 lw 2 pt 3 pi -1 ps 1.5 
set style line 4 lc rgb '#112233' lt 1 lw 2 pt 4 pi -1 ps 1.5 
set style line 5 lc rgb '#00aa00' lt 1 lw 2 pt 8 pi -1 ps 1.5 
set style line 6 lc rgb '#bb00aa' lt 1 lw 2 pt 0 pi -1 ps 1.5 
set grid
set title '20 MHz 11n'
set xlabel 'Power (dBm)' 
set ylabel 'Throughput (MBits/s)' 
set xtics 1
#set ytics 10
set output 'avg_n.eps' 
set xrange [9:19] 
set yrange [0:300] 

plot \
 'nobf_1x1_2g_20_avg.dat' title '1x1 2g' with linespoints ls 1, \
 'nobf_2x2_2g_20_avg.dat' title '2x2 2g' with linespoints ls 2, \
 'nobf_3x3_2g_20_avg.dat' title '3x3 2g' with linespoints ls 3, \
 'nobf_1x1_5g_20_avg.dat' title '1x1 5g' with linespoints ls 4, \
 'nobf_2x2_5g_20_avg.dat' title '2x2 5g' with linespoints ls 5, \
 'nobf_3x3_5g_20_avg.dat' title '3x3 5g' with linespoints ls 6






