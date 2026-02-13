#yes


function prettyprint(m::Matrix{UInt8})
    for i in 1:size(m, 1)
        for j in 1:size(m, 2)
            #println(typeof(m[i,j]))

            (m[i, j] < UInt8(10)) && print(" ")
            print(m[i, j], " ")
        end
        println()
    end
end

function prettyprint(m::BitMatrix)

    for i in axes(m, 1)
        for j in axes(m, 2)
            if m[i, j] == true
                printstyled('T', color=:green)
            elseif m[i, j] == false
                printstyled('F', color=:magenta)
            end
        end
        println()
    end
end

function congruentshapes(shape::BitMatrix)::Vector{BitMatrix}
    congruentshapes = Set{BitMatrix}()
    push!(congruentshapes, shape)
    push!(congruentshapes, rotr90(shape))
    push!(congruentshapes, rotl90(shape))
    push!(congruentshapes, reverse(shape))
    for el in collect(congruentshapes)
        push!(congruentshapes, reverse(el, dims=1))
    end
    return sort(collect(congruentshapes), by=vec)
end

function nextshapes(shape::BitMatrix)::Set{BitMatrix}
    newshapes = Set{BitMatrix}()
    newshape = [falses(size(shape)[1], 1) shape falses(size(shape)[1], 1)]
    newshape = [falses(1, size(newshape)[2]); newshape; falses(1, size(newshape)[2])]
    for x in axes(newshape, 1)
        for y in axes(newshape, 2)
            if newshape[x, y]
                continue
            end
            if (x > 1 && newshape[x-1, y]) || (x < size(newshape, 1) && newshape[x+1, y]) || (y > 1 && newshape[x, y-1]) || (y < size(newshape, 2) && newshape[x, y+1])

                tempshape = copy(newshape)
                tempshape[x, y] = true
                if x != 1
                    tempshape = tempshape[2:end, :]
                end
                if x != size(newshape, 1)
                    tempshape = tempshape[1:end-1, :]
                end
                if y != 1
                    tempshape = tempshape[:, 2:end]
                end
                if y != size(newshape, 2)
                    tempshape = tempshape[:, 1:end-1]
                end

                push!(newshapes, congruentshapes(tempshape)[1])

            end
        end
    end
    return newshapes
end


function initme()
    original_matrix = zeros(UInt8, 13, 13)
    data = Dict()
    data[1] = [(7, 9)]
    data[2] = [(10, 2)]
    data[3] = [(7, 5)]
    data[4] = [(8, 10)]
    data[5] = [(3, 4)]
    data[6] = [(5, 11), (6, 13)]
    data[7] = [(9, 3)]
    data[8] = [(4, 8), (5, 6)]
    data[9] = [(12, 6), (13, 9)]
    data[10] = [(9, 12), (11, 12)]
    data[11] = [(2, 8), (3, 9), (3, 11)]
    data[12] = [(4, 10), (4, 12), (7, 11), (9, 8)]
    data[13] = [(8, 1), (10, 4), (11, 3)]
    data[14] = [(10, 9), (11, 5), (11, 7), (11, 10)]
    data[15] = [(1, 5), (3, 2), (3, 7), (4, 5)]
    data[16] = [(5, 2), (6, 4), (7, 3), (7, 7), (10, 6)]

    original_data = Dict{UInt8,Tuple{Vararg{Tuple{UInt8,UInt8}}}}()

    min_row = fill(typemax(UInt8), 16)
    max_row = fill(typemin(UInt8), 16)
    min_col = fill(typemax(UInt8), 16)
    max_col = fill(typemin(UInt8), 16)


    for i in 1:16
        original_data[i] = Tuple(sort(data[i]))
        data[i] = Set(data[i])
        for j in data[i]
            min_row[i] = min(min_row[i], j[1])
            max_row[i] = max(max_row[i], j[1])
            min_col[i] = min(min_col[i], j[2])
            max_col[i] = max(max_col[i], j[2])
        end
    end
    println("min_row = ", min_row)
    println("max_row = ", max_row)
    println("min_col = ", min_col)
    println("max_col = ", max_col)


    for i in 1:16
        for j in original_data[i]
            original_matrix[j[1], j[2]] = UInt8(i)
        end
    end



    println(original_data)

    println(original_matrix)

    prettyprint(original_matrix)

    println(data[2])
    push!(data[2], (11, 2))
    println(data[2])
    println(original_data[2])


    N::UInt8 = 1
    shapes = Dict{UInt8,BitMatrix}()
    shapes[1] = BitMatrix(trues(1, 1))

    matrix = zeros(UInt8, 13, 13)
    println("ok")
    nextshapes2 = nextshapes(shapes[1])
    for i in nextshapes2
        prettyprint(i)
        println()
    end
    println("done")




    while true
        break
    end


end


initme()