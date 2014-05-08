using TradeModels, MarketData, FinancialBlotter

signal = (sma(Cl,50) .> sma(Cl,200));
#signal = Cl .> sma(Cl,200);
spx    = FinancialTimeSeries(OHLC, "SPX")
golden = Blotter(signal, spx)

trades = tradearray(golden, spx)

pnls = convert(Array{Float64}, ([(t.close-t.open) for t in trades].*100))
pos  = pnls[pnls.>0]
neg  = pnls[pnls.<0]
profitfactor = sum(pos)/abs(sum(neg))
mae = convert(Array{Float64}, ([t.open - minimum(t.timeseries["Low"].values) for t in trades]))
trades

# read from csv, parse into blotter and analyze

# qux = readcsv(Pkg.dir("FinancialBlotter/src/dev/account.csv"));
# 
# fee = qux[:,[1,4,5,6,10]];
# fum = fee[2:11, :]
# eurtstamp = DateTime{ISOCalendar, UTC}[parsedatetime_from_TOS(t) for t in fum[:,1]]
# eurvals = convert(Array{Float64},fum[:,[2,5]])
# eurtrades = Blotter(eurtstamp, eurvals, blottercolnames, Ticker("EURUSD"))
# 
# # get euro data
# 
# fname = Pkg.dir("FinancialBlotter/src/dev/data.csv")
# blob    = readcsv(fname)
# tstamps  = Date{ISOCalendar}[date(i) for i in blob[:, 1]]
# vals  = convert(Array{Float64}, blob[:,2])
# eurta = TimeArray(tstamps, vals, ["Close"])


