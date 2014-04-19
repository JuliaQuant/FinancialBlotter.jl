using TimeSeries, Datetime

module FinancialBlotter 

using TimeSeries, Datetime 

import Base: length, show, getindex, fill!, add!

export AbstractInstrument, AbstractCurrency, AbstractFinancialID,
       Stock, Currency, CurrencyPair,
       Ticker, CUSIP, BloombergID, ReutersID,
       Blotter, OrderBook, FinancialTimeSeries, Trade, tradearray,
       USD, EUR, GBP, AUD, JPY, F, G, H, J, K, M, N, Q, U, V, X, Z,  
       orderbookcolnames, orderbookbidvalues, orderbookoffervalues, orderbooksellvalues, orderbookcovervalues, blottercolnames,
       add!, fillorderbook, fillblotter,
       merge, parsedatetime, makedatetime, datetolastsecond, discretesignal
#       start, next, done, emtpy
       # yahoo, fred

include("instruments.jl")
include("financialtimeseries.jl")
include("orderbook.jl")
include("blotter.jl")
include("utilities.jl")
include("basemethods.jl")
include("analysis.jl")
#include("readwrite.jl")
#include("plots.jl")

end 
