abstract AbstractCurrency

type Currency <: AbstractCurrency
    origin::String
end

type CurrencyPair <: AbstractCurrency
    base_currency::Currency
    quote_currency::Currency
end
