# This code needs to be reduced by several fold, storing it here for now

###########################  Account
 
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
function getindex(b::TradeAccount, dates::Array{DateTime{ISOCalendar,UTC},1})
  counter = Int[]
  for i in 1:length(dates)
    if findfirst(b.timestamp, dates[i]) != 0
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

###########################  FinancialTimeSeries
 
# single row
function getindex(ft::FinancialTimeSeries, n::Int)
    FinancialTimeSeries(ft.timestamp[n], ft.values[n,:], ft.colnames, ft.instrument)
end

# range of rows
function getindex(ft::FinancialTimeSeries, r::Range1{Int})
    FinancialTimeSeries(ft.timestamp[r], ft.values[r,:], ft.colnames, ft.instrument)
end

# array of rows
function getindex(ft::FinancialTimeSeries, a::Array{Int})
    FinancialTimeSeries(ft.timestamp[a], ft.values[a,:], ft.colnames, ft.instrument)
end

# single column fty name 
function getindex(ft::FinancialTimeSeries, s::ASCIIString)
    n = findfirst(ft.colnames, s)
    FinancialTimeSeries(ft.timestamp, ft.values[:, n], ASCIIString[s], ft.instrument)
end

# array of columns fty name
function getindex(ft::FinancialTimeSeries, args::ASCIIString...)
    ns = [findfirst(ft.colnames, a) for a in args]
    FinancialTimeSeries(ft.timestamp, ft.values[:,ns], ASCIIString[a for a in args], ft.instrument)
end

# single date
function getindex(ft::FinancialTimeSeries, d::DateTime{ISOCalendar,UTC})
   for i in 1:length(ft)
     if [d] == ft[i].timestamp 
       return ft[i] 
     else 
       nothing
     end
   end
 end
 
# range of dates
function getindex(ft::FinancialTimeSeries, dates::Array{DateTime{ISOCalendar,UTC},1})
  counter = Int[]
  for i in 1:length(dates)
    if findfirst(ft.timestamp, dates[i]) != 0
      push!(counter, findfirst(ft.timestamp, dates[i]))
    end
  end
  ft[counter]
end

#### DOESN"T WORK #########

function getindex(ft::FinancialTimeSeries, r::DateTimeRange{ISOCalendar,UTC}) 
    ft[[r]]
end

# day of week
# getindex{T,N}(ft::FinancialTimeSeries{T,N}, d::DAYOFWEEK) = ft[dayofweek(ft.timestamp) .== d]

###########################  Blotter
 
# single row
function getindex(b::Blotter, n::Int)
    Blotter(b.timestamp[n], b.values[n,:], b.colnames, b.ticker)
end

# range of rows
function getindex(b::Blotter, r::Range1{Int})
    Blotter(b.timestamp[r], b.values[r,:], b.colnames, b.ticker)
end

# array of rows
function getindex(b::Blotter, a::Array{Int})
    Blotter(b.timestamp[a], b.values[a,:], b.colnames, b.ticker)
end

# single column by name 
function getindex(b::Blotter, s::ASCIIString)
    n = findfirst(b.colnames, s)
    Blotter(b.timestamp, b.values[:, n], ASCIIString[s], b.ticker)
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

###########################  Portfolio

# single row
function getindex(b::Portfolio, n::Int)
    Portfolio(b.timestamp[n], b.values[n,:], b.colnames)
end

# range of rows
function getindex(b::Portfolio, r::Range1{Int})
    Portfolio(b.timestamp[r], b.values[r,:], b.colnames)
end

# array of rows
function getindex(b::Portfolio, a::Array{Int})
    Portfolio(b.timestamp[a], b.values[a,:], b.colnames)
end

# single column by name 
function getindex(b::Portfolio, s::ASCIIString)
    n = findfirst(b.colnames, s)
    Portfolio(b.timestamp, b.values[:, n], ASCIIString[s])
end

# array of columns by name
function getindex(b::Portfolio, args::ASCIIString...)
    ns = [findfirst(b.colnames, a) for a in args]
    Portfolio(b.timestamp, b.values[:,ns], ASCIIString[a for a in args])
end

# single date
function getindex(b::Portfolio, d::DateTime{ISOCalendar, UTC})
   for i in 1:length(b)
     if [d] == b[i].timestamp 
       return b[i] 
     else 
       nothing
     end
   end
 end
 
# range of dates
function getindex(b::Portfolio, dates::Array{DateTime{ISOCalendar,UTC},1})
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

# DOESN'T WORK #########
function getindex(b::Portfolio, r::DateRange{ISOCalendar}) 
    b[[r]]
end

# day of week
# getindex{T,N}(b::Portfolio{T,N}, d::DAYOFWEEK) = b[dayofweek(b.timestamp) .== d]

