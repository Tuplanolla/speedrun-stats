set terminal png size 800, 600
set output 'arcus-progress.png'
set title 'Finished Runs by Arcus'
set xlabel 'Date'
set ylabel 'Time'
set xdata time
set ydata time
set timefmt '%s'
# 2016-02-01 : 2017-02-01
set xrange ['1454284800' : '1485907200']
set yrange ['695' : '755']
set format x '%Y-%m-%d'
set format y '%M:%S'
set xtics out rotate by 45 right
set ytics out
plot 'arcus-finished.data' using 1 : 2 \
  with points linetype 3 pointtype 7 notitle, \
  '-' using 1 : 2 smooth bezier with lines linetype 3 notitle
1454284800 712
1462060800 704
1470009600 704
1477958400 708
1485907200 700
end
