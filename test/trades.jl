using MarketData

facts("constructors") do

  context("inner constructor enforces constraints") do
      @fact 1 => roughly(1.0000000001) 
  end

  context("from Blotter and FinancialTimeSeries") do
      @fact 1 => roughly(1.0000000001) 
  end
end

facts("array of Trades") do

  context("closed trades") do
    @fact_throws log(-1)
  end

  context("opening trades") do
    @fact_throws log(-1)
  end

  context("create an array of trades") do
    @fact_throws log(-1)
  end
end

