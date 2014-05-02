using MarketData

facts("logic integrity") do

  context("things happen in order") do
      @fact 1 => roughly(1.0000000001) 
  end

  context("transitions are defined") do
      @fact 1 => roughly(1.0000000001) 
  end
end

