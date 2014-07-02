type Account <: AbstractTimeSeries
    timestamp::Vector{Date}
    values::Matrix{Float64}
    colnames::Vector{ASCIIString}
    portfolios::Vector{Portfolio} 

    function Account(timestamp::Vector{Date}, 
                          values::Matrix{Float64}, 
                          colnames::Vector{ASCIIString},
                          portfolios::Vector{Account})
    
                          nrow, ncol = size(values, 1), size(values, 2)
                          nrow != size(timestamp, 1) ? error("values must match length of timestamp"):
                          ncol != size(colnames,1) ? error("column names must match width of array"):
                          timestamp != unique(timestamp) ? error("there are duplicate dates"):
                          ~(flipud(timestamp) == sort(timestamp) || timestamp == sort(timestamp)) ? error("dates are mangled"):
                          flipud(timestamp) == sort(timestamp) ? 
                          new(flipud(timestamp), flipud(values), colnames):
                          new(timestamp, values, colnames)
    end
end
