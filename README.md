Downloading financial time series data in Julia and providing useful financial asset types.

Inspired by R's `quantmod` and `FinancialInstrument`

````julia
julia> Pkg.add("TradingInstrument")
````

Download financial time series from Yahoo in one of two ways.  

As a `DataFrame` object:

````julia
julia> GLD = yahoo("GLD");

julia> typeof(GLD)
DataFrame

julia> head(GLD, 3)
3x7 DataFrame:
              Date   Open   High    Low  Close      Vol    Adj
[1,]    2010-01-14 111.51 112.37 110.79 112.03 18305300 112.03
[2,]    2010-01-15 111.35 112.01 110.38 110.86 18002700 110.86
[3,]    2010-01-19 110.95 111.75 110.83 111.52 10468200 111.52
````

As a `Stock` object: 

````julia
julia> GLD = yahoo!("GLD");

julia> typeof(GLD)
Stock

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


The `Stock` type is experimental at this point. Alignment along the `IndexedVector` hasn't been thoroughly stress-tested.

The `read_asset` function is designed to read in data that you already have locally, and deal with `NA`s. 

````julia
julia> dgs = read_asset(Pkg.dir("TradingInstrument", "test", "data", "DGS10.csv"));

julia> head(dgs, 3)
3x2 DataFrame:
              Date VALUE
[1,]    1962-01-02  4.06
[2,]    1962-01-03  4.03
[3,]    1962-01-04  3.99


julia> sum(dgs["VALUE"].na)
573
````

Download data from FRED. You can allow the column name to stay as the generic "VALUE" that FRED is fond of, 
or you can pass in a string to name the column to something more informative.

````julia
julia> head(fred("DGS10"), 3)
3x2 DataFrame:
              Date VALUE
[1,]    1962-01-02  4.06
[2,]    1962-01-03  4.03
[3,]    1962-01-04  3.99

julia> head(fred("DGS10", "DGS10"), 3)
3x2 DataFrame:
              Date DGS10
[1,]    1962-01-02  4.06
[2,]    1962-01-03  4.03
[3,]    1962-01-04  3.99

````

