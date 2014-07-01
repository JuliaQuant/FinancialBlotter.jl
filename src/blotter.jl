type Blotter <: AbstractTimeSeries

    timestamp::Vector{Date{ISOCalendar,UTC}}
    values::Matrix{Float64}
    colnames::Vector{ASCIIString}
    ticker::Ticker

    function Blotter(timestamp::Vector{Date{ISOCalendar,UTC}}, 
                    values::Matrix{Float64},
                    colnames::Vector{ASCIIString},
                    ticker::Ticker)

                    nrow, ncol = size(values, 1), size(values, 2)
                    nrow != size(timestamp, 1) ? error("values must match length of timestamp"):
                    ncol != size(colnames,1) ? error("column names must match width of array"):
                    timestamp != unique(timestamp) ? error("there are duplicate dates"):
                    ~(flipud(timestamp) == sort(timestamp) || timestamp == sort(timestamp)) ? error("dates are mangled"):
                    flipud(timestamp) == sort(timestamp) ? 
                    new(flipud(timestamp), flipud(values), colnames):
                    new(timestamp, values, colnames, ticker)
    end
end

const blottercolnames = ["Qty", "Fill"]
const blotterticker   = Ticker("ticker")

Blotter() = Blotter([datetime(1795,10,31)], [0. 0], blottercolnames, blotterticker)

# this probably blows up if you try to insert vs add the end
add!(b::Blotter, entry::Blotter) = Blotter(vcat(b.timestamp, entry.timestamp), vcat(b.values, entry.values), blottercolnames, blotterticker)

function Blotter(signal::TimeArray{Bool,1}, fts::FinancialTimeSeries{Float64,2}; quantity = 100, price = "open", slippage = .1)

    op, cl = fts["Open"], fts["Close"]
    tt = lag(signal)              # 495 row of bools, the next day
    t  = discretesignal(tt)  # 78 rows of first true and first false, as floats though

    price == "open" ?
    fills = op[datetolastsecond([t.timestamp])] :
    price == "close" ?
    fills = cl[datetolastsecond([t.timestamp])] :
    error("only open and close prices supported for naive backtests")

    notsigned  = TimeArray(t.timestamp, quantity * ones(length(t)), ["Qty"])
    exitdates  = findwhen(t.==0)
    qty        = quantity * ones(length(t.timestamp))

    for i in 1:length(notsigned)
        for j in 1:length(exitdates)
            if notsigned[i].timestamp[1] == exitdates[j]
                qty[i] = qty[i] * -1
            end
        end
    end

   datetimes = datetolastsecond(t.timestamp)

   Blotter(datetimes, [qty fills.values], blottercolnames, fts.instrument.ticker)
end

