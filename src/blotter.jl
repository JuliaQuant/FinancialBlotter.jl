type Blotter
  df::DataFrame
  start::Date{ISOCalendar}
  finish::Date{ISOCalendar}
  equityplot::FramedPlot

  #function g(d, fm, to)
  function g(d)
    h = FramedPlot(title="Equity Curve")
#    x = lterows(d, fm)   #fm
#    x = gterows(d, to)   #to
    x = [0:size(d, 1)]
    y = equity(d["Close"])
    y[1] = 1.0
    pos = y .> 1  
    neg = y .<= 1  
    add(h, FillBetween(x[neg],y[neg],x,y,color=0x006bab5b))
    add(h, FillBetween(x[pos],y[pos],x,y,color=0x00d66661))
#     add(h, Curve(y,x))
    return h
  end

Blotter(x) = new(x, x[1,"Date"], x[end,"Date"], g(x))
Blotter(x,y,z) = new(x, datetime(y), datetime(z), g(x,datetime(y),datetime(z)))
end

end
