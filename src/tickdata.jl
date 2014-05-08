type TickData{T<:Float64,N} <: AbstractTimeSeries

    timestamp::Vector{DateTime{ISOCalendar,UTC}}
    values::Array{T,N}
    colnames::Vector{ASCIIString}
    instrument::AbstractInstrument

    function TickData(timestamp::Vector{DateTime{ISOCalendar,UTC}}, 
                      values::Array{T,N},
                      colnames::Vector{ASCIIString},
                      instrument::AbstractInstrument)

                      v = findfirst(colnames .== "Volume") # first sort the values in ascending order
                      vals = sortrows(values, by=x->x[v])
                      nrow, ncol = size(values, 1), size(values, 2)
                      nrow != size(timestamp, 1) ? error("values must match length of timestamp"):
                      ncol != size(colnames,1) ? error("column names must match width of array"):
                      ~(flipud(timestamp) == sort(timestamp) || timestamp == sort(timestamp)) ? error("dates are mangled"):
                      flipud(timestamp) == sort(timestamp) ? 
                      new(flipud(timestamp), vals, colnames, instrument): # then the dates if necessary
                      new(timestamp, vals, colnames, instrument)
    end
end

TickData{T<:Float64,N}(d::Vector{DateTime{ISOCalendar,UTC}}, v::Array{T,N}, c::Vector{ASCIIString}, t::AbstractInstrument) = TickData{T,N}(d,v,c,t)
TickData{T<:Float64,N}(d::DateTime{ISOCalendar,UTC}, v::Array{T,N}, c::Array{ASCIIString,1}, t::AbstractInstrument) = TickData([d],v,c,t)

########################### TickData 
 
function show(io::IO, ft::TickData)
  # variables 
  nrow          = size(ft.values, 1)
  ncol          = size(ft.values, 2)
  intcatcher    = falses(ncol)
  for c in 1:ncol
      rowcheck =  trunc(ft.values[:,c]) - ft.values[:,c] .== 0
      if sum(rowcheck) == length(rowcheck)
          intcatcher[c] = true
      end
  end
  spacetime     = strwidth(string(ft.timestamp[1])) + 3
  firstcolwidth = strwidth(ft.colnames[1])
  colwidth      = Int[]
      for m in 1:ncol
          push!(colwidth, max(strwidth(ft.colnames[m]), strwidth(@sprintf("%.2f", maximum(ft.values[:,m])))))
      end

  # summary line
  print(io,@sprintf("%dx%d %s %s to %s", nrow, ncol, typeof(ft), string(ft.timestamp[1]), string(ft.timestamp[nrow])))
  println(io,"")
  println(io,"")

  # row label line
   print(io, ^(" ", spacetime), ft.colnames[1], ^(" ", colwidth[1] + 2 -firstcolwidth))

   for p in 2:length(colwidth)
     print(io, ft.colnames[p], ^(" ", colwidth[p] - strwidth(ft.colnames[p]) + 2))
   end
   println(io,"")
 
  # timestamp and values line
    if nrow > 7
        for i in 1:4
            print(io, ft.timestamp[i], " | ")
        for j in 1:ncol
            intcatcher[j] ?
            print(io, rpad(iround(ft.values[i,j]), colwidth[j] + 2, " ")) :
            print(io, rpad(round(ft.values[i,j], 2), colwidth[j] + 2, " "))
        end
        println(io,"")
        end
        println(io,'\u22EE')
        for i in nrow-3:nrow
            print(io, ft.timestamp[i], " | ")
        for j in 1:ncol
            intcatcher[j] ?
            print(io, rpad(iround(ft.values[i,j]), colwidth[j] + 2, " ")) :
            print(io, rpad(round(ft.values[i,j], 2), colwidth[j] + 2, " "))
        end
        println(io,"")
        end
    else
        for i in 1:nrow
            print(io, ft.timestamp[i], " | ")
        for j in 1:ncol
            intcatcher[j] ?
            print(io, rpad(iround(ft.values[i,j]), colwidth[j] + 2, " ")) :
            print(io, rpad(round(ft.values[i,j], 2), colwidth[j] + 2, " "))
        end
        println(io,"")
        end
    end
end

########################### TickData 
 
# single row
function getindex(ft::TickData, n::Int)
    TickData(ft.timestamp[n], ft.values[n,:], ft.colnames, ft.instrument)
end

# range of rows
function getindex(ft::TickData, r::Range1{Int})
    TickData(ft.timestamp[r], ft.values[r,:], ft.colnames, ft.instrument)
end

# array of rows
function getindex(ft::TickData, a::Array{Int})
    TickData(ft.timestamp[a], ft.values[a,:], ft.colnames, ft.instrument)
end

# single column fty name 
function getindex(ft::TickData, s::ASCIIString)
    n = findfirst(ft.colnames, s)
    TickData(ft.timestamp, ft.values[:, n], ASCIIString[s], ft.instrument)
end

# array of columns fty name
function getindex(ft::TickData, args::ASCIIString...)
    ns = [findfirst(ft.colnames, a) for a in args]
    TickData(ft.timestamp, ft.values[:,ns], ASCIIString[a for a in args], ft.instrument)
end

# single date
function getindex(ft::TickData, d::DateTime{ISOCalendar,UTC})
   for i in 1:length(ft)
     if [d] == ft[i].timestamp 
       return ft[i] 
     else 
       nothing
     end
   end
 end
 
# range of dates
function getindex(ft::TickData, dates::Array{DateTime{ISOCalendar,UTC},1})
  counter = Int[]
  for i in 1:length(dates)
    if findfirst(ft.timestamp, dates[i]) != 0
      push!(counter, findfirst(ft.timestamp, dates[i]))
    end
  end
  ft[counter]
end

#### DOESN"T WORK #########

function getindex(ft::TickData, r::DateTimeRange{ISOCalendar,UTC}) 
    ft[[r]]
end

# day of week
# getindex{T,N}(ft::TickData{T,N}, d::DAYOFWEEK) = ft[dayofweek(ft.timestamp) .== d]
