abstract AbstractCurrency

type Currency <: AbstractCurrency
    origin::String
end

type CurrencyPair <: AbstractCurrency
    baseside::Currency
    quoteside::Currency
end

############ show #################

function show(io::IO, c::Currency)
    print(io, @sprintf("%s", c.origin))
end

function show(io::IO, c::CurrencyPair)
    print(io, @sprintf("%s/%s", string(c.baseside), string(c.quoteside)))
end
