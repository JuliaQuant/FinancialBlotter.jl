abstract AbstractStock <: AbstractAsset

type Stock <: AbstractStock
  id::String
  currency::String
  multiplier::Float64
  tick_size ::Float64
end
