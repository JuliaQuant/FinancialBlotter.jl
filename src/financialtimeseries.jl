import Base: show, getindex, length


type FinancialTimeSeries{T<:Float64,N} <: AbstractTimeSeries

    timestamp::Vector{Date{ISOCalendar}}
    values::Array{T,N}
    colnames::Vector{ASCIIString}
    instrument::AbstractInstrument

    function FinancialTimeSeries(timestamp::Vector{Date{ISOCalendar}}, values::Array{T,N}, colnames::Vector{ASCIIString}, instrument::AbstractInstrument)
        nrow, ncol = size(values, 1), size(values, 2)
        nrow != size(timestamp, 1) ? error("values must match length of timestamp"):
        ncol != size(colnames,1) ? error("column names must match width of array"):
        timestamp != unique(timestamp) ? error("there are duplicate dates"):
        ~(flipud(timestamp) == sort(timestamp) || timestamp == sort(timestamp)) ? error("dates are mangled"):
        flipud(timestamp) == sort(timestamp) ? 
        new(flipud(timestamp), flipud(values), colnames, instrument):
        new(timestamp, values, colnames, instrument)
    end
end

FinancialTimeSeries{T,N}(d::Vector{Date{ISOCalendar}}, v::Array{T,N}, c::Vector{ASCIIString}, t::AbstractInstrument) = FinancialTimeSeries{T,N}(d,v,c,t)
FinancialTimeSeries{T,N}(d::Date{ISOCalendar}, v::Array{T,N}, c::Array{ASCIIString,1}, t::AbstractInstrument) = FinancialTimeSeries([d],v,c,t)

###### show #####################
 
function show(io::IO, ft::FinancialTimeSeries)
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
 
  # timesftmp and values line
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

###### getindex #################

# single row
function getindex(ft::FinancialTimeSeries, n::Int)
    FinancialTimeSeries(ft.timestamp[n], ft.values[n,:], ft.colnames)
end

# range of rows
function getindex(ft::FinancialTimeSeries, r::Range1{Int})
    FinancialTimeSeries(ft.timestamp[r], ft.values[r,:], ft.colnames)
end

# array of rows
function getindex(ft::FinancialTimeSeries, a::Array{Int})
    FinancialTimeSeries(ft.timestamp[a], ft.values[a,:], ft.colnames)
end

# single column fty name 
function getindex(ft::FinancialTimeSeries, s::ASCIIString)
    n = findfirst(ft.colnames, s)
    FinancialTimeSeries(ft.timestamp, ft.values[:, n], ASCIIString[s])
end

# array of columns fty name
function getindex(ft::FinancialTimeSeries, args::ASCIIString...)
    ns = [findfirst(ft.colnames, a) for a in args]
    FinancialTimeSeries(ft.timestamp, ft.values[:,ns], ASCIIString[a for a in args])
end

# single date
function getindex(ft::FinancialTimeSeries, d::Date{ISOCalendar})
   for i in 1:length(ft)
     if [d] == ft[i].timestamp 
       return ft[i] 
     else 
       nothing
     end
   end
 end
 
# range of dates
function getindex(ft::FinancialTimeSeries, dates::Array{Date{ISOCalendar},1})
  counter = Int[]
  for i in 1:length(dates)
    if findfirst(ft.timestamp, dates[i]) != 0
      push!(counter, findfirst(ft.timestamp, dates[i]))
    end
  end
  ft[counter]
end

function getindex(ft::FinancialTimeSeries, r::DateRange{ISOCalendar}) 
    ft[[r]]
end

# day of week
# getindex{T,N}(ft::FinancialTimeSeries{T,N}, d::DAYOFWEEK) = ft[dayofweek(ft.timestamp) .== d]