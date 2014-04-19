#using TradeModels, MarketData, FinancialBlotter
SPX = Stock(Ticker("SPX"))
s = FinancialTimeSeries(OHLC.timestamp, OHLC.values, OHLC.colnames, SPX)
sig = (sma(Cl,50) .> sma(Cl,200));
goldencross = fill!(sig, s);
a = fill!(goldencross, s);
b = a[1];
# trades = tradearray(b,s)
# pnls = float([(t.close-t.open) for t in trades]).*100
# pos = pnls[pnls.>0]
# neg = pnls[pnls.<0]
# profitfactor = sum(pos)/abs(sum(neg))
