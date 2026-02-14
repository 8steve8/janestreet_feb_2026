#yes


function prettyprint(m::Matrix{UInt8})
    for i in 1:size(m, 1)
        for j in 1:size(m, 2)
            #println(typeof(m[i,j]))

            (m[i, j] < UInt8(10)) && print(" ")
            if m[i, j] != 0
                printstyled(m[i, j], color=:green)
            else
                printstyled(m[i, j], color=:white)
            end
            print(" ")
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

function congruentshapes(shape::BitMatrix)::Tuple{Vararg{BitMatrix}}
    congruentshapes = Set{BitMatrix}()
    push!(congruentshapes, shape)
    push!(congruentshapes, rotr90(shape))
    push!(congruentshapes, rotl90(shape))
    push!(congruentshapes, reverse(shape))
    for el in collect(congruentshapes)
        push!(congruentshapes, reverse(el, dims=1))
    end
    return Tuple(sort(collect(congruentshapes), by=vec))
end


function nextshapes(shape::BitMatrix)::Tuple{Vararg{BitMatrix}}
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
    return Tuple(sort(collect(newshapes), by=vec))
end


function initme()
    originalmatrix = zeros(UInt8, 13, 13)
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

    originaldata = Dict{UInt8,Tuple{Vararg{Tuple{UInt8,UInt8}}}}()

    min_row = fill(typemax(UInt8), 16)
    max_row = fill(typemin(UInt8), 16)
    min_col = fill(typemax(UInt8), 16)
    max_col = fill(typemin(UInt8), 16)


    for i in 1:16
        originaldata[i] = Tuple(sort(data[i]))
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
        for j in originaldata[i]
            originalmatrix[j[1], j[2]] = UInt8(i)
        end
    end
    matrix = copy(originalmatrix)



    println(originaldata)

    println(originalmatrix)

    prettyprint(originalmatrix)

    println(data[2])
    push!(data[2], (11, 2))
    println(data[2])
    println(originaldata[2])


    N::UInt8 = 1
    #shapes = Dict{UInt8,BitMatrix}()
    shapes = Dict{UInt8,Tuple{Vararg{BitMatrix}}}()

    shapes[1] = Tuple([BitMatrix(trues(1, 1))])
    placement = [(0x00, 0x00) for _ in 1:16]

    matrix = zeros(UInt8, 13, 13)
    matrices = [zeros(UInt8, 13, 13) for _ in 1:16]
    matrices[1] = copy(originalmatrix)
    println("ok")

    shapeidx = ones(UInt8, 13)
    congruenceidx = ones(UInt8, 13)
    shapes[2] = nextshapes(shapes[1][1])
    congruent_shapes = congruentshapes(shapes[1][1])

    return
    while N < 17
        congruenceidx[N] += 1
        if congruenceidx[N] > length(congruent_shapes)
            congruenceidx[N] = 1
            shapeidx[N] += 1
            if shapeidx[N] > length(shapes[N])
                shapeidx[N] = 1
                N -= 1
                shapeidx[N] += 1
                shape = shapes[shapeidx[N]]
                congruent_shapes = congruentshapes(shape)
                continue
            end
        end

        shape = shapes[shapeidx[N]]
        congruent_shapes = congruentshapes(shape)

        for row in max(1, max_row[N] - size(shape, 1) + 1):min(13 - size(shape, 1) + 1, min_row[N])
            for col in max(1, max_col[N] - size(shape, 2) + 1):min(13 - size(shape, 2) + 1, min_col[N])
                for r in axes(shape, 1)
                    for c in axes(shape, 2)
                        if shape[r, c] && matrices[N][row+r-1, col+c-1] != 0 && matrices[N][row+r-1, col+c-1] != N
                            @goto does_not_fit
                        end
                    end
                end


                placement[N] = (row, col)
                matrices[N] = copy(matrices[N-1])
                for r in axes(shape, 1)
                    for c in axes(shape, 2)
                        if shape[r, c]
                            matrices[N][row+r-1, col+c-1] = N
                        end
                    end
                end

                @label does_not_fit
            end
        end



    end





    while true
        break
    end


end


initme()