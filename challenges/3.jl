struct coord
    x::Int
    y::Int
end

function main()
    input = readlines("inputs/3.txt")
    number_coords::Dict{Int, Array{Tuple{Int,Int}}} = Dict()
    symbol_coords::Dict{Int, Array{Int}} = Dict()
    active_tools::Array{Tuple{Int, Tuple{Int, Int}}} = []
    gear_sum = 0

    # Scan through the schematic and mark the coordinates of numbers and symbols
    for (y, line) in enumerate(input)
        number_coords[y] = [(x.offset, x.offset + length(x.match)-1) for x in eachmatch(r"\d+", line)]
        symbol_coords[y] = [x.offset for x in eachmatch(r"[^\.0123456789]", line)]        
    end

    # For each symbol coordinate , collect any number coordinates with a distance less than 2
    for (y, line) in symbol_coords
        for x in line
            num_adj = 0
            ratio = 1
            if (y != 1)
                adjacent = [(y-1, x_num) for x_num in number_coords[y-1] if (x_num[1] - 1 ≤ x ≤ x_num[2] + 1)]
                for adj in adjacent
                    num_adj += 1
                    ratio *= parse(Int, input[adj[1]][adj[2][1]:adj[2][2]])
                end
                append!(active_tools, adjacent)
            end
            
            if (y != length(input))
                adjacent = [(y+1, x_num) for x_num in number_coords[y+1] if (x_num[1] - 1 ≤ x ≤ x_num[2] + 1)]
                for adj in adjacent
                    num_adj += 1
                    ratio *= parse(Int, input[adj[1]][adj[2][1]:adj[2][2]])
                end
                append!(active_tools, adjacent)
            end
            
            adjacent = [(y, x_num) for x_num in number_coords[y] if (x_num[1] - 1 ≤ x ≤ x_num[2] + 1)]
            for adj in adjacent
                num_adj += 1
                ratio *= parse(Int, input[adj[1]][adj[2][1]:adj[2][2]])
            end
            append!(active_tools, adjacent)            
            
            if (num_adj == 2 && input[y][x] == '*')
                gear_sum += ratio
            end

        end
    end

    sum = 0
    for row in active_tools
        sum += parse(Int, input[row[1]][row[2][1]:row[2][2]])
    end
    @show sum
    @show gear_sum
end 

main()