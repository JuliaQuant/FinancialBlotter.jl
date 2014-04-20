### ##########################################################
### ####
### #### import time series from yahoo or FRED and return DataFrame
### ####
### ##########################################################
### 
### ################# yahoo
### 
### function yahoo(stock::String, fm::Int, fd::Int, fy::Int, tm::Int, td::Int, ty::Int, period::String)
### 
### # take care of yahoo's 0 indexing for month
###   fm-=1
###   tm-=1
### 
###   ydata = download("http://ichart.finance.yahoo.com/table.csv?s=$stock&a=$fm&b=$fd&c=$fy&d=$tm&e=$td&f=$ty&g=$period", "y.csv")
###   df    = readtime("y.csv")
###   run(`rm y.csv`)
### 
###   return df
### end
### 
### ################# fred
### 
### function fred(econdata::String, colname::String)
### 
###   fdata = download("http://research.stlouisfed.org/fred2/series/$econdata/downloaddata/$econdata.csv", "f.csv")
###   df    = readtime("f.csv")
###   run(`rm f.csv`)
### 
###   return df
### end
### 
### ##########################################################
### ####
### #### import time series and return Stock object 
### ####
### ##########################################################
### 
### function yahoo_stock(stock::String, fm::Int, fd::Int, fy::Int, tm::Int, td::Int, ty::Int, period::String)
###   typed_stock = yahoo(stock, fm, fd, fy, tm, td, ty, period)
### 
###   res = Stock(stock, 
###               IndexedVector(typed_stock["Date"]), 
###               typed_stock[["Open", "High", "Low", "Close", "Adj"]], 
###               typed_stock["Vol"], 
###               .01)
### end
### 
### ##########################################################
### ####
### #### import Yahoo option series
### ####
### ##########################################################
### 
### function optionseries(ticker::String)
###   # code here to return a DataFrame
### end
### 
### function optionseries!(ticker::String)
###   # code here to return an OptionSeries object
### end
### 
### ############### DEFAULT ###########################
### 
### ## last three years, daily data
### yahoo(stock::String) = yahoo(stock::String, 
###                              month(now()), 
###                              day(now()), 
###                              year(now())-3, 
###                              month(now()),  
###                              day(now()), 
###                              year(now()), "d")
### 
### ## last three years, daily data
### yahoo_stock(stock::String) = yahoo(stock::String, 
###                              month(now()), 
###                              day(now()), 
###                              year(now())-3, 
###                              month(now()),  
###                              day(now()), 
###                              year(now()), "d")
### 
### ## name the fred column "VALUE"
### fred(econdata::String) = fred(econdata::String, "VALUE")
