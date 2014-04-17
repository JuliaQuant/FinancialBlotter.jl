import Base: show, getindex, length

type Blotter #<: AbstractTimeSeries
#type Blotter{T<:Offsets} #<: AbstractTimeSeries
#type Blotter{T,N} <: AbstractTimeSeries

    #timestamp::Vector{Date{ISOCalendar}}
    timestamp::Vector{DateTime{ISOCalendar,UTC}}
#    timestamp::Vector{DateTime{ISOCalendar,T}}
    #values::Array{T,N}
    values::Matrix{Float64}
    colnames::Vector{ASCIIString}
#    timeseries::Stock

    #function Blotter(timestamp::Vector{Date{ISOCalendar}}, values::Array{T,N}, colnames::Vector{ASCIIString})
    #function Blotter(timestamp::Vector{DateTime{ISOCalendar,UTC}}, values::Array{T,N}, colnames::Vector{ASCIIString})
    #function Blotter(timestamp::Vector{DateTime{ISOCalendar,UTC}}, values::Matrix{Float64}, colnames::Vector{ASCIIString})
    #function Blotter{T<:Offsets}(timestamp::Vector{DateTime{ISOCalendar,T}}, values::Matrix{Float64}, colnames::Vector{ASCIIString})
    function Blotter(timestamp::Vector{DateTime{ISOCalendar,UTC}}, values::Matrix{Float64}, colnames::Vector{ASCIIString})
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

# Blotter{T,N}(d::Vector{Date{ISOCalendar}}, v::Array{T,N}, c::Vector{ASCIIString}) = Blotter{T,N}(d,v,c)
# Blotter{T,N}(d::Date{ISOCalendar}, v::Array{T,N}, c::Array{ASCIIString,1}) = Blotter([d], v, c)
# Blotter(d::Vector{Date{ISOCalendar}}) = Blotter(d,zeros(length(d),2),["Qty","Fill"])

#Blotter{T,N}(d::Vector{DateTime{ISOCalendar,UTC}}, v::Array{T,N}, c::Vector{ASCIIString}) = Blotter{T,N}(d,v,c)
# Blotter(d::Vector{DateTime{ISOCalendar,UTC}}, v::Matrix{Float64}, c::Vector{ASCIIString}) = Blotter(d,v,c)
# Blotter(d::Vector{DateTime{ISOCalendar,UTC}}, v::Matrix{Float64}, c::Vector{ASCIIString}) = Blotter(d,v,c)
# from single date
#Blotter(d::DateTime{ISOCalendar,UTC}, v::Matrix{Float64}, c::Array{ASCIIString,1}) = Blotter([d], v, c)
#Blotter{T}(d::Vector{DateTime{ISOCalendar,T}}, v::Matrix{Float64}, c::Vector{ASCIIString}) = Blotter(d,v,c)

# Blotter(d::Vector{DateTime{ISOCalendar,UTC}}) = Blotter(d,zeros(length(d),2),["Qty","Fill"])

const blottercolnames = ["Qty", "Fill"]

Blotter() = Blotter([datetime(1795,10,31)], [0. 0], blottercolnames)

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

###### length ###################

function length(b::Blotter)
    length(b.timestamp)
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

# array of columns by name
function getindex(b::Blotter, args::ASCIIString...)
    ns = [findfirst(b.colnames, a) for a in args]
    Blotter(b.timestamp, b.values[:,ns], ASCIIString[a for a in args])
end

# single date
#function getindex(b::Blotter, d::Date{ISOCalendar})
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
#function getindex(b::Blotter, dates::Array{Date{ISOCalendar},1})
function getindex(b::Blotter, dates::Array{DateTime{ISOCalendar,UTC},1})
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

function getindex(b::Blotter, r::DateRange{ISOCalendar}) 
    b[[r]]
end

# day of week
# getindex{T,N}(b::Blotter{T,N}, d::DAYOFWEEK) = b[dayofweek(b.timestamp) .== d]

