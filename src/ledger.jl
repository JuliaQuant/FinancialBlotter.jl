# make up a mock ledger dataframe

srand(1) # set seed so random numbers are deterministic 
d   = DataFrame()
dt1 = date(2012,2,1)
dt2 = date(2012,2,5)
r   = dt1:days(1):dt2

d["Date"] = [r]
d["s1"] = int([ones(5)])
d["c1"] = [100, rand(4)*10+90]
d["s2"] = int([ones(5)])
d["c2"] = [100, rand(4)*10+100]

pnl = DataFrame()
pnl["Date"] = d["Date"]
pnl["PNL"] = [zeros(5)]

function tally()
  for i in 1:nrow(d)
   #for j in [2,4]
      #produce(d[i,j] * d[i,j+1] + d[i,j+2] * d[i,j+3])
      produce(d[i,2] * d[i,3] + d[i,4] * d[i,5])
   # end
  end
end

p = Task(tally)

 for i = 1:nrow(pnl)
   pnl["PNL"][i] = consume(p)
 end

