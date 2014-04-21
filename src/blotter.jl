import Base: show, getindex, length

type Blotter <: AbstractTimeSeries

    timestamp::Vector{DateTime{ISOCalendar,UTC}}
    values::Matrix{Float64}
    colnames::Vector{ASCIIString}
#    timeseries::Stock

    function Blotter(timestamp::Vector{DateTime{ISOCalendar,UTC}}, 
                    values::Matrix{Float64},
                    colnames::Vector{ASCIIString})

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

const blottercolnames = ["Qty", "Fill"]

Blotter() = Blotter([datetime(1795,10,31)], [0. 0], blottercolnames)

add!(b::Blotter, entry::Blotter) = Blotter(vcat(b.timestamp, entry.timestamp), vcat(b.values, entry.values), blottercolnames)

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

    Blotter(dstring, vals, blottercolnames)
end

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

   Blotter(datetimes, [qty fills.values], blottercolnames)
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

###### show #####################

function show(io::IO, ta::Blotter)
  # variables 
  nrow          = size(ta.values, 1)
  ncol          = size(ta.values, 2)
  intcatcher    = falses(ncol)
  for c in 1:ncol
      rowcheck =  trunc(ta.values[:,c]) - ta.values[:,c] .== 0
      if sum(rowcheck) == length(rowcheck)
          intcatcher[c] = true
      end
  end
  spacetime     = strwidth(string(ta.timestamp[1])) + 3
  firstcolwidth = strwidth(ta.colnames[1])
  colwidth      = Int[]
      for m in 1:ncol
          push!(colwidth, max(strwidth(ta.colnames[m]), strwidth(@sprintf("%.2f", maximum(ta.values[:,m])))))
      end

  # summary line
  print(io,@sprintf("%dx%d %s %s to %s", nrow, ncol, typeof(ta), string(ta.timestamp[1]), string(ta.timestamp[nrow])))
  println(io,"")
  println(io,"")

  # row label line
   print_with_color(:magenta, io, ^(" ", spacetime), ta.colnames[1], ^(" ", colwidth[1] + 2 -firstcolwidth))

   for p in 2:length(colwidth)
     print_with_color(:magenta, io, ta.colnames[p], ^(" ", colwidth[p] - strwidth(ta.colnames[p]) + 2))
   end
   println(io,"")
 
  # timestamp and values line
    if nrow > 7
        for i in 1:4
            print(io, ta.timestamp[i], " | ")
        for j in 1:ncol
            intcatcher[j] && ta.values[i,j] > 0?
            print_with_color(:green, io, rpad(iround(ta.values[i,j]), colwidth[j] + 2, " ")) :
            intcatcher[j] && ta.values[i,j] < 0 ?
            print_with_color(:red, io, rpad(iround(ta.values[i,j]), colwidth[j] + 2, " ")) :
            print_with_color(:blue, io, rpad(round(ta.values[i,j], 2), colwidth[j] + 2, " "))
        end
        println(io,"")
        end
        println(io,'\u22EE')
        for i in nrow-3:nrow
            print(io, ta.timestamp[i], " | ")
        for j in 1:ncol
            intcatcher[j] && ta.values[i,j] > 0?
            print_with_color(:green, io, rpad(iround(ta.values[i,j]), colwidth[j] + 2, " ")) :
            intcatcher[j] && ta.values[i,j] < 0 ?
            print_with_color(:red, io, rpad(iround(ta.values[i,j]), colwidth[j] + 2, " ")) :
            print_with_color(:blue, io, rpad(round(ta.values[i,j], 2), colwidth[j] + 2, " "))
        end
        println(io,"")
        end
    else
        for i in 1:nrow
            print(io, ta.timestamp[i], " | ")
        for j in 1:ncol
            intcatcher[j] ?
            print(io, rpad(iround(ta.values[i,j]), colwidth[j] + 2, " ")) :
            print(io, rpad(round(ta.values[i,j], 2), colwidth[j] + 2, " "))
        end
        println(io,"")
        end
    end
end

###### getindex #################

# single row
function getindex(b::Blotter, n::Int)
    Blotter(b.timestamp[n], b.values[n,:], b.colnames)
end

# range of rows
function getindex(b::Blotter, r::Range1{Int})
    Blotter(b.timestamp[r], b.values[r,:], b.colnames)
end

# array of rows
function getindex(b::Blotter, a::Array{Int})
    Blotter(b.timestamp[a], b.values[a,:], b.colnames)
end

# single column by name 
function getindex(b::Blotter, s::ASCIIString)
    n = findfirst(b.colnames, s)
    Blotter(b.timestamp, b.values[:, n], ASCIIString[s])
end

# single date
function getindex(b::Blotter, d::DateTime{ISOCalendar, UTC})
   for i in 1:length(b)
     if [d] == b[i].timestamp 
       return b[i] 
     else 
       nothing
     end
   end
 end
 
# range of dates
function getindex(b::Blotter, dates::Array{DateTime{ISOCalendar,UTC},1})
  counter = Int[]
  for i in 1:length(dates)
    if findfirst(b.timestamp, dates[i]) != 0
      push!(counter, findfirst(b.timestamp, dates[i]))
    end
  end
  b[counter]
end

## DOESN'T WORK because of DateTimeRange
function getindex(b::Blotter, r::DateTimeRange{ISOCalendar,UTC}) 
    b[[r]]
end

# day of week
# getindex{T,N}(b::Blotter{T,N}, d::DAYOFWEEK) = b[dayofweek(b.timestamp) .== d]
