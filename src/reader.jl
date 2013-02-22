##########################################################
####
#### import time series from yahoo or FRED and return DataFrame
####
##########################################################

# function fetch_asset(s::String, source::String)
#   if source == "yahoo"
#     read_yahoo(s)
#   else if source == "fred"
#     read_fred(s) # this is broken not sure why
#   else
#     error("acceptable sources are yahoo or fred")
#   end
#   end
# end

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
function read_fred(econdata::String, colname::String)

  fdata = readlines(`curl -s "http://research.stlouisfed.org/fred2/series/$econdata/downloaddata/$econdata.csv"`)

  # values
  all_val = fdata[2:end] # all the column values including Date
  vals = map(x -> split(x, ","), all_val) # split each single row string into strings split on , 

  # get the time
  time_str = map(x -> x[:][1], vals) # take only the first column of values for time
  time_array = map(x -> parse("yyyy-MM-dd", x), 
                  convert(Array{UTF16String}, time_str)) # convert to CalendarTime type
  time_df = @DataFrame("Date" => time_array) # generate DF for later binding

  # get the value of second column 
  val_str = map(x -> x[:][2], vals) # take only the second column of values 
  val_array = map(x -> x == "" || x == ".\r\n" ? (x = NA) : (x = float(x)), val_str) #TODO clean this mess up
  val_df = @DataFrame($colname=> val_array)

  df = cbind(time_df, val_df)

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

## name the fred column "VALUE"
read_fred(econdata::String) = read_fred(econdata::String, "VALUE")

############### ALIASES ###########################

# yahoo(s::String)  = fetch_asset(s::String, "yahoo") 
# fred(s::String)   = fetch_asset(s::String, "fred") 

yahoo(s::String) = read_yahoo(s::String) 
fred(s::String) = read_fred(s::String)
fred(s::String, c::String) = read_fred(s::String, c::String)

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
  dfi   = @DataFrame(Date => time_array) 

# fill out values (NAs are now free) 
  dfval = df[:,2:end]

# re-attach first column as first column of original
  res   = cbind(dfi, dfval)

# first row is oldest date
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

function yahoo!(s::String)
  typed_stock = read_yahoo(s)

  res = Stock(s, 
              IndexedVector(typed_stock["Date"]), 
              typed_stock[["Open", "High", "Low", "Close", "Adj"]], 
              typed_stock["Vol"], 
              .01)
end

##########################################################
####
#### import Yahoo option series
####
##########################################################

function optionseries(ticker::String)
  # code here to return a DataFrame
end

function optionseries!(ticker::String)
  # code here to return an OptionSeries object
end
