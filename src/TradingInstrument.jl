module TradingInstrument

using Stats, DataFrames, Calendar, UTF16, TimeSeries

export Stock,
       fetch_asset,
       fetch_asset!,
       read_asset,
       read_asset!,
# aliases
       yahoo,
       yahoo!,
       fred,
       fred!,
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
