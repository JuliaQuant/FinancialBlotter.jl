using MarketData

facts("constructors") do

  context("Ticker") do
      @fact 1 => roughly(1.0000000001) 
  end

  context("CUSIP") do
      @fact 1 => roughly(1.0000000001) 
  end

  context("BloombergID") do
      @fact 1 => roughly(1.0000000001) 
  end

  context("ReutersID") do
      @fact 1 => roughly(1.0000000001) 
  end

  context("Currency") do
      @fact 1 => roughly(1.0000000001) 
  end

  context("CurrencyPair") do
      @fact 1 => roughly(1.0000000001) 
  end

  context("Stock default constructor") do
      @fact 1 => roughly(1.0000000001) 
  end

  context("Stock from Ticker") do
      @fact 1 => roughly(1.0000000001) 
  end
end
