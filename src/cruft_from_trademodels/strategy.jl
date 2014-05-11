#   macro long(sa1::Array{SeriesPair,1}, ind::Function, op::Function, val::Union(Int, Float64), foo, sa2::Array{SeriesPair,1})
#   #macro long(sa, ind, op, val, foo, sa2)
#   
#     vec     = :($ind($sa))
#     sigdays = :($tradesignal($vec, $val, $op))
#     oprets  = :($lag($percentchange($sa2), 2))
#     trades  = :($oprets[$sigdays])
#     :($exp($sum($value($trades))) ^ (252/$length($sa2)) - 1)
#   end
#   
#   # what about a bid price generated from a model?
#   
#   
#   # proposed api
#   # @bid Goog TLTrsi AR(1) tradedays(3) targetexit([.005, .008, .01], [.4, .4, .2], signaltrue=true) stopout(.01, trailing=false)
#   macro bid(stock::Stock, sign::TradeSignal, bidprice::Function, duration::Date{ISOCalendar}, profit::Function, stopout::Function) 
#   
#   # stock is called to generate price
#   # sig may or may not be dependent on stock, but in any case is a type that includes truedates element
#   # bidprice is generated from a model 
#   # duration is how long the bid is out before expiring
#   # profit is the scaling of profit taking
#   # stopout is a risk management variable
#   
#   end
