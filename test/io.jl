dgs = readtime(Pkg.dir("TradingInstrument/test/data/DGS10.csv"))

@assert 2.02  == dgs[13336,"VALUE"] 

spx = readtime(Pkg.dir("TradingInstrumen/test/data/spx.csv"))

@assert 92.4 == spx[6,"Adj Close"] 

### requires internet connection

# g_day   = yahoo!("GLD", 1,1,2010, 1,1,2011, "d")
# g_month = yahoo!("GLD", 1,1,2010, 1,1,2011, "m")
