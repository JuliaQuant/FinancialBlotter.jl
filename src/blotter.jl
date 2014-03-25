import Base: show, getindex, length

#type Blotter #<: AbstractTimeArray
type Blotter{T,N} #<: AbstractTimeArray

    timestamp::Vector{Date{ISOCalendar}}
    values::Array{T,N}
    colnames::Vector{ASCIIString}


    function Blotter(timestamp::Vector{Date{ISOCalendar}}, values::Array{T,N}, colnames::Vector{ASCIIString})
        nrow, ncol = size(values, 1), size(values, 2)
        nrow != size(timestamp, 1) ? error("values must match length of timestamp"):
        ncol != size(colnames,1) ? error("column names must match width of array"):
        timestamp != unique(timestamp) ? error("there are duplicate dates"):
        ~(flipud(timestamp) == sort(timestamp) || timestamp == sort(timestamp)) ? error("dates are mangled"):
        flipud(timestamp) == sort(timestamp) ? 
        new(flipud(timestamp), flipud(values), colnames):
        new(timestamp, values, colnames)
    end
#    Blotter(timestamp::Vector{Date{ISOCalendar}}) = Blotter(timestamp, zeros(length(timestamp), 2), ["Qty","Fill"])
end

Blotter{T,N}(d::Vector{Date{ISOCalendar}}, v::Array{T,N}, c::Vector{ASCIIString}) = Blotter{T,N}(d,v,c)
Blotter{T,N}(d::Date{ISOCalendar}, v::Array{T,N}, c::Array{ASCIIString,1}) = Blotter([d], v, c)
Blotter(d::Vector{Date{ISOCalendar}}) = Blotter(d,zeros(length(d),2),["Qty","Fill"])


###### length ###################

function length(b::Blotter)
    length(b.timestamp)
end

###### show #####################
 
function show(io::IO, b::Blotter)
  # variables 
  nrow          = size(b.values, 1)
  ncol          = size(b.values, 2)
  spacetime     = strwidth(string(b.timestamp[1])) + 3
  firstcolwidth = strwidth(b.colnames[1])
  colwidth      = Int[]
      for m in 1:ncol
          push!(colwidth, max(strwidth(b.colnames[m]), strwidth(@sprintf("%.2f", maximum(b.values[:,m])))))
      end

  # summary line
  print(io,@sprintf("%dx%d %s %s to %s", nrow, ncol, typeof(b), string(b.timestamp[1]), string(b.timestamp[nrow])))
  println(io,"")
  println(io,"")

  # row label line

   print(io, ^(" ", spacetime), b.colnames[1], ^(" ", colwidth[1] + 2 -firstcolwidth))

   for p in 2:length(colwidth)
     print(io, b.colnames[p], ^(" ", colwidth[p] - strwidth(b.colnames[p]) + 2))
   end
   println(io,"")
 
  # timestamp and values line
    if nrow > 7
        for i in 1:4
            print(io, b.timestamp[i], " | ")
        for j in 1:ncol
            print(io,rpad(round(b.values[i,j], 2), colwidth[j] + 2, " "))
        end
        println(io,"")
        end
        println(io,'\u22EE')
        for i in nrow-3:nrow
            print(io, b.timestamp[i], " | ")
        for j in 1:ncol
            print(io,rpad(round(b.values[i,j], 2), colwidth[j] + 2, " "))
        end
        println(io,"")
        end
    else
        for i in 1:nrow
            print(io, b.timestamp[i], " | ")
        for j in 1:ncol
            print(io,rpad(round(b.values[i,j], 2), colwidth[j] + 2, " "))
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
function getindex(b::Blotter, d::Date{ISOCalendar})
   for i in 1:length(b)
     if [d] == b[i].timestamp 
       return b[i] 
     else 
       nothing
     end
   end
 end
 
# range of dates
function getindex(b::Blotter, dates::Array{Date{ISOCalendar},1})
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





#    #function g(d, fm, to)
#    function g(d)
#      h = FramedPlot(title="Equity Curve")
#  #    x = lterows(d, fm)   #fm
#  #    x = gterows(d, to)   #to
#      x = [0:size(d, 1)]
#      y = equity(d["Close"])
#      y[1] = 1.0
#      pos = y .> 1  
#      neg = y .<= 1  
#      add(h, FillBetween(x[neg],y[neg],x,y,color=0x006bab5b))
#      add(h, FillBetween(x[pos],y[pos],x,y,color=0x00d66661))
#  #     add(h, Curve(y,x))
#      return h
#    end
