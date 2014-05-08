using FinancialBlotter

tt = readdlm(Pkg.dir("FinancialBlotter/src/dev/t.csv"), '\t')

t  = convert(Array{Float64}, tt[2:end, 2:end])
cn = convert(Array{ASCIIString}, tt[1,2:end])
ct = convert(Array{ASCIIString}, [c for c in cn])
dt = convert(Vector{ASCIIString}, tt[2:end,1])
da = DateTime{ISOCalendar, UTC}[parsedatetime1(d) for d in dt];
td = TickData(da, t, ct, Stock(Ticker("Foo")))
