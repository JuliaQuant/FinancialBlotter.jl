# make up a mock ledger dataframe

srand(1) # set seed so random numbers are deterministic 
d   = DataFrame()
dt1 = date(2012,2,1)
dt2 = date(2012,2,5)
r   = dt1:days(1):dt2

d["Date"] = [r]
d["s1"] = int([ones(5)])
d["c1"] = [100, rand(4)*10+90]
d["r1"] = log_return(d["c1"])
d["s2"] = int([ones(5)])
d["c2"] = [100, rand(4)*10+100]
d["r2"] = log_return(d["c2"])

pnl = DataFrame()
pnl["Date"] = d["Date"]
pnl["PNL"] = [zeros(5)]

function tally()
  for i in 1:size(d, 1)
    produce(d[i,2] * d[i,4] + d[i,5] * d[i,7])
  end
end

p = Task(tally)

 for i = 1:size(pnl, 1)
   pnl["PNL"][i] = consume(p)
 end

