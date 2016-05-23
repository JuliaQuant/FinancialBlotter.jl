[![Build Status](https://travis-ci.org/JuliaQuant/FinancialBlotter.jl.svg?branch=master)](https://travis-ci.org/JuliaQuant/FinancialBlotter.jl)

Inspired by R's `blotter` and `quantstrat` packages.

````julia
julia> Pkg.clone("https://github.com/JuliaQuant/TradeBlotter.jl.git")
````

## First phase

Portfolio and trade accounting framework in Julia that includes:
  * `Blotter` object that keeps track of filled transactions

## Second phase

Path-dependent backtesting framework in Julia that includes:
  * Trading rules algorithm
  * `OrderBook` containing the constraints of the trading rule algorithm
  * Fill simulator that simulates real-world conditions to determine how and when orders are filled with a state machine

## Additional functionality
  * methods that take a `Blotter` object to generate typical trading statistics are planned in the FinanceStats package
