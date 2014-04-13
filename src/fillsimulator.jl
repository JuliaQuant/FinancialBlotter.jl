###### -> find row where status == open
###### -> try to fill it (test conditions)
######     -> success without edge cases, then
######         -> change status to "closed"
######         -> fill status time with date and midnight time
######         -> change status of next row to "open"
######         -> add row to blotter object
######     -> success with edge cases, then
######         -> same as without edge cases, but price must be adjusted to open - tick adjustment
######     -> no success 
######         -> keep trying until sell pending order, and then fill out both with "not filled" and open the next pending
###### 
###### -> objects returned include modified order book and a blotter

function fillblotter!(ob::OrderBook, timeseries::TimeArray{Float64,2})

    # find row that is open and store date
    if findfirst(ob.values .== "open") != 0 
        idx = findfirst(ob.values .== "open") - 4length(ob)
        dt  = ob[idx].timestamp[1]
    end

    # test if OHLC[date] passes test

    consume(Task(fillbook))

    # find row that is open in new orderbook and store date


    newob, b
end

function fillbook()
    produce("change status to closed")
    produce("fill out status time")
    produce("make next row open")
    produce("stamp blotter")
end
