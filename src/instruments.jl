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

############ const ################

const USD = Currency("USD")
const GBP = Currency("GBP")
const EUR = Currency("EUR")
const AUD = Currency("AUD")
const NZD = Currency("NZD")
const JPY = Currency("JPY")

const EURUSD = CurrencyPair(EUR,USD)
const EURJPY = CurrencyPair(EUR,JPY)
const AUDUSD = CurrencyPair(AUD,USD)
const NZDUSD = CurrencyPair(NZD,USD)
const GBPUSD = CurrencyPair(GBP,USD)
const USDJPY = CurrencyPair(USD,JPY)

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

