# I think this might be in correct
# it claims to be correct by treating the µ vector as a scalar for single vector case
#function ∑matrix(x::Vector)
function sigma(x::Vector)
    y = x * mean(x)
    y * y'
end

function Shapiro_Wilks{T<:Float64}(x::Vector{T})
    sx = sort(x)
    d = Truncated(Normal(mean(xs),1),minimum(xs), maximum(xs))
    m = sort(rand(d, length(x)))
    #V = ∑matrix(sx)
    V = sigma(sx)
    a = m' * inv(V) / sqrt(m' * inv(V) * inv(V) * m)
    y - x.-mean(x)

    # ∑ ai * xi and then ^ 2
    # so a cross product and then square it
    # a'x ^ 2
    num = a'x ^ 2

    # ∑ (xi - xbar)  ^ 2
    # so first get y = xi - xbar vector
    # y'y
    den = y'y
    num/den
end

