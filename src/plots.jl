function plotequity(df::DataFrame, col::String, fm::Int, 
                                                fd::Int, 
                                                fy::Int, 
                                                tm::Int, 
                                                td::Int, 
                                                ty::Int)
  # shape the time series
  d = gterows(df, fm,fd,fy)   #from
  d = lterows(d, tm,td,ty)   #to
  x = [0:nrow(d)-1]
  y = equity(d[col]) # take the column passed into function
  y[1] = 1.0    # replace NA with starting equity
#  push!(y, 1.0) # get back to even for plotting

  # useful plot variables
  neg  = y .< 1. 
  y1   = ones(length(y))
  wash = Float64[]
  for i in 1:length(neg)
    if neg[i] == false
      push!(wash, 1.0)
    else
      j=i
      push!(wash, y[j])
    end
  end

  # build plot
  h = FramedPlot(title="Equity Curve")
  add(h, FillBetween(x,y1, x,y, color=0x6bab5b))
  add(h, FillBetween(x,wash, x,y1, color=0xd66661))
  add(h, Curve(x,y))
  return h
end

# default to using the entire date range
plotequity(df::DataFrame) =
plotequity(df::DataFrame, "Close", int(month(df[1,1])),
                                   int(day(df[1,1])),
                                   int(year(df[1,1])),
                                   int(month(df[nrow(df),1])),
                                   int(day(df[nrow(df),1])),
                                   int(year(df[nrow(df),1]))) 
