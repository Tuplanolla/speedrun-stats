set terminal png
set output 'arcus-progress.png'
set title 'Finished Runs by Arcus'
set xlabel 'Date'
set ylabel 'Time'
set xdata time
set ydata time
set timefmt '%s'
set xrange ['1456700000' : '1458900000']
set yrange ['690' : '750']
set format x '%Y-%m-%d'
set format y '%M:%S'
set xtics rotate
plot 'arcus-finished.data' using 1 : 3 with points pointtype 7 notitle
