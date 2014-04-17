using TradeModels, MarketData, FinancialBlotter
s = (sma(Cl,50) .> sma(Cl,200));
goldencross = fill!(s,OHLC);
a = fill!(goldencross, OHLC);
spx = Ticker("SPX")
SPX = Stock(spx)
s = FinancialTimeSeries(OHLC.timestamp, OHLC.values, OHLC.colnames, SPX)
b = a[1];
sp1 = Trade(b.timestamp[1], b.timestamp[2], b.values[1,2], b.values[2,2], b.values[1,1], s)
sp2 = Trade(b.timestamp[3], b.timestamp[4], b.values[3,2], b.values[4,2], b.values[3,1], s)
trades = tradearray(b,s)
