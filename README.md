[![Build Status](https://travis-ci.org/JuliaQuant/FinancialBlotter.jl.png)](https://travis-ci.org/JuliaQuant/FinancialBlotter.jl)

Inspired by R's `blotter`, `FinancialInstrument` and `quantstrat` packages.

````julia
julia> Pkg.clone("https://github.com/JuliaQuant/FinancialBlotter.jl.git")
````

Financial and trade accounting framework in Julia, that includes:
  * instrument types (`Stock`, `CurrencyPair`, etc)
  * `FinancialTimeSeries` type that holds time series data and instrument metadata 
  * Trading rules algorithm
  * `OrderBook` containing the constraints of the trading rule algorithm
  * Fill simulator that simulates real-world conditions to determine how and when orders are filled 
  * `Blotter` object that keeps track of filled transactions
  * methods that take a `Blotter` object to generate typical trading statistics

 # API (proposed)

A `signal` is generated from a model (TradeModels, e.g., but not limited to it). The signal is a `Bool` array attached to a timestamp, 
and is reduced to discrete signals (vs a continuous on/off stream of values).

Next a `trading rule algorithm` (unimplemented), accepts the signal and generates an entry into an `OrderBook`, which contains all the specific
constraints of the algorithm. 

The `OrderBook` is passed to a `fill simulator` (unimplemented) that simulates real trading conditions to determine how and when orders get filled. 

Once an order is filled, it is entered into a `Blotter` object that is nothing more than a timestamp with a fill quantity and a fill price. 
Methods that accept a `Blotter` object are planned to generate statistics common to backtesting frameworks, from MAE to Sharpe Ratio. 

This package will focus on the framework after a signal, and passes around a new time series objects called a `FinancialTimeSeries`, which includes not
just timestamps and prices, but also metadata about the underlying trading instrument.
