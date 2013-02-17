##########################################################
####
#### import time series from yahoo or FRED 
####
##########################################################

function fetch_asset(s::String, source::String)
  if source == "yahoo"
    read_yahoo(s)
  else if source == "fred"
    read_fred(s)
  else
    error("acceptable sources are yahoo or fred")
  end
  end
end

################# read_yahoo
function read_yahoo(stock::String, fm::Int, fd::Int, fy::Int, tm::Int, td::Int, ty::Int, period::String)

# take care of yahoo's 0 indexing for month
  fm-=2
  tm-=1

  ydata = readlines(`curl -s "http://ichart.finance.yahoo.com/table.csv?s=$stock&a=$fm&b=$fd&c=$fy&d=$tm&e=$td&f=$ty&g=$period"`)
  name_string = ydata[1]
  val_string = ydata[2:end]

  sa  = split(val_string[1], ",")'
  for i in 2:length(val_string) 
    sa  = [sa ; split(val_string[i], ",")']
  end

  time_array = map(x -> parse("yyyy-MM-dd", x), 
                        convert(Array{UTF16String}, sa[:,1]))

  df = DataFrame(quote
     Date  = $time_array
     Open  = float($sa[:,2])
     High  = float($sa[:,3])
     Low   = float($sa[:,4])
     Close = float($sa[:,5])
     Vol   =   int($sa[:,6])
     Adj   = float($sa[:,7])
     end)

  flipud(df)
end

################# read_fred
function read_fred(econdata::String)

  fdata = readlines(`curl -s "http://research.stlouisfed.org/fred2/series/$econdata/downloaddata/$econdata.csv"`)

  # names
  name_string   = fdata[1] # header for the file
  allname_array = split(name_string, ",") # take the header and split it into separate strings
  name_array    = allname_array[2:end] # not interested in the first one which is Date
  number_names  = length(name_array) # total the number of col names for future iteration

  # values
  val_string = fdata[2:end] # all the column values including Date
  str_array = map(x -> split(x, ","), val_string) # split each single row string into strings split on , 

  # get the time
  time_str   = map(x -> x[:][1], str_array) # take only the first column of values for time
  time_array = map(x -> parse("yyyy-MM-dd", x), 
                  convert(Array{UTF16String}, time_str)) # convert to CalendarTime type
  time_df    = @DataFrame("Date" => time_array) # generate DF for later binding
                                                  
#   # hack to replace missingness with NA via 99
#   foo = fill("a", length(val_string))
#   for i in 1:length(val_string)
#     foo[i] = replace(sa[i,2], ".\r\n", "99")
#   end
  

  # hack to replace missingness with NA via 99
  val_str = map(x -> x[:][2], str_array) # take only the second column of values 
  temp_val_array = map(x -> x == "" || x == ".\r\n" ? (x = 99.) : (x = float(x)), val_str)
  temp_df = @DataFrame(value  => temp_val_array)
  nadf    = map(x -> x == 99 ? (x = NA) : (x = x), temp_df[1])

  
#   df = DataFrame(quote
#      Date  = $time_array
#      Value = float($foo)
#      end)
  
 # hack to get NAs into the df where there was originally missing data
 #  for i in 1:nrow(df)
 #    if df[i,2] == 99.0
 #      df[i,2] = NA
 #     end
 #   end  

  df = cbind(time_df, nadf)

  df
end

############### DEFAULT ###########################

## last three years, daily data
read_yahoo(stock::String) = read_yahoo(stock::String, 
                                       month(now()), 
                                       day(now()), 
                                       year(now())-3, 
                                       month(now()),  
                                       day(now()), 
                                       year(now()), "d")

############### ALIASES ###########################

yahoo(s::String)  = fetch_asset(s::String, "yahoo") 
fred(s::String)   = fetch_asset(s::String, "fred") 

##########################################################
####
#### import time series from a local directory
####
##########################################################

function read_asset(filename::String)

  df  = read_table(filename)

# capture the first column as Date  
  time_array = map(x -> parse("yyyy-MM-dd", x), 
                   convert(Array{UTF16String}, vector(df[:,1])))
#  dfi   = @DataFrame(Date => time_array) # this doesn't show "Date" but a hex string instead
   dfi   = DataFrame(quote Date = $time_array end)

# fill missing values with NA
  dfval = df[:,2:end]

# re-attach first column as first column of original
  res   = cbind(dfi, dfval)

# insure first row is oldest date
  if day(res[1,1]) > day(res[2,1]) 
    res = flipud(res)
  end
  res
end

##########################################################
####
#### import time series and return Stock object with bang
####
##########################################################

function fetch_asset!(s::String, source::String)
  if source == "yahoo"
    typed_stock = read_yahoo(s)
  else if source == "fred"
#    typed_stock = read_fred(s)
    print_with_color(:yellow, "work in progress")
    println()
  else
  error("acceptable sources are yahoo or fred")
  end
  end
  # need control flow, this case only applies to Yahoo format
#  if source == "yahoo"
  res = Stock(s, 
              IndexedVector(typed_stock["Date"]), 
              typed_stock[["Open", "High", "Low", "Close", "Adj"]], 
              typed_stock["Vol"], 
              .01)
#  end
end


yahoo!(s::String) = fetch_asset!(s::String, "yahoo") 
fred!(s::String)  = fetch_asset!(s::String, "fred") 
