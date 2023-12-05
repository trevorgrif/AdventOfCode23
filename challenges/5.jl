function main()
    input = readlines("inputs/5.txt")

    # Extract the seed numbers (Part 1)
    seed_list = input[1]
    seed_list = split(seed_list, " ")[2:end]
    seed_list = filter(x -> x != "", seed_list)
    seed_list = parse.(Int, seed_list)

    # The minimal seed in part 1 was 1038807941 which is a seed in set 2
    # We can limit our search to locations less than or equal to 403695602
    location_range = range(start = 0, step = 1, length = 403695602)
    seed_list_2 = Iterators.partition(seed_list, 2)

    # Extract the maps
    maps = Dict(
        "seed_to_soil" => input[4:15],
        "soil_to_fertilizer" => input[18:46],
        "fertilizer_to_water" => input[49:76],
        "water_to_light" => input[79:97],
        "light_to_temperature" => input[100:135],
        "temperature_to_humidity" => input[138:161],
        "humidity_to_location" => input[164:183],
    )

    # Convert the string types to integer types
    maps_converted = Dict()

    for (map, data) in maps
        maps_converted[map] = parse_map(data)
    end

    # Pass each seed through the maps
    location_min = typemax(Int)
    seed_success = 0
    for seed in seed_list
        location = pipeline(maps_converted, seed)
        if location < location_min
            seed_success = seed
            location_min = location
        end
    end
    @show seed_success
    @show location_min

    # Part 2: starting with the smallest closest location
    # Run the inverse map until we get a valid seed
    for location in location_range # solution in first location range, no need to check location_range_2
        seed = pipeline_reversed(maps_converted, location)
        for seed_range in seed_list_2
            if  seed_range[1] ≤ seed < (seed_range[1] + seed_range[2]) 
                @show seed
                @show location
                return
            end
        end
    end
end

function get_mapped_value(map, value)
    row_idx = findfirst(x -> x[2] ≤ value < (x[2] + x[3]), map)
    if (row_idx === nothing)
        return value
    end
    return map[row_idx][1] + (value - map[row_idx][2])
end

function inverse_map(map, value)
    row_idx = findfirst(x -> x[1] ≤ value < (x[1] + x[3]), map)
    if (row_idx === nothing)
        return value
    end
    return map[row_idx][2] + (value - map[row_idx][1])
end

function pipeline(maps_converted, seed)
    soil = get_mapped_value(maps_converted["seed_to_soil"], seed)
    fertilizer = get_mapped_value(maps_converted["soil_to_fertilizer"], soil)
    water = get_mapped_value(maps_converted["fertilizer_to_water"], fertilizer)
    light = get_mapped_value(maps_converted["water_to_light"], water)
    temperature = get_mapped_value(maps_converted["light_to_temperature"], light)
    humidity = get_mapped_value(maps_converted["temperature_to_humidity"], temperature)
    location = get_mapped_value(maps_converted["humidity_to_location"], humidity)
    return location
end

function pipeline_reversed(maps_converted, location)
    humidity = inverse_map(maps_converted["humidity_to_location"], location)
    temperature = inverse_map(maps_converted["temperature_to_humidity"], humidity)
    light = inverse_map(maps_converted["light_to_temperature"], temperature)
    water = inverse_map(maps_converted["water_to_light"], light)
    fertilizer = inverse_map(maps_converted["fertilizer_to_water"], water)
    soil = inverse_map(maps_converted["soil_to_fertilizer"], fertilizer)
    seed = inverse_map(maps_converted["seed_to_soil"], soil)
    return seed
end

function parse_map(map)
    result::Vector{Vector{Int}} = Vector(undef, length(map))
    map = split.(map, " ")
    map = filter.(x -> x != "", map)
    for (idx, item) in enumerate(map)
        result[idx] = parse.(Int, item)
    end
    return result
end

main()