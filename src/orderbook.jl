import Base: show, getindex, length

type OrderBook <: AbstractTimeSeries

    #timestamp::Vector{DateTime{ISOCalendar,UTC}}
    timestamp::Vector{Date{ISOCalendar}}
    values::Matrix{ASCIIString}
    colnames::Vector{ASCIIString}
#    timeseries::Stock

    function OrderBook(timestamp::Vector{Date{ISOCalendar}}, 
                       values::Matrix{ASCIIString}, 
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

#OrderBook(t::Vector{DateTime{ISOCalendar,UTC}}, v::Matrix{ASCIIString}, c::Vector{ASCIIString}) = OrderBook(t,v,c)
#OrderBook(t::DateTime{ISOCalendar,UTC}, v::Matrix{ASCIIString}, c::Vector{ASCIIString}) = OrderBook([t], v, c)
OrderBook(t::Date{ISOCalendar}, v::Matrix{ASCIIString}, c::Vector{ASCIIString}) = OrderBook([t], v, c)

const orderbookbidvalues   = ["100" "123.12" "bid" "limit" "pending" "" "2.33"]
const orderbookoffervalues = ["100" "123.12" "bid" "limit" "pending" "" "2.33"]
const orderbooksellvalues  = ["100" "123.12" "sell" "market" "pending" "" "2.33"]
const orderbookcovervalues = ["100" "123.12" "sell" "market" "pending" "" "2.33"]
const orderbookcolnames    = ["Qty","Price","Side","Order", "Status", "Status Time", "Fees"]
#OrderBook() = OrderBook([datetime(1980,1,3)], orderbookbidvalues, orderbookcolnames) 
OrderBook() = OrderBook([date(1980,1,3)], orderbookbidvalues, orderbookcolnames) 

add!(ob::OrderBook, entry::OrderBook) = OrderBook(vcat(ob.timestamp, entry.timestamp), vcat(ob.values, entry.values), orderbookcolnames)

# merge
function merge(ob1::OrderBook, ob2::OrderBook)
    dt = sort(vcat(ob1.timestamp, ob2.timestamp))
    vals = fill("",length(dt),length(orderbookcolnames))
    for d in 1:length(dt)
        if ob1[dt[d]] != nothing
            vals[d,:] = ob1[dt[d]].values
        elseif ob2[dt[d]] != nothing
            vals[d,:] = ob2[dt[d]].values
        end
    end
    OrderBook(dt, vals, orderbookcolnames)
end

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

###### length ###################

function length(ob::OrderBook)
    length(ob.timestamp)
end

###### iterator protocol #########

# start(ob::OrderBook)   = 1
# next(ob::OrderBook,i)  = ((ob.timestamp[i],ob.values[i,:]),i+1)
# done(ob::OrderBook,i)  = (i > length(ob))
# isempty(ob::OrderBook) = (length(ob) == 0)

###### show #####################

function show(io::IO, ta::OrderBook)
  # variables 
  nrow          = size(ta.values, 1)
  ncol          = size(ta.values, 2)
  spacetime     = strwidth(string(ta.timestamp[1])) + 3
  firstcolwidth = strwidth(ta.colnames[1])
  colwidth      = Int[]
      for m in 1:ncol
          push!(colwidth, max(strwidth(ta.colnames[m]), maximum([strwidth(t) for t in ta.values[:,m]])))
      end

  # summary line
  print(io,@sprintf("%dx%d %s %s to %s", nrow, ncol, typeof(ta), string(ta.timestamp[1]), string(ta.timestamp[nrow])))
  println(io,"")
  println(io,"")

  # row label line
#   print(io, ^(" ", spacetime), ta.colnames[1], ^(" ", colwidth[1] + 2 -firstcolwidth))
   print_with_color(:magenta, io, ^(" ", spacetime), ta.colnames[1], ^(" ", colwidth[1] + 2 -firstcolwidth))

   for p in 2:length(colwidth)
     #print(io, ta.colnames[p], ^(" ", colwidth[p] - strwidth(ta.colnames[p]) + 2))
     print_with_color(:magenta, io, ta.colnames[p], ^(" ", colwidth[p] - strwidth(ta.colnames[p]) + 2))
   end
   println(io, "")
 
  # timestamp and values line
     if nrow > 7
         for i in 1:4
             print(io, ta.timestamp[i], " | ")
         for j in 1:ncol
            ta.values[i,j] == "open" || ta.values[i,j] == "bid" || ta.values[i,j] == "cover" ?
              print_with_color(:green, io, rpad(ta.values[i,j], colwidth[j] + 2, " ")) :
            ta.values[i,j] == "closed" || ta.values[i,j] == "offer" || ta.values[i,j] == "sell" ?
              print_with_color(:red, io, rpad(ta.values[i,j], colwidth[j] + 2, " ")) :
            ta.values[i,j] == "pending" ? 
              print_with_color(:yellow, io, rpad(ta.values[i,j], colwidth[j] + 2, " ")) :
            print_with_color(:blue, io, rpad(ta.values[i,j], colwidth[j] + 2, " ")) 
         end
         println(io,"")
         end
         println(io,'\u22EE')
         for i in nrow-3:nrow
             print(io, ta.timestamp[i], " | ")
         for j in 1:ncol
            ta.values[i,j] == "open" || ta.values[i,j] == "bid" || ta.values[i,j] == "cover" ?
              print_with_color(:green, io, rpad(ta.values[i,j], colwidth[j] + 2, " ")) :
            ta.values[i,j] == "closed" || ta.values[i,j] == "offer" || ta.values[i,j] == "sell" ?
              print_with_color(:red, io, rpad(ta.values[i,j], colwidth[j] + 2, " ")) :
            ta.values[i,j] == "pending" ? 
              print_with_color(:yellow, io, rpad(ta.values[i,j], colwidth[j] + 2, " ")) :
            print_with_color(:blue, io, rpad(ta.values[i,j], colwidth[j] + 2, " ")) 
         end
         println(io,"")
         end
     else
        for i in 1:nrow
            print(io, ta.timestamp[i], " | ")
        for j in 1:ncol
            ta.values[i,j] == "open" || ta.values[i,j] == "bid" || ta.values[i,j] == "cover" ?
              print_with_color(:green, io, rpad(ta.values[i,j], colwidth[j] + 2, " ")) :
            ta.values[i,j] == "closed" || ta.values[i,j] == "offer" || ta.values[i,j] == "sell" ?
              print_with_color(:red, io, rpad(ta.values[i,j], colwidth[j] + 2, " ")) :
            ta.values[i,j] == "pending" ? 
              print_with_color(:yellow, io, rpad(ta.values[i,j], colwidth[j] + 2, " ")) :
            print_with_color(:blue, io, rpad(ta.values[i,j], colwidth[j] + 2, " ")) 
        end
        println(io,"")
        end
    end
end

###### getindex #################

# single row
function getindex(b::OrderBook, n::Int)
    OrderBook(b.timestamp[n], b.values[n,:], b.colnames)
end

# range of rows
function getindex(b::OrderBook, r::Range1{Int})
    OrderBook(b.timestamp[r], b.values[r,:], b.colnames)
end

# array of rows
function getindex(b::OrderBook, a::Array{Int})
    OrderBook(b.timestamp[a], b.values[a,:], b.colnames)
end

# single column by name 
function getindex(b::OrderBook, s::ASCIIString)
    n = findfirst(b.colnames, s)
    OrderBook(b.timestamp, b.values[:, n], ASCIIString[s])
end

# array of columns by name
function getindex(b::OrderBook, args::ASCIIString...)
    ns = [findfirst(b.colnames, a) for a in args]
    OrderBook(b.timestamp, b.values[:,ns], ASCIIString[a for a in args])
end

# single date
#function getindex(b::OrderBook, d::Union(DateTime{ISOCalendar,UTC},Date{ISOCalendar}))
function getindex(b::OrderBook, d::Union(Date{ISOCalendar}))
   for i in 1:length(b)
     if [d] == b[i].timestamp 
       return b[i] 
     else 
       nothing
     end
   end
 end
 
# range of dates
#function getindex(b::OrderBook, dates::Array{Union(DateTime{ISOCalendar,UTC},Date{ISOCalendar})})
function getindex(b::OrderBook, dates::Array{Date{ISOCalendar}})
  counter = Int[]
#  counter = int(zeros(length(dates)))
  for i in 1:length(dates)
    if findfirst(b.timestamp, dates[i]) != 0
      #counter[i] = findfirst(b.timestamp, dates[i])
      push!(counter, findfirst(b.timestamp, dates[i]))
    end
  end
  b[counter]
end

function getindex(b::OrderBook, r::DateRange{ISOCalendar}) 
    b[[r]]
end

# day of week
# getindex{T,N}(b::OrderBook{T,N}, d::DAYOFWEEK) = b[dayofweek(b.timestamp) .== d]
