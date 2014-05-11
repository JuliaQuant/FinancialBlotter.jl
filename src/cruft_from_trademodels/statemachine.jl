# trades are filled state

function transact()
    for i in 1:6
        produce(print_with_color(:green, "trade has been filled"))
    end
end

t = Task(transact)

# prime numbers are the transition to the next state, where nothing is filled

function statemachine()
    j = 1
      while j < 5
        for k in 13:51
            if isprime(k)
                consume(t)
                println("")
                sleep(1)
                j+=1
            else
                print_with_color(:red, @sprintf("%d ",k))
                println("")
            end
        end
    end
end
