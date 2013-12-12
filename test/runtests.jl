using Base.Test
using FinancialBlotter

my_tests = ["blotter.jl", 
            "currencies.jl", 
            "futures.jl", 
            "io.jl", 
            "ledger.jl", 
            "notes.jl", 
            "options.jl", 
            "plots.jl", 
            "stocks.jl"]

print_with_color(:cyan, "Running tests: ") 
println("")

for my_test in my_tests
    print_with_color(:magenta, "**   ") 
    print_with_color(:blue, "$my_test") 
    println("")
    include(my_test)
end
