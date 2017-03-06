bin(x, w) = w * (0.5 + floor(x / w))
set terminal png size 800, 600
set output 'arcus-distribution.png'
set title 'Reset (Red) and Finished (Blue) Runs by Arcus'
set xlabel 'Time'
set ylabel 'Number'
set xdata time
set timefmt '%s'
set xrange ['0' : '840']
set yrange ['0' : '1200']
set format x '%M:%S'
set style fill solid noborder
set xtics out
set ytics out
plot 'arcus-reset.data' using (bin($2, 1.0)) : (1.0) smooth freq \
  with boxes linetype 1 notitle, \
  'arcus-finished.data' using (bin($2, 1.0)) : (1.0) smooth freq \
  with boxes linetype 3 notitle
