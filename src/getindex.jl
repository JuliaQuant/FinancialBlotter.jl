# This code needs to be reduced by several fold, storing it here for now

###########################  Blotter & Account & Portfolio
 
# single row
function getindex(b::Union(Blotter,Account,Portfolio), n::Int)
    isa(b,Blotter) ?
    Blotter(b.timestamp[n], b.values[n,:], b.colnames) :
    isa(b,Account) ?
    Account(b.timestamp[n], b.values[n,:], b.colnames) :
    Portfolio(b.timestamp[n], b.values[n,:], b.colnames)
end

# range of rows
function getindex(b::Union(Blotter,Account,Portfolio), r::Range1{Int})
    isa(b,Blotter) ?
    Blotter(b.timestamp[r], b.values[r,:], b.colnames) :
    isa(b,Account) ?
    Account(b.timestamp[r], b.values[r,:], b.colnames) :
    Portfolio(b.timestamp[r], b.values[r,:], b.colnames)
end

# array of rows
function getindex(b::Union(Blotter,Account,Portfolio), a::Array{Int})
    isa(b,Blotter) ?
    Blotter(b.timestamp[a], b.values[a,:], b.colnames) :
    isa(b,Account) ?
    Account(b.timestamp[a], b.values[a,:], b.colnames) :
    Portfolio(b.timestamp[a], b.values[a,:], b.colnames) 
end

# single column by name 
function getindex(b::Union(Blotter,Account,Portfolio), s::ASCIIString)
    n = findfirst(b.colnames, s)
    isa(b,Blotter) ?
    Blotter(b.timestamp, b.values[:, n], ASCIIString[s]) :
    isa(b,Account) ?
    Account(b.timestamp, b.values[:, n], ASCIIString[s]) :
    Portfolio(b.timestamp, b.values[:, n], ASCIIString[s])
end

# array of columns by name
function getindex(b::Union(Blotter,Account,Portfolio), args::ASCIIString...)
    ns = [findfirst(b.colnames, a) for a in args]
    isa(b,Blotter) ?
    Blotter(b.timestamp, b.values[:,ns], ASCIIString[a for a in args]) :
    isa(b,Account) ?
    Account(b.timestamp, b.values[:,ns], ASCIIString[a for a in args]) :
    Portfolio(b.timestamp, b.values[:,ns], ASCIIString[a for a in args])
end

# single date
function getindex(b::Union(Blotter,Account,Portfolio), d::DateTime{ISOCalendar, UTC})
   for i in 1:length(b)
     if [d] == b[i].timestamp 
       return b[i] 
     else 
       nothing
     end
   end
 end
 
# range of dates
function getindex(b::Union(Blotter,Account,Portfolio), dates::Array{DateTime{ISOCalendar,UTC},1})
  counter = Int[]
  for i in 1:length(dates)
    if findfirst(b.timestamp, dates[i]) != 0
      push!(counter, findfirst(b.timestamp, dates[i]))
    end
  end
  b[counter]
end

function getindex(b::Union(Blotter,Account,Portfolio), r::DateRange{ISOCalendar}) 
    b[[r]]
end

# day of week
# getindex{T,N}(b::Union(Blotter,Account,Portfolio){T,N}, d::DAYOFWEEK) = b[dayofweek(b.timestamp) .== d]

