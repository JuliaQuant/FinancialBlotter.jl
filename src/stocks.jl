abstract AbstractFinancialID
abstract AbstractStock 

type CUSIP <: AbstractFinancialID
    id::String
end

type BloombergID <: AbstractFinancialID
    id::String
end

type ReutersID < :AbstractFinancialID
    id::String
end

type Stock <: AbstractStock
    ticker::String
    cusip::CUSIP
    currency::Currency
    tick::Float64
    prices::TimeArray
    multiplier::Float64
end
