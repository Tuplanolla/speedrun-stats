plot: arcus-distribution.png arcus-progress.png

%.png: %.gp arcus-reset.data arcus-finished.data
	gnuplot $<

%-reset.data: %.lss speedrun-statistics.cabal
	cabal run -v0 -- $< 1> $@ 2> /dev/null

%-finished.data: %.lss speedrun-statistics.cabal
	cabal run -v0 -- $< 1> /dev/null 2> $@
