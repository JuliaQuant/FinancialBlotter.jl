"""
Financial blotter type: keeps track of filled transactions
for one specific instrument (in metadata).
"""
typealias Blotter{T<:Float64} TimeArray{T,2,FinancialSeries.Ticker}

"Standard blotter columns: order quantity and fill price."
const blottercolnames = ["Qty", "FillPrice"]

"Placeholder ticker"
const blotterticker = FinancialSeries.Ticker("ticker")

"Blotter object without any filled transactions"
emptyblotter() = TimeSeries.TimeArray([DateTime(1795,10,31)], [0.0 0.0], blottercolnames, blotterticker)

# """
# Add a single transaction at the end (time-wise) of the Blotter-object.
# Modifies `fb`.
# """
# function push!(fb::Blotter, tstamp::DateTime, qty::Float64, fillprice::Float64)
#   fb.colnames == blottercolnames || error("Unexpected blotter column names")

#   ### this does not modify the object but creates another one
#   ### same with TimeSeries merge

#   return TimeArray([fb.timestamp, tstamp],
#                    [fb.values, [qty fillprice]],
#                    fb.colnames,
#                    fb.meta)
# end

# push!(fb::Blotter, tstamp::DateTime, qty::Int64, fillprice::Float64) =
#   push!(fb, tstamp, float(qty), fillprice)


### TODO use merge, append!
# this probably blows up if you try to insert vs add the end
#add!(b::Blotter, entry::Blotter) = Blotter(vcat(b.timestamp, entry.timestamp), vcat(b.values, entry.values), blottercolnames, blotterticker)



# """
# Backtesting blotter for instrument series `fts` based on `signal`.
# CAUTION: not tested.
# ...
# Returns `Blotter`-object.
# """
# function Blotter(signal::TimeArray{Bool,1}, fts::FinancialTimeSeries{Float64,2};
#                  quantity = 100, price = "open", slippage = .1)
#   op, cl = fts["Open"], fts["Close"]
#     tt = lag(signal)              # 495 row of bools, the next day
#     t  = discretesignal(tt)  # 78 rows of first true and first false, as floats though

#     price == "open" ?
#     fills = op[datetolastsecond([t.timestamp])] :
#     price == "close" ?
#     fills = cl[datetolastsecond([t.timestamp])] :
#     error("only open and close prices supported for naive backtests")

#     notsigned  = TimeArray(t.timestamp, quantity * ones(length(t)), ["Qty"])
#     exitdates  = findwhen(t.==0)
#     qty        = quantity * ones(length(t.timestamp))

#     for i in 1:length(notsigned)
#         for j in 1:length(exitdates)
#             if notsigned[i].timestamp[1] == exitdates[j]
#                 qty[i] = qty[i] * -1
#             end
#         end
#     end

#    datetimes = datetolastsecond(t.timestamp)

#    Blotter(datetimes, [qty fills.values], blottercolnames, fts.instrument.ticker)
# end
