immutable Trade
    start::DateTime{ISOCalendar,UTC}
    finish::DateTime{ISOCalendar,UTC}
    open::Float64
    close::Float64
    side::ASCIIString
    quantity::Int
    timeseries::FinancialTimeSeries
    function Trade(start, finish, open, close, side, quantity, timeseries)

                   if timeseries.timestamp[1] > start || timeseries.timestamp[end] < finish 
                       error("timeseries doesn't match trade date range") 
                   else
                       sd    = findfirst(timeseries.timestamp .== start)
                       fd    = findfirst(timeseries.timestamp .== finish)
                   end
                   new(start, finish, open, close, side, quantity, timeseries[sd:fd])
    end
end

function Trade(b::Blotter, f::FinancialTimeSeries)
    Trade(b.timestamp[1], b.timestamp[length(b.timestamp)], b.values[length(b.timestamp)+1], b.values[end], "long", b.values[1], f)
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

function tradestats(t::Vector{Trade})
#     symbol             = t.[1].timeseries.instrument.ticker
#     txns_total         = length(trades)
#     trades_total       = 
#     pnls               = convert(Array{Float64}, ([(t.close-t.open) for t in trades].*100))
#     pos                = pnls[pnls.>0]
#     neg                = pnls[pnls.<0]
#     netprofit          =
#     trade_pl_mean      =
#     med_Trade_PL       =
#     largest_winner     = maximum(pos)
#     largest_loser      = minimum(neg)
#     std_Dev_Trade_PL   =
#     percent_positive   = length(pos)/length(trades)
#     percent_negative   = length(neg)/length(trades)
#     profitfactor       = sum(pos)/abs(sum(neg))
#     avg_Win_Trade      = mean(pos)
#     med_Win_Trade      = median(pos)
#     avg_Losing_Trade   = mean(neg)
#     med_Losing_Trade   = median(neg)
#     avg_Daily_PL       =
#     med_Daily_PL       =
#     std_Dev_Daily_PL   =
#     ann_Sharpe         =
#     max_drawdown       =
#     profit_To_Max_Draw =
#     avg_WinLoss_Ratio  =
#     med_WinLoss_Ratio  =
#     max_equity         =
#     min_equity         =
#     end_equity         =
#     mae                = convert(Array{Float64}, ([t.open - minimum(t.timeseries["Low"].values) for t in trades]))
end

