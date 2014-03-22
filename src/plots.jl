



# function plotequity(df::DataFrame, col::String, fm::Int, 
#                                                 fd::Int, 
#                                                 fy::Int, 
#                                                 tm::Int, 
#                                                 td::Int, 
#                                                 ty::Int)
#   # shape the time series
#   d = gterows(df, fm,fd,fy)   #from
#   d = lterows(d, tm,td,ty)   #to
#   x = [0:size(d, 1)-1]
#   y = equity(d[col]) # take the column passed into function
#   y[1] = 1.0    # replace NA with starting equity
# 
#   # useful plot variables
#   neg  = y .< 1. 
#   y1   = ones(length(y))
#   onlybad = Float64[]
#   for i in 1:length(neg)
#     if neg[i] == false
#       push!(onlybad, 1.0)
#     else
#       j=i
#       push!(onlybad, y[j])
#     end
#   end
# 
#   # build plot with canonical Julia colors
#   h = FramedPlot(title="Equity Curve")
#   add(h, FillBetween(x,y1, x,y, color=0x6bab5b))
#   add(h, FillBetween(x,onlybad, x,y1, color=0xd66661))
#   add(h, Curve(x,y, color=0x3b972e))
#   add(h, Curve(x,onlybad, color=0xc93d39))
#   add(h, Curve(x,y1, color=0xffffff))
#   return h
# end
# 
# # default to using the entire date range
# plotequity(df::DataFrame) =
# plotequity(df::DataFrame, "Close", int(month(df[1,1])),
#                                    int(day(df[1,1])),
#                                    int(year(df[1,1])),
#                                    int(month(df[size(df, 1),1])),
#                                    int(day(df[size(df, 1),1])),
#                                    int(year(df[size(df, 1),1]))) 
