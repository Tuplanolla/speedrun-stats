arcus.png: arcus.gp data
	gnuplot $<

data: arcus.lss arcus.cabal
	cabal run -v0 -- $< 1> reset.data 2> finished.data

reset.data: arcus.lss arcus.cabal
	cabal run -v0 -- $< 1> $@ 2> /dev/null

finished.data: arcus.lss arcus.cabal
	cabal run -v0 -- $< 1> /dev/null 2> $@
