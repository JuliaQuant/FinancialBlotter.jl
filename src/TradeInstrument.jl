#using Stats, DataFrames, Calendar, UTF16, TimeSeries 

module TradeInstrument

using Stats, DataFrames, Calendar, UTF16, TimeSeries

abstract AbstractAsset <: Associative{String, Any}

export fetch_asset,
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
       @tradeinstrument

include("reader.jl")
include("stocks.jl")
include("futures.jl")
include("options.jl")
include("currencies.jl")
include("notes.jl")
include("testtradeinstrument.jl")

end 