# ###########################  Account
#  
# # single row
# function getindex(b::Account, n::Int)
#     Account(b.timestamp[n], b.values[n,:], b.colnames)
# end
# 
# # range of rows
# function getindex(b::Account, r::Range1{Int})
#     Account(b.timestamp[r], b.values[r,:], b.colnames)
# end
# 
# # array of rows
# function getindex(b::Account, a::Array{Int})
#     Account(b.timestamp[a], b.values[a,:], b.colnames)
# end
# 
# # single column by name 
# function getindex(b::Account, s::ASCIIString)
#     n = findfirst(b.colnames, s)
#     Account(b.timestamp, b.values[:, n], ASCIIString[s])
# end
# 
# # array of columns by name
# function getindex(b::Account, args::ASCIIString...)
#     ns = [findfirst(b.colnames, a) for a in args]
#     Account(b.timestamp, b.values[:,ns], ASCIIString[a for a in args])
# end
# 
# # single date
# function getindex(b::Account, d::DateTime{ISOCalendar, UTC})
#    for i in 1:length(b)
#      if [d] == b[i].timestamp 
#        return b[i] 
#      else 
#        nothing
#      end
#    end
#  end
#  
# # range of dates
# function getindex(b::Account, dates::Array{DateTime{ISOCalendar,UTC},1})
#   counter = Int[]
#   for i in 1:length(dates)
#     if findfirst(b.timestamp, dates[i]) != 0
#       push!(counter, findfirst(b.timestamp, dates[i]))
#     end
#   end
#   b[counter]
# end
# 
# function getindex(b::Account, r::DateRange{ISOCalendar}) 
#     b[[r]]
# end
# 
# # day of week
# # getindex{T,N}(b::Account{T,N}, d::DAYOFWEEK) = b[dayofweek(b.timestamp) .== d]
# 
# ###########################  Blotter
#  
# # single row
# function getindex(b::Blotter, n::Int)
#     Blotter(b.timestamp[n], b.values[n,:], b.colnames, b.ticker)
# end
# 
# # range of rows
# function getindex(b::Blotter, r::Range1{Int})
#     Blotter(b.timestamp[r], b.values[r,:], b.colnames, b.ticker)
# end
# 
# # array of rows
# function getindex(b::Blotter, a::Array{Int})
#     Blotter(b.timestamp[a], b.values[a,:], b.colnames, b.ticker)
# end
# 
# # single column by name 
# function getindex(b::Blotter, s::ASCIIString)
#     n = findfirst(b.colnames, s)
#     Blotter(b.timestamp, b.values[:, n], ASCIIString[s], b.ticker)
# end
# 
# # single date
# function getindex(b::Blotter, d::DateTime{ISOCalendar, UTC})
#    for i in 1:length(b)
#      if [d] == b[i].timestamp 
#        return b[i] 
#      else 
#        nothing
#      end
#    end
#  end
#  
# # range of dates
# function getindex(b::Blotter, dates::Array{DateTime{ISOCalendar,UTC},1})
#   counter = Int[]
#   for i in 1:length(dates)
#     if findfirst(b.timestamp, dates[i]) != 0
#       push!(counter, findfirst(b.timestamp, dates[i]))
#     end
#   end
#   b[counter]
# end
# 
# ## DOESN'T WORK because of DateTimeRange
# function getindex(b::Blotter, r::DateTimeRange{ISOCalendar,UTC}) 
#     b[[r]]
# end
# 
# # day of week
# # getindex{T,N}(b::Blotter{T,N}, d::DAYOFWEEK) = b[dayofweek(b.timestamp) .== d]
# 
# ###########################  Portfolio
# 
# # single row
# function getindex(b::Portfolio, n::Int)
#     Portfolio(b.timestamp[n], b.values[n,:], b.colnames)
# end
# 
# # range of rows
# function getindex(b::Portfolio, r::Range1{Int})
#     Portfolio(b.timestamp[r], b.values[r,:], b.colnames)
# end
# 
# # array of rows
# function getindex(b::Portfolio, a::Array{Int})
#     Portfolio(b.timestamp[a], b.values[a,:], b.colnames)
# end
# 
# # single column by name 
# function getindex(b::Portfolio, s::ASCIIString)
#     n = findfirst(b.colnames, s)
#     Portfolio(b.timestamp, b.values[:, n], ASCIIString[s])
# end
# 
# # array of columns by name
# function getindex(b::Portfolio, args::ASCIIString...)
#     ns = [findfirst(b.colnames, a) for a in args]
#     Portfolio(b.timestamp, b.values[:,ns], ASCIIString[a for a in args])
# end
# 
# # single date
# function getindex(b::Portfolio, d::DateTime{ISOCalendar, UTC})
#    for i in 1:length(b)
#      if [d] == b[i].timestamp 
#        return b[i] 
#      else 
#        nothing
#      end
#    end
#  end
#  
# # range of dates
# function getindex(b::Portfolio, dates::Array{DateTime{ISOCalendar,UTC},1})
#   counter = Int[]
# #  counter = int(zeros(length(dates)))
#   for i in 1:length(dates)
#     if findfirst(b.timestamp, dates[i]) != 0
#       #counter[i] = findfirst(b.timestamp, dates[i])
#       push!(counter, findfirst(b.timestamp, dates[i]))
#     end
#   end
#   b[counter]
# end
# 
# # DOESN'T WORK #########
# function getindex(b::Portfolio, r::DateRange{ISOCalendar}) 
#     b[[r]]
# end
# 
# # day of week
# # getindex{T,N}(b::Portfolio{T,N}, d::DAYOFWEEK) = b[dayofweek(b.timestamp) .== d]
