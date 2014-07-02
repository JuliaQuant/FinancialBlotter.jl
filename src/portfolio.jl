type Portfolio <: AbstractTimeSeries
    timestamp::Vector{Date}
    values::Matrix{Float64}
    colnames::Vector{ASCIIString}
#    books::Vector{OrderBook}
    blotters::Vector{Portfolio}

    function Portfolio(timestamp::Vector{Date}, 
                       values::Matrix{Float64}, 
                       colnames::Vector{ASCIIString},
#                       books::Vector{OrderBook},
                       blotters::Vector{Portfolio})

                       nrow, ncol = size(values, 1), size(values, 2)
                       nrow != size(timestamp, 1) ? error("values must match length of timestamp"):
                       ncol != size(colnames,1) ? error("column names must match width of array"):
                       timestamp != unique(timestamp) ? error("there are duplicate dates"):
                       ~(flipud(timestamp) == sort(timestamp) || timestamp == sort(timestamp)) ? error("dates are mangled"):
                       flipud(timestamp) == sort(timestamp) ? 
                       new(flipud(timestamp), flipud(values), colnames):
                       new(timestamp, values, colnames, books, blotters)
    end
end

#function Portfolio(books::Vector{OrderBook}, blotters::Vector{Blotter})
function Portfolio(blotters::Vector{Blotter})
    #tstamps = sort(unique(vcat([b.timestamp for b in books], [bb.timestamp for bb in blotters])))
    tstamps = sort(unique(vcat([b.timestamp for b in blotters])))
#   vals  are each blotter's log return (zero when NA) plus
#         the equity and cah values
#   colnames should be each blotter's ticker, + equity and cash
end

