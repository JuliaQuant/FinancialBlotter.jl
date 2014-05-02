function Blotter(ob::OrderBook) 
    counter = Int[]
    for b in 1:length(ob)
        if ob[b].values[5] == "closed"
            push!(counter,b)
        end
    end

    dstring = DateTime{ISOCalendar,UTC}[parsedatetime(ob[counter].values[d,6]) for d in 1:length(ob[counter])]

    vals = float(ob[counter].values[:,1:2])
    for s in 1:size(vals,1)
        if ob[counter].values[s,3] == "sell" || ob[counter].values[s,3] == "offer"
           vals[s,1] = flipsign(vals[s,1],-1) 
        end
    end

    Blotter(dstring, vals, blottercolnames, ob.ticker)
end


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

