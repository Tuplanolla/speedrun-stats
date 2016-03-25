set terminal png
set output 'arcus-progress.png'
set title 'Finished Runs by Arcus'
set xlabel 'Date'
set ylabel 'Time'
set xdata time
set ydata time
set timefmt '%s'
set xrange ['1456704000' : '1459036800']
set yrange ['700' : '780']
set format x '%Y-%m-%d'
set format y '%M:%S'
set xtics out
set ytics out
plot 'arcus-finished.data' using 1 : 3 with points pointtype 7 notitle
