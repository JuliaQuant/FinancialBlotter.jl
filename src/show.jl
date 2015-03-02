###########################  Blotter

function show(io::IO, ta::Blotter)
  # variables
  nrow          = size(ta.values, 1)
  ncol          = size(ta.values, 2)
  intcatcher    = falses(ncol)
  for c in 1:ncol
      rowcheck =  trunc(ta.values[:,c]) - ta.values[:,c] .== 0
      if sum(rowcheck) == length(rowcheck)
          intcatcher[c] = true
      end
  end
  spacetime     = strwidth(string(ta.timestamp[1])) + 3
  firstcolwidth = strwidth(ta.colnames[1])
  colwidth      = Int[]
      for m in 1:ncol
          push!(colwidth, max(strwidth(ta.colnames[m]), strwidth(@sprintf("%.2f", maximum(ta.values[:,m])))))
      end

  # summary line
  println(io,"")
  #print(io,@sprintf("%dx%d %s %s to %s", nrow, ncol, typeof(ta), string(ta.timestamp[1]), string(ta.timestamp[nrow])))
  print(io,@sprintf("%dx%d Financial Blotter for Ticker *** %s ***, %s to %s",
                    nrow, ncol, string(ta.meta), string(ta.timestamp[1]), string(ta.timestamp[nrow])))
  println(io,"")

  # row label line
   print_with_color(:magenta, io, ^(" ", spacetime), ta.colnames[1], ^(" ", colwidth[1] + 2 -firstcolwidth))

   for p in 2:length(colwidth)
     print_with_color(:magenta, io, ta.colnames[p], ^(" ", colwidth[p] - strwidth(ta.colnames[p]) + 2))
   end
   println(io,"")

  # timestamp and values line
    if nrow > 7
        for i in 1:4
            print(io, ta.timestamp[i], " | ")
        for j in 1:ncol
            intcatcher[j] && ta.values[i,j] > 0?
            print_with_color(:green, io, rpad(iround(ta.values[i,j]), colwidth[j] + 2, " ")) :
            intcatcher[j] && ta.values[i,j] < 0 ?
            print_with_color(:red, io, rpad(iround(ta.values[i,j]), colwidth[j] + 2, " ")) :
            print_with_color(:blue, io, rpad(round(ta.values[i,j], 2), colwidth[j] + 2, " "))
        end
        println(io,"")
        end
        println(io,'\u22EE')
        for i in nrow-3:nrow
            print(io, ta.timestamp[i], " | ")
        for j in 1:ncol
            intcatcher[j] && ta.values[i,j] > 0?
            print_with_color(:green, io, rpad(iround(ta.values[i,j]), colwidth[j] + 2, " ")) :
            intcatcher[j] && ta.values[i,j] < 0 ?
            print_with_color(:red, io, rpad(iround(ta.values[i,j]), colwidth[j] + 2, " ")) :
            print_with_color(:blue, io, rpad(round(ta.values[i,j], 2), colwidth[j] + 2, " "))
        end
        println(io,"")
        end
    else
        for i in 1:nrow
            print(io, ta.timestamp[i], " | ")
        for j in 1:ncol
            intcatcher[j] ?
            print(io, rpad(iround(ta.values[i,j]), colwidth[j] + 2, " ")) :
            print(io, rpad(round(ta.values[i,j], 2), colwidth[j] + 2, " "))
        end
        println(io,"")
        end
    end
end





########################### Trade

# function show(io::IO, t::Trade)
#     print_with_color(:blue, io, @sprintf("%s:", string(t.start)))
#     print_with_color(:blue, io, @sprintf("%s ", string(t.finish)))
#     print_with_color(:yellow, io, @sprintf("%s ~ ", string(t.open)))
#     print_with_color(:yellow, io, @sprintf("%s ", string(t.close)))
#     if t.side == "long" && t.close - t.open> 0
#         print_with_color(:green, io, @sprintf("qty = "))
#     else
#         print_with_color(:red, io, @sprintf("qty = "))
#     end
#     print_with_color(:blue, io, @sprintf("%s", string(t.quantity)))
# end









# This code needs to be reduced by several fold, storing it here for now

###########################  Account

# function show(io::IO, ta::Account)
#   # variables
#   nrow          = size(ta.values, 1)
#   ncol          = size(ta.values, 2)
#   intcatcher    = falses(ncol)
#   for c in 1:ncol
#       rowcheck =  trunc(ta.values[:,c]) - ta.values[:,c] .== 0
#       if sum(rowcheck) == length(rowcheck)
#           intcatcher[c] = true
#       end
#   end
#   spacetime     = strwidth(string(ta.timestamp[1])) + 3
#   firstcolwidth = strwidth(ta.colnames[1])
#   colwidth      = Int[]
#       for m in 1:ncol
#           push!(colwidth, max(strwidth(ta.colnames[m]), strwidth(@sprintf("%.2f", maximum(ta.values[:,m])))))
#       end

#   # summary line
#   print(io,@sprintf("%dx%d %s %s to %s", nrow, ncol, typeof(ta), string(ta.timestamp[1]), string(ta.timestamp[nrow])))
#   println(io,"")
#   println(io,"")

#   # row label line
#    print_with_color(:magenta, io, ^(" ", spacetime), ta.colnames[1], ^(" ", colwidth[1] + 2 -firstcolwidth))

