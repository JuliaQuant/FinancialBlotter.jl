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
  colstring = ydata[1]
  numstring = ydata[2:end]
  sa  = split(numstring[1], ",")'

  for i in 2:length(numstring) 
    sa  = [sa ; split(numstring[i], ",")']
  end

  time_conversion = map(x -> parse("yyyy-MM-dd", x), convert(Array{UTF16String}, sa[:,1]))

  df = DataFrame(quote
     Date  = $time_conversion
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


#  startdate = string(fy, "-", fm, "-", fd)
#  enddate   = string(ty, "-", tm, "-", td)
#  apikey = "47535fa5db345b924d890ec189a33036"
#  fdata = readlines(`curl -s "http://api.stlouisfed.org/fred/series/observations?series_id=$stock&realtime_start=$startdate&realtime_end=$enddate&api_key=$apikey"`)


  colstring = fdata[1]
  numstring = fdata[2:end]
  sa        = split(numstring[1], ",")'

  # this is an ugly bottleneck
  for i in 1:length(numstring) 
    sa  = [sa ; split(numstring[i], ",")']
  end


   # hack to replace missingness with NA via 99
   foo = fill("a", length(numstring))
   for i in 1:length(numstring)
     foo[i] = replace(sa[i,2], ".\r\n", "99")
   end

  time_conversion = map(x -> parse("yyyy-MM-dd", x), convert(Array{UTF16String}, sa[:,1]))

  df = DataFrame(quote
     Date  = $time_conversion
     Value = float($foo)
     end)
  
 # hack to get NAs into the df where there was originally missing data
  for i in 1:nrow(df)
    if df[i,2] == 99.0
      df[i,2] = NA
     end
   end  
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
  
  time_conversion = map(x -> parse("yyyy-MM-dd", x), 
                       convert(Array{UTF16String}, vector(df[:,1])))
  within!(df, quote
          Date = $(time_conversion)
          end)
  
  flipud(df)
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
  res = Stock(s, 
              IndexedVector(typed_stock["Date"]), 
              typed_stock[["Open", "High", "Low", "Close", "Adj"]], 
              typed_stock["Vol"], 
              .01)
end


yahoo!(s::String) = fetch_asset!(s::String, "yahoo") 
fred!(s::String)  = fetch_asset!(s::String, "fred") 
