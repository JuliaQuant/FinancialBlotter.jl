#### add order/txn ### ###### 

add!(b::Blotter, entry::Blotter) = Blotter(vcat(b.timestamp, entry.timestamp), vcat(b.values, entry.values), blottercolnames)
add!(ob::OrderBook, entry::OrderBook) = OrderBook(vcat(ob.timestamp, entry.timestamp), vcat(ob.values, entry.values), orderbookcolnames)

#### fill book/blotter ###### 

# fill order book from a signal -- simple long/sell scenario

#function fill!(s::TimeArray{Bool,1}, timeseries::TimeArray{Float64,2})
function fillorderbook(s::TimeArray{Bool,1}, timeseries::FinancialTimeSeries{Float64,2})

    op, hi, lo, cl = timeseries["Open"], timeseries["High"], timeseries["Low"], timeseries["Close"]

    tt = lag(s)              # 495 row of bools, the next day
    t  = discretesignal(tt)  # 78 rows of first true and first false, as floats though

# entries day after signal, with a bid of signal day's mid price
    entrydates = findwhen(t.==1)
    entries    = OrderBook(entrydates, repmat(orderbookbidvalues, length(entrydates)), orderbookcolnames)
    bidsignal  = findwhen(discretesignal(s).==1)
    #entryprice = (lo[bidsignal] .+ (hi[bidsignal] .- lo[bidsignal])/2).values
    #entryprice = hi[bidsignal].values
    entryprice  = op[entrydates].values .+ .1  # slippage should NOT be here but in the fill algo below
    for i in 1:length(entries)
        entries.values[i,2] = string(round(entryprice[i],2))
    end

# exits day after signal, with .1 slippage
    exitdates  = findwhen(t.==0)
    exits      = OrderBook(exitdates, repmat(orderbooksellvalues, length(exitdates)), orderbookcolnames)
    exitprice  = op[exitdates].values .+ .1  # slippage should NOT be here but in the fill algo below
    for i in 1:length(exits)
        exits.values[i,2] = string(round(exitprice[i],2))
    end

    res = merge(entries,exits)
    res.values[1,5] = "open"
    res
end

#function fill!(ob::OrderBook, timeseries::TimeArray{Float64,2}; slippage = .00)
#function fill!(ob::OrderBook, timeseries::FinancialTimeSeries{Float64,2}; slippage = .00)
function fillblotter(ob::OrderBook, timeseries::FinancialTimeSeries{Float64,2}; slippage = .00, naive=false)
    #naive ?
    #code here :

    #for d in 1:length(ob) - 1
    for d in 1:2:length(ob)-1
        if findfirst(ob.values .== "open") != 0                  # find row that is open and store date
            idx    = findfirst(ob.values .== "open") - 4length(ob)
            dt     = ob.timestamp[idx]
            nextdt = ob[dt:ob.timestamp[end]][2].timestamp[1] - days(1)    # just before the next obs
            low    = timeseries[dt:nextdt]["Low"]
            high   = timeseries[dt:nextdt]["High"]
        end

        v = 1
        while v < length(timeseries[dt:nextdt])
            if  low.values[v] + slippage < float(ob.values[d,2]) < high.values[v] - slippage # bid is inside market, sell fits here too
                ob.values[d,5]   = "closed"
                #ob.values[d,6]   = string(datetime(low[v].timestamp[1]))
                #ob.values[d+1,6] = string(datetime(ob[d+1].timestamp[1]))
                da               = split(string(low[v].timestamp[1]), "-")
                danext           = split(string(ob[d+1].timestamp[1]), "-")
                ob.values[d,6]   = string(datetime(int(da[1]),int(da[2]),int(da[3]),23,59,59,59))
                ob.values[d+1,6] = string(datetime(int(danext[1]),int(danext[2]),int(danext[3]),23,59,59,59))
                ob.values[d+1,5] = "closed"
                ob.values[d+2,5] = "open"
                break
            elseif float(ob.values[d,2])  > high.values[v] - slippage # bid is above market
                ob.values[d,2]   = string(high.values[v] - slippage)
                ob.values[d,5]   = "closed"
                #ob.values[d,6]   = string(datetime(low[v].timestamp[1]))
                #ob.values[d+1,6] = string(datetime(ob[d+1].timestamp[1]))
                da               = split(string(low[v].timestamp[1]), "-")
                danext           = split(string(ob[d+1].timestamp[1]), "-")
                ob.values[d,6]   = string(datetime(int(da[1]),int(da[2]),int(da[3]),23,59,59,59))
                ob.values[d+1,6] = string(datetime(int(danext[1]),int(danext[2]),int(danext[3]),23,59,59,59))
                ob.values[d+1,5] = "closed"
                ob.values[d+2,5] = "open"
                break
            else  # bid is not filled
                #if  v <  length(timeseries[dt:nextdt]) - 1
                if  v < 6 
                    v += 1  
                else
                    ob.values[d,5]   = "not filled"
                    ob.values[d+1,5] = "not filled"
                    ob.values[d+2,5] = "open"
                    break
                end
            end
        end
    end
    # last row processing outside the loop above
        w          = 1
        x          = length(ob) 
        lastwindow = ob.timestamp[x]:timeseries.timestamp[end]
        lo         = timeseries[lastwindow]["Low"]
        hi         = timeseries[lastwindow]["High"]
        #while w <= length(timeseries[ob.timestamp[x]:timeseries.timestamp[end]])
        while w <= length(timeseries[lastwindow])
            if  lo.values[w] + slippage < float(ob.values[x,2]) < hi.values[w] - slippage # bid is inside market, sell fits here too
                ob.values[x,5]   = "closed"
                dal              = split(string(lo[w].timestamp[1]), "-")
                ob.values[x,6]   = string(datetime(int(dal[1]),int(dal[2]),int(dal[3]),23,59,59,59))
                break
            elseif float(ob.values[x,2])  > hi.values[w] - slippage # bid is above market
                ob.values[x,2]   = string(hi.values[w] - slippage)
                ob.values[x,5]   = "closed"
                dal              = split(string(lo[w].timestamp[1]), "-")
                ob.values[x,6]   = string(datetime(int(dal[1]),int(dal[2]),int(dal[3]),23,59,59,59))
                break
            else  # bid is not filled
                #if  v <  length(timeseries[dt:nextdt]) - 1
                if  w < 6 
                    w += 1  
                else
                    ob.values[x,5]   = "not filled"
                    break
                end
            end
        end
    b = Blotter(ob) 
    b,ob
end