#    for p in 2:length(colwidth)
#      print_with_color(:magenta, io, ta.colnames[p], ^(" ", colwidth[p] - strwidth(ta.colnames[p]) + 2))
#    end
#    println(io,"")

#   # timestamp and values line
#     if nrow > 7
#         for i in 1:4
#             print(io, ta.timestamp[i], " | ")
#         for j in 1:ncol
#             intcatcher[j] && ta.values[i,j] > 0?
#             print_with_color(:green, io, rpad(iround(ta.values[i,j]), colwidth[j] + 2, " ")) :
#             intcatcher[j] && ta.values[i,j] < 0 ?
#             print_with_color(:red, io, rpad(iround(ta.values[i,j]), colwidth[j] + 2, " ")) :
#             print_with_color(:blue, io, rpad(round(ta.values[i,j], 2), colwidth[j] + 2, " "))
#         end
#         println(io,"")
#         end
#         println(io,'\u22EE')
#         for i in nrow-3:nrow
#             print(io, ta.timestamp[i], " | ")
#         for j in 1:ncol
#             intcatcher[j] && ta.values[i,j] > 0?
#             print_with_color(:green, io, rpad(iround(ta.values[i,j]), colwidth[j] + 2, " ")) :
#             intcatcher[j] && ta.values[i,j] < 0 ?
#             print_with_color(:red, io, rpad(iround(ta.values[i,j]), colwidth[j] + 2, " ")) :
#             print_with_color(:blue, io, rpad(round(ta.values[i,j], 2), colwidth[j] + 2, " "))
#         end
#         println(io,"")
#         end
#     else
#         for i in 1:nrow
#             print(io, ta.timestamp[i], " | ")
#         for j in 1:ncol
#             intcatcher[j] ?
#             print(io, rpad(iround(ta.values[i,j]), colwidth[j] + 2, " ")) :
#             print(io, rpad(round(ta.values[i,j], 2), colwidth[j] + 2, " "))
#         end
#         println(io,"")
#         end
#     end
# end


###########################  Portfolio

# function show(io::IO, ta::Portfolio)
#   # variables
#   nrow          = size(ta.values, 1)
#   ncol          = size(ta.values, 2)
#   intcatcher    = falses(ncol)
#   for c in 1:ncol
#       rowcheck =  trunc(ta.values[:,c]) - ta.values[:,c] .== 0
#       if sum(rowcheck) == length(rowcheck)
#           intcatcher[c] = true
#       end
#   end
#   spacetime     = strwidth(string(ta.timestamp[1])) + 3
#   firstcolwidth = strwidth(ta.colnames[1])
#   colwidth      = Int[]
#       for m in 1:ncol
#           push!(colwidth, max(strwidth(ta.colnames[m]), strwidth(@sprintf("%.2f", maximum(ta.values[:,m])))))
#       end

#   # summary line
#   print(io,@sprintf("%dx%d %s %s to %s", nrow, ncol, typeof(ta), string(ta.timestamp[1]), string(ta.timestamp[nrow])))
#   println(io,"")
#   println(io,"")

#   # row label line
#    print_with_color(:magenta, io, ^(" ", spacetime), ta.colnames[1], ^(" ", colwidth[1] + 2 -firstcolwidth))

#    for p in 2:length(colwidth)
#      print_with_color(:magenta, io, ta.colnames[p], ^(" ", colwidth[p] - strwidth(ta.colnames[p]) + 2))
#    end
#    println(io,"")

#   # timestamp and values line
#     if nrow > 7
#         for i in 1:4
#             print(io, ta.timestamp[i], " | ")
#         for j in 1:ncol
#             intcatcher[j] && ta.values[i,j] > 0?
#             print_with_color(:green, io, rpad(iround(ta.values[i,j]), colwidth[j] + 2, " ")) :
#             intcatcher[j] && ta.values[i,j] < 0 ?
#             print_with_color(:red, io, rpad(iround(ta.values[i,j]), colwidth[j] + 2, " ")) :
#             print_with_color(:blue, io, rpad(round(ta.values[i,j], 2), colwidth[j] + 2, " "))
#         end
#         println(io,"")
#         end
#         println(io,'\u22EE')
#         for i in nrow-3:nrow
#             print(io, ta.timestamp[i], " | ")
#         for j in 1:ncol
#             intcatcher[j] && ta.values[i,j] > 0?
#             print_with_color(:green, io, rpad(iround(ta.values[i,j]), colwidth[j] + 2, " ")) :
#             intcatcher[j] && ta.values[i,j] < 0 ?
#             print_with_color(:red, io, rpad(iround(ta.values[i,j]), colwidth[j] + 2, " ")) :
#             print_with_color(:blue, io, rpad(round(ta.values[i,j], 2), colwidth[j] + 2, " "))
#         end
#         println(io,"")
#         end
#     else
#         for i in 1:nrow
#             print(io, ta.timestamp[i], " | ")
#         for j in 1:ncol
#             intcatcher[j] ?
#             print(io, rpad(iround(ta.values[i,j]), colwidth[j] + 2, " ")) :
#             print(io, rpad(round(ta.values[i,j], 2), colwidth[j] + 2, " "))
#         end
#         println(io,"")
#         end
#     end
# end
