using TradeModels, MarketData, FinancialBlotter

signal = (sma(Cl,50) .> sma(Cl,200));
spx    = FinancialTimeSeries(OHLC, "SPX")


