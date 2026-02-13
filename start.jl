"""
    prettyprint(m::Matrix{UInt8})

Prints a formatted representation of the matrix `m`. 
Aligns single-digit numbers by adding a leading space.
function prettyprint(m::Matrix{UInt8})
    for i in 1:size(m,1)
        for j in 1:size(m,2)
            #println(typeof(m[i,j]))

            (m[i,j]<UInt8(10)) && print(" ")
            print(m[i,j]," ")
        end
        println()
    end
end




# Create a 13x13 matrix of 8-bit unsigned integers (UInt8) initialized to 0
"""
    initme()

CONSTRUCTS `o_data` dictionary and populates the `original_matrix`.
"""
function initme()
    original_matrix = zeros(UInt8,13, 13)
    o_data = Dict()
    o_data[1]=[(7,9)]
    o_data[2]=[(10,2)]
    o_data[3]=[(7,5)]
    o_data[4]=[(8,10)]
    o_data[5]=[(3,4)]
    o_data[6]=[(5,11),(6,13)]
    o_data[7]=[(9,3)]   
    o_data[8]=[(4,8),(5,6)]
    o_data[9]=[(12,6),(13,9)]
    o_data[10]=[(9,12),(11,12)]
    o_data[11]=[(2,8),(3,9),(3,11)]
    o_data[12]=[(4,10),(4,12),(7,11),(9,8)]
    o_data[13]=[(8,1),(10,4),(11,3)]
    o_data[14]=[(10,9),(11,5),(11,7),(11,10)]
    o_data[15]=[(1,5),(3,2),(3,7),(4,5)]
    o_data[16]=[(5,2),(6,4),(7,3),(7,7),(10,6)]

    for i in 1:16
        for j in o_data[i]
            original_matrix[j[1],j[2]] = UInt8(i)
        end
    end

    println(original_matrix)

    prettyprint(original_matrix)



    original_data = Dict{UInt8, Tuple{Vararg{Tuple{UInt8, UInt8}}}}()

    for i in 1:16
        original_data[i] = Tuple(o_data[i])
    end

    println(original_data)


    println(length(original_data[UInt8(6)]))


end


initme()