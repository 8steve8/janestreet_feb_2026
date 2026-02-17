using Random

function benchmark()
    N = 1_000_000
    matrices = [BitMatrix(rand(Bool, 13, 13)) for _ in 1:N]

    # Custom key function
    function to_key(m::BitMatrix)::Tuple{UInt8,UInt8,UInt128,UInt64}
        r, c = size(m)
        if isempty(m.chunks)
            return (UInt8(r), UInt8(c), zero(UInt128), zero(UInt64))
        end
        c1 = m.chunks[1]
        c2 = length(m.chunks) >= 2 ? m.chunks[2] : zero(UInt64)
        c3 = length(m.chunks) >= 3 ? m.chunks[3] : zero(UInt64)
        p1 = UInt128(c1) | (UInt128(c2) << 64)
        return (UInt8(r), UInt8(c), p1, c3)
    end

    println("Benchmarking with N = $N iterations")

    # 1. BitMatrix Dict
    println("\n--- Dict{BitMatrix, Int} ---")
    d1 = Dict{BitMatrix,Int}()

    # Warmup
    d1[matrices[1]] = 1

    t0 = time_ns()
    count = 0
    for i in 1:N
        if !haskey(d1, matrices[i])
            d1[matrices[i]] = i
            count += 1
        else
            x = d1[matrices[i]]
        end
    end
    t1 = time_ns()
    println("Time: $((t1-t0)/1e9) seconds")
    println("Size: $(length(d1))")


    # 2. Tuple Key Dict
    println("\n--- Dict{Tuple{UInt8, UInt8, UInt128, UInt64}, Int} ---")
    d2 = Dict{Tuple{UInt8,UInt8,UInt128,UInt64},Int}()

    # Warmup
    k = to_key(matrices[1])
    d2[k] = 1

    t0 = time_ns()
    count = 0
    for i in 1:N
        k = to_key(matrices[i])
        if !haskey(d2, k)
            d2[k] = i
            count += 1
        else
            x = d2[k]
        end
    end
    t1 = time_ns()
    println("Time: $((t1-t0)/1e9) seconds")
    println("Size: $(length(d2))")
end

benchmark()
