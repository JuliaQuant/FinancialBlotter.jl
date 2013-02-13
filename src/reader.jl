function fetch_asset(s::String, source::String)
  if source == "yahoo"
  #code here
  else if source == "fred"
  #code here
  else
  error("acceptable sources are yahoo or fred")
end

function read_asset(filename::String)
  #code here
end

#aliases

yahoo(s::String)  = fetch_asset(s::String, "yahoo") 
fred(s::String)  = fetch_asset(s::String, "fred") 

function yahoo(dir::String, filename::String)
end

function yahoo(stock::String, fm::Int, fd::Int, fy::Int, tm::Int, td::Int, ty::Int, period::String)
end

# default to last three years, daily data
yahoo(stock::String) = yahoo(stock::String, month(now()), day(now()), year(now())-3, month(now()),  day(now()), year(now()), "d")
