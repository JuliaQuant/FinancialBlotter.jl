abstract AbstractFinancialDerivative

type OptionSeries <: AbstractFinancialDerivative
  root::String
  option_code::String
  expiry::CalendarTime
  calls::DataFrame
  puts::DataFrame
end
