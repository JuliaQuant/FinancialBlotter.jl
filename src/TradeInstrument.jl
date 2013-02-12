using DataFrames, Calendar, UTF16 

module TradeInstrument

using DataFrames, Calendar, UTF16 

export reader,
## testsuite macro
       @tradeinstrument

include("reader.jl")
include("testtradeinstrument.jl")

end 
