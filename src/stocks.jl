abstract AbstractStock 

type Stock <: AbstractStock
  ticker::String
  idx::IndexedVector{CalendarTime}
  prices::DataFrame
  volume::DataArray{Int, 1}
  tick_size::Float64
end
