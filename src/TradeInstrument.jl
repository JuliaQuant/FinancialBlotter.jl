using DataFrames, Calendar, UTF16 

module TradeInstrument

using DataFrames, Calendar, UTF16 

abstract AbstractAsset <: Associative{String, Any}

export reader,
## testsuite macro
       @tradeinstrument

include("reader.jl")
include("stocks.jl")
include("futures.jl")
include("options.jl")
include("currencies.jl")
include("notes.jl")
include("testtradeinstrument.jl")

end 
