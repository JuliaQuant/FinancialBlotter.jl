using MarketData

facts("time-related utilities") do

  context("parsedatetime") do
      @fact 1 => roughly(1.0000000001) 
  end

  context("make datetime from array of Int") do
      @fact 1 => roughly(1.0000000001) 
  end

  context("convert date to datetime with the last second of the day") do
    @fact 1.0000000000000001 => roughly(1)
  end
end

facts("signal utilities") do

  context("discretesignal") do
    @fact_throws log(-1)
    @fact_throws sum(foo, bar)
  end
end

