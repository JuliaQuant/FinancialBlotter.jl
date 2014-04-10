function parsedatetime(dt::String)
    res =  match(r"(\d{4})-(\d{2})-(\d{2})T(\d{2}):(\d{2}):(\d{2})\s(\w{3})",dt).captures
    datetime(int(res[1]),int(res[2]),int(res[3]),int(res[4]),int(res[5]),int(res[6]),0,eval(parse(res[7])))
end
