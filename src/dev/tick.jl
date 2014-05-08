t = [datetime(2011,09,13,13,53,36)  
     datetime(2011,09,13,13,53,44)   
     datetime(2011,09,13,13,53,49) 
     datetime(2011,09,13,13,53,54)  
     datetime(2011,09,13,14,32,53)  
     datetime(2011,09,13,14,35,04)  ]

v1 = [ 5.8 5.83 5.9 6.0 5.95 5.88] 
v2 = [ 1.0 3.0 1.0 20.0 12.4521 7.458]

ticks = FinancialTimeSeries(t, [v1, v2]', ["price","amount"], Stock(Ticker("ASDS")))

dt = DateTimeRange(datetime(2011,9,13,13,55,00), minutes(5), 4)

