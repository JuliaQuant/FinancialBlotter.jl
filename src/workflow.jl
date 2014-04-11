# signal array sa  bid 

s          = (cl .> sma(cl,10))  # 496 row bools

# addorder -> [sa.timestamp + 1 unit of time] 
#          -> ["100" "sa.timestamp close" "long" "open" "" "2.33"]

tt         = lag(s)              # 495 row of bools, the next day
t          = discretesignal(tt)  # 78 rows of first true and first false, as floats though
entrydates = findwhen(t.==1)
exitdates  = findwhen(t.==0)
#entries    = OrderBook(DateTime{ISOCalendar,UTC}[datetime(dt) for dt in entrydates], repmat(orderbookbidvalues, length(entrydates)), orderbookcolnames)
entries    = OrderBook(entrydates, repmat(orderbookbidvalues, length(entrydates)), orderbookcolnames)
#exits      = OrderBook(DateTime{ISOCalendar,UTC}[datetime(dt) for dt in exitdates], repmat(orderbooksellvalues, length(exitdates)), orderbookcolnames)
exits      = OrderBook(exitdates, repmat(orderbooksellvalues, length(exitdates)), orderbookcolnames)

simfill  -> [sa.timestamp + 1 unit of time] was low + 2 ticks < bid < high - 2 ticks ?
            change status to closed and status time to date at midnight &&
            add timestamp, qty and price to blotter
signal array sa offer
