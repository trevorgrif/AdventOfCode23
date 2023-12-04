function main()
    # Scenario variables
    maxes = Dict(
        "red" => 12,
        "green" => 13,
        "blue" => 14
    )

    # Iterate over the games and track the sum of game ids
    gameset = readlines("inputs/2.txt")
    sum_valid = 0
    sum_power = 0
    for game in gameset
        valid, power = gameIsValid(game, maxes)
        sum_valid += valid
        sum_power += power
    end

    @show sum_valid, sum_power
end

function gameIsValid(game::String, maxes::Dict)
    # Default set minimums
    minimums = Dict(
        "red" => 0,
        "green" => 0,
        "blue" => 0
    )

    # Extract the game ids
    game_id, results = split(game, ":")

    # Extract the count of cubes for each color
    results = split(results, ";")
    isValid = true
    for result in results
        colors = split(result, ",")
        colors = split.(colors, " ")

        for color in colors
            color_value = parse(Int, color[2])
            color_key = color[3]
            
            # Check game validity (Part 1)
            if color_value > maxes[color_key]
                isValid = false 
            end

            # Check minimum value possible (Part 2)
            if color_value > minimums[color_key]
                minimums[color_key] = color_value
            end
        end
    end

    power_set = minimums["red"] * minimums["green"] * minimums["blue"]

    # Otherwise return the game id
    isValid ? (parseGameId(game_id), power_set) : (0, power_set)
end

parseGameId(game::SubString{String}) = parse(Int, game[6:end])

main()