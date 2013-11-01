##########################################################
####
#### import time series from yahoo or FRED and return DataFrame
####
##########################################################

################# yahoo

function yahoo(stock::String, fm::Int, fd::Int, fy::Int, tm::Int, td::Int, ty::Int, period::String)

# take care of yahoo's 0 indexing for month
  fm-=1
  tm-=1

  ydata = download("http://ichart.finance.yahoo.com/table.csv?s=$stock&a=$fm&b=$fd&c=$fy&d=$tm&e=$td&f=$ty&g=$period", "y.csv")
  df    = read_asset("y.csv")
  run(`rm y.csv`)

  return df
end

################# fred

function fred(econdata::String, colname::String)

  fdata = download("http://research.stlouisfed.org/fred2/series/$econdata/downloaddata/$econdata.csv", "f.csv")
  df    = read_asset("f.csv")
  run(`rm f.csv`)

  return df
end


##########################################################
####
#### import time series from a local directory
####
##########################################################

function read_asset(filename::String)

  df  = readtable(filename, nastrings=[".", "", "NA"])

# find the column named date
  typeof(df[1,1]) == Date{ISOCalendar}?
  df:

# find the column named date
  for col in colnames(df)
    ismatch(r"(?i)date", col)?
    df[col] = Date[date(d) for d in df[col]]:
    Nothing
  end

# create IndedxedVector
  for col in colnames(df)
    ismatch(r"(?i)date", col)?
    df[col] =  IndexedVector(df[col]):
    Nothing
  end

# enforce descending order
  for col in colnames(df)
    ismatch(r"(?i)date", col) && df[1,col] > df[2, col]?
    flipud!(df):
    Nothing
  end

  return df

end

##########################################################
####
#### import time series and return Stock object 
####
##########################################################

function yahoo_stock(stock::String, fm::Int, fd::Int, fy::Int, tm::Int, td::Int, ty::Int, period::String)
  typed_stock = yahoo(stock, fm, fd, fy, tm, td, ty, period)

  res = Stock(stock, 
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

############### DEFAULT ###########################

## last three years, daily data
yahoo(stock::String) = yahoo(stock::String, 
                             month(now()), 
                             day(now()), 
                             year(now())-3, 
                             month(now()),  
                             day(now()), 
                             year(now()), "d")

## last three years, daily data
yahoo!(stock::String) = yahoo(stock::String, 
                             month(now()), 
                             day(now()), 
                             year(now())-3, 
                             month(now()),  
                             day(now()), 
                             year(now()), "d")

## name the fred column "VALUE"
fred(econdata::String) = fred(econdata::String, "VALUE")
