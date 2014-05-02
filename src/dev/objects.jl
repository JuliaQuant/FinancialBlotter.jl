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

## make orderbook aware of account information, thus enforcing path dependence
