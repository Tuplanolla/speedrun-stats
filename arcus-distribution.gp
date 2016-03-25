bin(x, w) = w * (0.5 + floor(x / w))
set terminal png
set output 'arcus-distribution.png'
set title 'Reset (Red) and Finished (Blue) Runs by Arcus'
set xlabel 'Time'
set ylabel 'Resets'
set xdata time
set timefmt '%s'
set xrange ['0' : '840']
set format x '%M:%S'
set style fill solid
set xtics out
set ytics out
plot 'arcus-reset.data' using (bin($3, 5)) : (1) smooth freq \
     with boxes linetype 1 notitle, \
     'arcus-finished.data' using (bin($3, 5)) : (1) smooth freq \
     with boxes linetype 3 notitle
