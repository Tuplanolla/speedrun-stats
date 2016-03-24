bin(x, w) = w * (0.5 + floor(x / w))
set terminal png
set output 'arcus.png'
set title 'Speedrun Graveyard for Arcus'
set xlabel 'Time'
set ylabel 'Resets'
set xdata time
set timefmt '%s'
set xrange ['0' : '840']
set format x '%M:%S'
set style fill solid
set xtics out
set ytics out
plot 'reset.data' using (bin($1, 5)) : (1) smooth freq \
     with boxes linetype 1 notitle, \
     'finished.data' using (bin($1, 5)) : (1) smooth freq \
     with boxes linetype 3 notitle
