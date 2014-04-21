import Base: show, getindex, length

type TradeAccount
    timestamp::Vector{DateTime{ISOCalendar,UTC}}
    values::Matrix{Float64}
    colnames::Vector{ASCIIString}
    portfolios::Vector{Portfolio} 

    function TradeAccount(timestamp::Vector{DateTime{ISOCalendar,UTC}}, 
                          values::Matrix{Float64}, 
                          colnames::Vector{ASCIIString},
                          portfolios::Vector{TradeAccount})
    
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

###### length ###################
###### length ###################
###### length ###################
###### length ###################
###### length ###################
###### length ###################

function length(b::TradeAccount)
    length(b.timestamp)
end

###### show #####################

function show(io::IO, ta::TradeAccount)
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
#            print_with_color(:green, io, lpad(rpad(iround(ta.values[i,j]), colwidth[j] + 2, " "), " ")) :
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
            # intcatcher[j] ?
            # print(io, rpad(iround(ta.values[i,j]), colwidth[j] + 2, " ")) :
            # print(io, rpad(round(ta.values[i,j], 2), colwidth[j] + 2, " "))
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
function getindex(b::TradeAccount, n::Int)
    TradeAccount(b.timestamp[n], b.values[n,:], b.colnames)
end

# range of rows
function getindex(b::TradeAccount, r::Range1{Int})
    TradeAccount(b.timestamp[r], b.values[r,:], b.colnames)
end

# array of rows
function getindex(b::TradeAccount, a::Array{Int})
    TradeAccount(b.timestamp[a], b.values[a,:], b.colnames)
end

# single column by name 
function getindex(b::TradeAccount, s::ASCIIString)
    n = findfirst(b.colnames, s)
    TradeAccount(b.timestamp, b.values[:, n], ASCIIString[s])
end

# array of columns by name
function getindex(b::TradeAccount, args::ASCIIString...)
    ns = [findfirst(b.colnames, a) for a in args]
    TradeAccount(b.timestamp, b.values[:,ns], ASCIIString[a for a in args])
end

# single date
#function getindex(b::TradeAccount, d::Date{ISOCalendar})
function getindex(b::TradeAccount, d::DateTime{ISOCalendar, UTC})
   for i in 1:length(b)
     if [d] == b[i].timestamp 
       return b[i] 
     else 
       nothing
     end
   end
 end
 
# range of dates
#function getindex(b::TradeAccount, dates::Array{Date{ISOCalendar},1})
function getindex(b::TradeAccount, dates::Array{DateTime{ISOCalendar,UTC},1})
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

function getindex(b::TradeAccount, r::DateRange{ISOCalendar}) 
    b[[r]]
end

# day of week
# getindex{T,N}(b::TradeAccount{T,N}, d::DAYOFWEEK) = b[dayofweek(b.timestamp) .== d]

