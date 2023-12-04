function main()
    input = readlines("inputs/4.txt")

    score = 0
    card_count = ones(Int, length(input))
    for card in input
        card_id = extractCardId(card)
        winning_numbers = extractWinningNumbers(card)
        player_numbers = extractPlayerNumbers(card)  
        numMatches = length(intersect(winning_numbers, player_numbers))

        if (numMatches != 0)
            score += 2^(numMatches-1)
        end

        card_count[(card_id+1):(card_id+(numMatches))] .+= card_count[card_id]
    end

    @show score
    @show sum(card_count)
end

function extractCardId(card::String)
    card_id = split(card, "|")[1]
    card_id = split(card_id, ":")[1]
    card_id = split(card_id, " ")
    card_id = filter!(x -> x != "", card_id)
    card_id = parse(Int, card_id[2])
    return card_id
end

function extractWinningNumbers(card::String)
    winning_numbers = split(card, "|")[1]
    winning_numbers = split(winning_numbers, ":")[2]
    winning_numbers = split(winning_numbers, " ")
    winning_numbers = filter!(x -> x != "", winning_numbers)
    winning_numbers = parse.(Int, winning_numbers)
    return winning_numbers
end

function extractPlayerNumbers(card::String)
    player_numbers = split(card, "|")[2]
    player_numbers = split(player_numbers, " ")
    player_numbers = filter!(x -> x != "", player_numbers)
    player_numbers = parse.(Int, player_numbers)
    return player_numbers
end

main()
