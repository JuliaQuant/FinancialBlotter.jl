immutable Trade
    start::DateTime{ISOCalendar,UTC}
    finish::DateTime{ISOCalendar,UTC}
    open::Float64
    close::Float64
    quantity::Int
    timeseries::FinancialTimeSeries
    function Trade(start, 
                   finish,
                   open,
                   close, 
                   quantity,
                   timeseries)

                   if timeseries.timestamp[1] > start || timeseries.timestamp[end] < finish 
                       error("timeseries doesn't match trade date range") 
                   else
                       sd    = findfirst(timeseries.timestamp .== start)
                       fd    = findfirst(timeseries.timestamp .== finish)
                   end
                   new(start, finish, open, close, quantity, timeseries[sd:fd])
    end
end

function Trade(b::Blotter, f::FinancialTimeSeries)
    Trade(b.timestamp[1], b.timestamp[length(b.timestamp)], b.values[length(b.timestamp)+1], b.values[end], b.values[1], f)
end

########## show #############

function show(io::IO, t::Trade)
    print(io, @sprintf("%s:", string(t.start)))
    print(io, @sprintf("%s", string(t.finish)))
    println("")
    print(io, @sprintf("%s ~ ", string(t.open)))
    print(io, @sprintf("%s qty = ", string(t.close)))
    print(io, @sprintf("%s", string(t.quantity)))
end

########## get Trades #########

# first get the index (row number) where cumsum == 0, or trades are closed

function closedtrades(b::Blotter)
    # get index of zeros first
    totals  = cumsum(b.values[:,1])
    counter = Int[]
    for d in 1:length(b.timestamp)
        if totals[d] == 0
            push!(counter,d)
        end
    end
    counter
end

function startedtrades(b::Blotter)
    closed  = closedtrades(b)
    counter = [1]
    for n in 1:length(closed) - 1
        push!(counter, closed[n]+1)
    end
    counter
end

function tradearray(b::Blotter, fts::FinancialTimeSeries)
    started  = startedtrades(b)
    closed   = closedtrades(b)
    duration = hcat(started, closed)
    trades   = Trade[]
    for d in 1:size(duration,1)
        s = duration[d,1]
        f = duration[d,2]
        sdate = b.timestamp[s]
        sd    = findfirst(fts.timestamp .== sdate)
        fdate = b.timestamp[f]
        fd    = findfirst(fts.timestamp .== fdate)
        push!(trades, Trade(b[s:f], fts[sd:fd]))
    end
    trades
end
