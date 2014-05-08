using TimeSeries, Datetime

module FinancialBlotter 

using TimeSeries, Datetime 

import Base: show, getindex, add!

export AbstractInstrument, AbstractCurrency, AbstractFinancialID,
       Stock, Currency, CurrencyPair,
       Ticker, CUSIP, BloombergID, ReutersID,
       Blotter, FinancialTimeSeries, TickData,
       Portfolio, TradeAccount, Trade, tradearray,
       USD, EUR, GBP, AUD, JPY, EURUSD, EURJPY, USDGBP, USDAUD, USDNZD, USDJPY, F, G, H, J, K, M, N, Q, U, V, X, Z,  
       blottercolnames, blotterticker,
       add!, merge, parsedatetime, parsedatetime1, parsedatetime_from_TOS, makedatetime, datetolastsecond, discretesignal 
       # yahoo, fred

# Phase 2 methods and const
#        OrderBook, 
#        orderbookcolnames, orderbookbidvalues, orderbookoffervalues, orderbooksellvalues, orderbookcovervalues, orderbookticker,
#        fillorderbook, fillblotter

include("instruments.jl")
include("financialtimeseries.jl")
include("tickdata.jl")
include("blotter.jl")
include("trades.jl")
include("portfolio.jl")
include("account.jl")
include("show.jl")
include("getindex.jl")
include("utilities.jl")
include("readwrite.jl")

# include("Phase2/blotter1.jl")
# include("Phase2/orderbook.jl")
# include("Phase2/trades.jl")
# include("Phase2/statemachine.jl")

end 
