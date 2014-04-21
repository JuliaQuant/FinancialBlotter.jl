using MarketData

facts("constructors") do

  context("inner constructor enforces constraints") do
      @fact 1 => roughly(1.0000000001) 
  end

  context("empty constructor") do
      @fact 1 => roughly(1.0000000001) 
  end

  context("add entry to existing Blotter object") do
    @fact 1.0000000000000001 => roughly(1)
  end

  context("constructed from orderbook") do
    @fact 1.0000000000000001 => roughly(1)
  end

  context("constructed from signal and FinancialTimeSeries") do
    @fact 1.0000000000000001 => roughly(1)
  end

  context("fillblotter") do
    @fact 1.0000000000000001 => roughly(1)
  end
end

facts("base imports") do

  context("length is correct") do
    @fact_throws log(-1)
    @fact_throws sum(foo, bar)
  end

  context("getindex from single Int") do
    @fact_throws log(-1)
  end

  context("getindex from Int array") do
    @fact_throws log(-1)
  end

  context("getindex from colname") do
    @fact_throws log(-1)
  end

  context("getindex from single date") do
    @fact_throws log(-1)
  end

  context("getindex from date array") do
    @fact_throws log(-1)
  end

  context("getindex from date range") do
    @fact_throws log(-1)
  end
end

