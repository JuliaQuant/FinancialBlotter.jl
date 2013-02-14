abstract AbstractStock 

type Stock <: AbstractStock
  ticker::String
  ohlc::DataFrame
  volume::DataArray{Int, 1}
  adj::DataArray{Float64, 1}
  idx::IndexedVector{CalendarTime}
  tick_size::Float64
end
