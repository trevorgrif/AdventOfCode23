function main()
    input = readlines("inputs/6.txt")
    times = input[1] |> split
    times = times[2:end]
    times = parse.(Int, times)

    distances = input[2] |> split
    distances = distances[2:end]
    distances = parse.(Int, distances)

    # Input for Part 2
    times_2 = input[1] |> split
    times_2 = times_2[2:end]
    times_2 = join(times_2)
    times_2 = parse.(Int, times_2)

    distances_2 = input[2] |> split
    distances_2 = distances_2[2:end]
    distances_2 = join(distances_2)
    distances_2 = parse.(Int, distances_2)

    # Compute solution 1
    solution_1 = 1
    for race in range(start=1, step=1, length=length(times))
        solution_1 *= compute_num_wins(times[race], distances[race])
    end

    # Compute solution 2
    solution_2 = compute_num_wins(times_2[1], distances_2[1])


    @show solution_1
    @show solution_2
end

function compute_num_wins(time, distance)
    solutions = roots(-1, time, -distance)
    return floor(solutions[2]) - ceil(solutions[1]) + 1
end

function roots(a, b, c)
    discriminant = b^2 - 4*a*c
    if discriminant < 0
        return []
    elseif discriminant == 0
        return [-b/(2*a)]
    else
        return [(-b + sqrt(discriminant))/(2*a), (-b - sqrt(discriminant))/(2*a)]
    end
end

main()