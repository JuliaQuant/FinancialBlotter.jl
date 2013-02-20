dgs = read_asset(Pkg.dir("TradingInstrument", "test", "data", "DGS10.csv"))

@assert 2.02  == dgs[13336,"VALUE"] 


