immutable Trade
    start::DateTime{ISOCalendar,UTC}
    finish::DateTime{ISOCalendar,UTC}
    open::Float64
    close::Float64
    quantity::Int
    timeseries::FinancialTimeSeries
    #function Trade(start::DateTime{ISOCalendar,UTC}, finish::DateTime{ISOCalendar,UTC}, open::Float64, close::Float64, quantity::Int, timeseries::FinancialTimeSeries)
    function Trade(start, finish, open, close, quantity, timeseries)
        timeseries.timestamp[1] > date(start) || timeseries.timestamp[end] < date(finish) ?
        error("timeseries doesn't match trade date range") :
        new(start, finish, open, close, quantity, timeseries[date(start):date(finish)])
    end
end

function Trade(b::Blotter, f::FinancialTimeSeries)
    Trade(b.timestamp[1], b.timestamp[length(b.timestamp)], b.values[length(b.timestamp)+1], b.values[end], b.values[1], f)
end


########## show #############

function show(io::IO, t::Trade)
    println(io, @sprintf("Start:       %s", string(t.start)))
    println(io, @sprintf("Finish:      %s", string(t.finish)))
    println(io, @sprintf("Entry:       %s", string(t.open)))
    println(io, @sprintf("Exit:        %s", string(t.close)))
    println(io, @sprintf("Quantity:    %s", string(t.quantity)))
    println(io, @sprintf("PnL:         %.2f %s",  t.quantity*(t.close - t.open), string(t.timeseries.instrument.currency)))
end

########## #############
