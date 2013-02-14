abstract AbstractStock 

type Stock <: AbstractStock
  ticker::String
  idx::IndexedVector{CalendarTime}
  prices::DataFrame
  volume::DataArray{Int, 1}
  tick::Float64
end
