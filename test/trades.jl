using MarketData

facts("roughly") do

  context("one") do
      @fact 1 => roughly(1.0000000001) 
  end

  context("one again") do
    @fact 1.0000000000000001 => roughly(1)
  end

end

facts("errors register") do

  context("errors") do
    @fact_throws log(-1)
    @fact_throws sum(foo, bar)
  end
end

