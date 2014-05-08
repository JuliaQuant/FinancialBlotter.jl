function parsedatetime(dt::String)
    res =  match(r"(\d{4})-(\d{2})-(\d{2})T(\d{2}):(\d{2}):(\d{2})\s(\w{3})",dt).captures
    datetime(int(res[1]),int(res[2]),int(res[3]),int(res[4]),int(res[5]),int(res[6]),0,eval(parse(res[7])))
end

function parsedatetime1(dt::String)
    res =  match(r"(\d{4})-(\d{2})-(\d{2})\s(\d{2}):(\d{2}):(\d{2})",dt).captures
    datetime(int(res[1]),int(res[2]),int(res[3]),int(res[4]),int(res[5]),int(res[6]),1)
end

function parsedatetime_from_TOS(dt::String)
    res =  match(r"(\d{1,2})/(\d{1,2})/(\d{2})\s(\d{2}):(\d{2}):(\d{2})",dt).captures
    datetime(2000+int(res[3]),int(res[1]),int(res[2]),int(res[4]),int(res[5]),int(res[6]))
end

function makedatetime(a::Array{Int64,1})
    datetime(a[1],a[2],a[3],a[4],a[5],a[6],a[7])
end

function datetolastsecond(datearray::Vector{Date{ISOCalendar}})
#function datetolastsecond(datearray::Array{DateTime{ISOCalendar,UTC},1})
    res = DateTime{ISOCalendar, UTC}[]
    for d in 1:length(datearray)
        dtarray = [int(split(string(datearray[d]),"-")),23,59,59,59]
        push!(res, makedatetime(dtarray))
    end
    res
end

function discretesignal(ba::TimeArray{Bool,1})
    iba = float64(ba.values)
    idx = [1]
    for b in 2:length(ba)
        if ba.values[b] !== ba.values[b-1]
            push!(idx, b)
        end
    end
    TimeArray(ba.timestamp[idx], iba[idx], ["signal"])
end
