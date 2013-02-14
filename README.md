Downloading financial time series data in Julia and providing useful financial asset types.

Inspired by R's `quantmod` and `FinancialInstrument`

````julia
julia> Pkg.add("TradingInstrument")
````

Download financial time series from Yahoo in one of two ways.  

As a `DataFrame` object:

````julia
julia> GLD = yahoo("GLD");

julia> head(GLD, 3)
3x7 DataFrame:
              Date   Open   High    Low  Close      Vol    Adj
[1,]    2010-01-14 111.51 112.37 110.79 112.03 18305300 112.03
[2,]    2010-01-15 111.35 112.01 110.38 110.86 18002700 110.86
[3,]    2010-01-19 110.95 111.75 110.83 111.52 10468200 111.52
````

As a `Stock` object: 

julia> GLD = yahoo!("GLD");

julia> GLD.prices[1:3,:]
3x5 DataFrame:
          Open   High    Low  Close    Adj
[1,]    111.51 112.37 110.79 112.03 112.03
[2,]    111.35 112.01 110.38 110.86 110.86
[3,]    110.95 111.75 110.83 111.52 111.52


julia> GLD.volume[1:3]
3-element Int64 DataArray:
 18305300
 18002700
 10468200

julia> GLD.idx[1:3]
3-element CalendarTime DataArray:
 2010-01-14
 2010-01-15
 2010-01-19

julia> GLD.tick
0.01
````


The `Stock` type is experimental at this point. Alignment along the `IndexedVector` hasn't been thoroughly stress=tested.


