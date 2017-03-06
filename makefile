arcus: arcus-distribution.png arcus-progress.png

%.png: %.gp arcus-reset.data arcus-finished.data
	gnuplot $<

%-reset.data: %.lss speedrun-stats.cabal
	cabal run -v0 -- +RTS -M1G -RTS $< 1> $@ 2> /dev/null

%-finished.data: %.lss speedrun-stats.cabal
	cabal run -v0 -- +RTS -M1G -RTS $< 1> /dev/null 2> $@
