abstract AbstractFinancialDerivative

type OptionSeries <: AbstractFinancialDerivative
  ticker::String
  option_code::String
  expiry::CalendarTime
  calls::DataFrame
  puts::DataFrame
end
