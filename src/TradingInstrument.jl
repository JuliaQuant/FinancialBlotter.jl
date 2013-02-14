using Stats, DataFrames, Calendar, UTF16, TimeSeries 

module TradingInstrument

using Stats, DataFrames, Calendar, UTF16, TimeSeries

export Stock,
       fetch_asset,
       read_asset,
# future month abbreviations
       F,
       G,
       H,
       J,
       K,
       M,
       N,
       Q,
       U,
       V,
       X,
       Z,
# aliases
       yahoo,
       fred,
# testsuite macro
       @tradinginstrument

include("reader.jl")
include("stocks.jl")
include("futures.jl")
include("options.jl")
include("currencies.jl")
include("notes.jl")
include("testtradnginstrument.jl")

end 
