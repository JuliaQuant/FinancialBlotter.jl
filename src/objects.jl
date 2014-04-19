#using TradeModels, MarketData, FinancialBlotter

#SPX = Stock(Ticker("SPX"))

# MAKE FinancialTimeSeries accept an TimeArray and subsequentially a fts
# s = FinancialTimeSeries(OHLC, SPX)

#s   = FinancialTimeSeries(OHLC.timestamp, OHLC.values, OHLC.colnames, SPX)
signal = (sma(Cl,50) .> sma(Cl,200));
spx    = FinancialTimeSeries(OHLC, "SPX")

#goldencross = fillorderbook(sig, s);


#a = fillblotter(goldencross, s);
#b = a[1];
# trades = tradearray(b,s)

# MAKE fillblotter accept a signal and fts, for naive next day fills 

golden = Blotter(sig, s)

#a = fillblotter(goldencross, s);
#b = a[1];


trades1 = tradearray(golden, s)
trades2 = tradearray(b, s)

# pnls = float([(t.close-t.open) for t in trades]).*100
# pos = pnls[pnls.>0]
# neg = pnls[pnls.<0]
# profitfactor = sum(pos)/abs(sum(neg))
