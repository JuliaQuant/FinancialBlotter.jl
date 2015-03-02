module FinancialBlotter

# documentation
using Docile

if VERSION < v"0.4-"
  using Dates
else
  using Base.Dates
end
using Reexport
@reexport using TimeSeries, FinancialSeries

import Base: show, push! #getindex, add!

@document

export Blotter, Portfolio, Account, Trade, tradearray,
       blottercolnames, blotterticker,
       push!,#add!,
       merge, parsedatetime, parsedatetime1, parsedatetime_from_TOS, makedatetime, datetolastsecond, discretesignal,
       startedtrades, closedtrades

# Phase 2 methods and const
#        OrderBook,
#        orderbookcolnames, orderbookbidvalues, orderbookoffervalues, orderbooksellvalues, orderbookcovervalues, orderbookticker,
#        fillorderbook, fillblotter

include("blotter.jl")
include("show.jl")

### TODO
#include("trades.jl")
#include("portfolio.jl")
#include("account.jl")
#include("getindex.jl")
#include("utilities.jl")

# include("Phase2/blotter1.jl")
# include("Phase2/orderbook.jl")
# include("Phase2/trades.jl")
# include("Phase2/statemachine.jl")

end
