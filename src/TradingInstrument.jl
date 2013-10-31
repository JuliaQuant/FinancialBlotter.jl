using DataFrames, Datetime, TimeSeries

module TradingInstrument

using DataFrames, Datetime, TimeSeries

export Stock,
       yahoo,
       yahoo_stock,
       fred,
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
# testsuite macro
       @tradinginstrument

include("reader.jl")
include("stocks.jl")
include("futures.jl")
include("options.jl")
include("currencies.jl")
include("notes.jl")
include("testtradinginstrument.jl")

end 
