function plotequity(df::DataFrame, col::String, fm::Int, 
                                                fd::Int, 
                                                fy::Int, 
                                                tm::Int, 
                                                td::Int, 
                                                ty::Int)
  # shape the time series
  d = gterows(df, fm,fd,fy)   #from
  d = lterows(d, tm,td,ty)   #to
  x = [0:nrow(d)]
  y = equity(d[col]) # take the column passed into function
  y[1] = 1.0    # replace NA with starting equity
  push!(y, 1.0) # get back to even for plotting

  # build the plot
  pos = y .>= 1.  
  neg = y .<= 1. 
  h = FramedPlot(title="Equity Curve")
  add(h, FillBetween(x[neg],y[neg],x,y,color=0x006bab5b))
  add(h, FillBetween(x[pos],y[pos],x,y,color=0x00d66661))
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


### fills in correctly cropped with one color
### add(h, FillBetween(x,y1, x,y, color="green"))

