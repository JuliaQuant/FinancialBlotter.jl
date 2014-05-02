type FinancialTimeSeries{T<:Float64,N} <: AbstractTimeSeries

    timestamp::Vector{DateTime{ISOCalendar,UTC}}
    values::Array{T,N}
    colnames::Vector{ASCIIString}
    instrument::AbstractInstrument

    function FinancialTimeSeries(timestamp::Vector{DateTime{ISOCalendar,UTC}}, 
                                 values::Array{T,N},
                                 colnames::Vector{ASCIIString},
                                 instrument::AbstractInstrument)

                                 nrow, ncol = size(values, 1), size(values, 2)
                                 nrow != size(timestamp, 1) ? error("values must match length of timestamp"):
                                 ncol != size(colnames,1) ? error("column names must match width of array"):
                                 timestamp != unique(timestamp) ? error("there are duplicate dates"):
                                 ~(flipud(timestamp) == sort(timestamp) || timestamp == sort(timestamp)) ? error("dates are mangled"):
                                 flipud(timestamp) == sort(timestamp) ? 
                                 new(flipud(timestamp), flipud(values), colnames, instrument):
                                 new(timestamp, values, colnames, instrument)
    end
end

FinancialTimeSeries{T<:Float64,N}(d::Vector{DateTime{ISOCalendar,UTC}}, v::Array{T,N}, c::Vector{ASCIIString}, t::AbstractInstrument) = FinancialTimeSeries{T,N}(d,v,c,t)
FinancialTimeSeries{T<:Float64,N}(d::DateTime{ISOCalendar,UTC}, v::Array{T,N}, c::Array{ASCIIString,1}, t::AbstractInstrument) = FinancialTimeSeries([d],v,c,t)
function FinancialTimeSeries{T,N}(ta::TimeArray{T,N}, ticker::ASCIIString)
     dates = datetolastsecond(ta.timestamp)
     FinancialTimeSeries(dates, ta.values, ta.colnames, Stock(Ticker(ticker)))
end

