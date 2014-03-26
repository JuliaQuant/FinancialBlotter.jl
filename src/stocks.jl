abstract AbstractFinancialID
abstract AbstractInstrument

type CUSIP <: AbstractFinancialID
    id::String
end

type BloombergID <: AbstractFinancialID
    id::String
end

type ReutersID <: AbstractFinancialID
     id::String
end

type Stock <: AbstractInstrument
    ticker::String
    cusip::CUSIP
    currency::Currency
    tick::Float64
    multiplier::Float64
end

Stock(ticker::String, cusip::CUSIP) = Stock(ticker, cusip, Currency("USD"), .01, 1)

############ show #################

function show(io::IO, c::CUSIP)
    print(io, @sprintf("%s: %s", typeof(c), c.id))
end

function show(io::IO, c::ReutersID)
    print(io, @sprintf("%s: %s", typeof(c), c.id))
end

function show(io::IO, c::BloombergID)
    print(io, @sprintf("%s: %s", typeof(c), c.id))
end
