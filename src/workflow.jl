# signal array sa  bid 
s          = (cl .> sma(cl,10))  # 496 row bools
tt         = lag(s)              # 495 row of bools, the next day
t          = discretesignal(tt)  # 78 rows of first true and first false, as floats though

# entries
entrydates = findwhen(t.==1)
entries    = OrderBook(entrydates, repmat(orderbookbidvalues, length(entrydates)), orderbookcolnames)
bidsignal  = findwhen(discretesignal(s).==1)
entryprice = (lo[bidsignal] .+ (hi[bidsignal] .- lo[bidsignal])/2).values
for i in 1:length(entries)
    entries.values[i,2] = string(round(entryprice[i],2))
end

# exits
exitdates  = findwhen(t.==0)
exits      = OrderBook(exitdates, repmat(orderbooksellvalues, length(exitdates)), orderbookcolnames)
exitprice  = op[exitdates].values .+ .1
for i in 1:length(exits)
    exits.values[i,2] = string(round(exitprice[i],2))
end

# combine into one book 
ob         = merge(entries,exits)

#entries    = OrderBook(DateTime{ISOCalendar,UTC}[datetime(dt) for dt in entrydates], repmat(orderbookbidvalues, length(entrydates)), orderbookcolnames)
#exits      = OrderBook(DateTime{ISOCalendar,UTC}[datetime(dt) for dt in exitdates], repmat(orderbooksellvalues, length(exitdates)), orderbookcolnames)

#### SIMFILL

# simfill  -> [sa.timestamp + 1 unit of time] was low + 2 ticks < bid < high - 2 ticks ?
#             change status to closed and status time to date at midnight &&
#             add timestamp, qty and price to blotter
# signal array sa offer

-> find row where status == open
-> try to fill it (test conditions)
    -> success without edge cases, then
        -> change status to "closed"
        -> fill status time with date and midnight time
        -> change status to "closed"
        -> change status of next row to "open"
        -> add row to blotter object
    -> success with edge cases, then
        -> same as without edge cases, but price must be adjusted to open - tick adjustment
    -> no success 
        -> keep trying until sell pending order, and then fill out both with "not filled" and open the next pending

-> objects returned include modified order book and a blotter


