using Base.Test
using FinancialBlotter

let

# make up a mock ledger dataframe

#srand(1) # set seed so random numbers are deterministic 
d   = DataFrame()
dt1 = date(2012,2,1)
dt2 = date(2012,2,5)
r   = dt1:days(1):dt2

d["Date"] = [r]
d["s1"]   = int([ones(5)])
d["r1"] = log_return(DataArray([100, 103, 110, 106, 100]))
d["s2"] = int([ones(5)])
d["r2"] = log_return(DataArray([100, 99, 92, 89, 100]))

pnl = DataFrame()
pnl["Date"] = d["Date"]
pnl["dailyPNL"] = [zeros(5)]

function tally()
  for i in 1:size(d, 1)
    produce(d[i,2] * d[i,3] + d[i,4] * d[i,5])
  end
end

p = Task(tally)

for i = 1:size(pnl, 1)
  pnl["dailyPNL"][i] = consume(p)
end

f(x) = expm1(sum(x))
pnl["RollingSimple"] = float(upto(pnl["dailyPNL"], f))

########### assertions

@assert 0  == pnl[5, "RollingSimple"]   
#@assert 0.02  == pnl[2, "RollingSimple"]   

end
