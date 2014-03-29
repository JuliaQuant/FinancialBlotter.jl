abstract AbstractFinancialID
abstract AbstractCurrency
abstract AbstractInstrument

type Ticker 
    id::String
end

type CUSIP <: AbstractFinancialID
    id::String
end

type BloombergID <: AbstractFinancialID
    id::String
end

type ReutersID <: AbstractFinancialID
     id::String
end

type Currency <: AbstractCurrency
    origin::String
end

type CurrencyPair <: AbstractCurrency
    baseside::Currency
    quoteside::Currency
end

type Stock <: AbstractInstrument
    ticker::Ticker
    #cusip::CUSIP
#    id::Dict{typeof(AbstractInstrument),AbstractInstrument}
#    id::Dict(typeof(AbstractFinancialID)=>AbstractFinancialID)[]
    currency::Currency
    tick::Float64
    multiplier::Float64
end

#Stock(ticker::Ticker) = Stock(ticker, [CUSIP=>CUSIP("123")], USD, .01, 1)
Stock(ticker::Ticker) = Stock(ticker, USD, .01, 1)

############ show #################

function show(io::IO, c::CUSIP)
    print(io, @sprintf("%s", c.id))
end

function show(io::IO, c::ReutersID)
    print(io, @sprintf("%s", c.id))
end

function show(io::IO, c::BloombergID)
    print(io, @sprintf("%s", c.id))
end

function show(io::IO, t::Ticker)
    print(io, @sprintf("%s", t.id))
end

function show(io::IO, s::Stock)
    println(io, @sprintf("ticker:         %s", s.ticker))
    println(io, @sprintf("cusip:          %s", s.cusip))
    println(io, @sprintf("currency:       %s", s.currency))
    println(io, @sprintf("tick:           %s", s.tick))
    println(io, @sprintf("multiplier:     %s", s.multiplier))
end

function show(io::IO, c::Currency)
    print(io, @sprintf("%s", c.origin))
end

function show(io::IO, c::CurrencyPair)
    print(io, @sprintf("%s/%s", string(c.baseside), string(c.quoteside)))
end

############ const ################

const USD = Currency("USD")
const GBP = Currency("GBP")
const EUR = Currency("EUR")
const AUD = Currency("AUD")
const JPY = Currency("JPY")

const F = "Jan"
const G = "Feb"
const H = "Mar"
const J = "Apr"
const K = "May"
const M = "Jun"
const N = "Jul"
const Q = "Aug"
const U = "Sep"
const X = "Oct"
const V = "Nov"
const Z = "Dec"
