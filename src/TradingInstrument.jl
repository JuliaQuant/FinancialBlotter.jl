using Stats, DataFrames, Calendar, UTF16, TimeSeries

module TradingInstrument

using Stats, DataFrames, Calendar, UTF16, TimeSeries

export Stock,
       read_yahoo,
       yahoo!,
       read_fred,
       read_asset,
# aliases
       yahoo,
       fred,
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
