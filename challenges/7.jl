using StatsBase

struct Hand
    cards::Array{Char, 1}
    Hand(x::Vector{Char}) = new(x)
    Hand(x::SubString{String}) = Hand([x[i] for i in eachindex(x)])
end


card_value = Dict(
    '2' => 2,
    '3' => 3,
    '4' => 4,
    '5' => 5,
    '6' => 6,
    '7' => 7,
    '8' => 8,
    '9' => 9,
    'T' => 10,
    'J' => 1, # 11 for part 1
    'Q' => 12,
    'K' => 13,
    'A' => 14
)

type_of_hand = Dict(
    "High Card" => 1,
    "One Pair" => 2,
    "Two Pairs" => 3,
    "Three of a Kind" => 4,
    "Full House" => 5,
    "Four of a Kind" => 6,
    "Five of a Kind" => 7
)

function main()
    input = readlines("inputs/7.txt")
    hands = [(Hand(split(input[i], " ")[1]), parse(Int, split(input[i], " ")[2])) for i in eachindex(input)]
    
    sort!(hands, by = x -> x[1])

    ranksMultiplied = [hands[i][2]*i for i in eachindex(hands)]
    solution = sum(ranksMultiplied)
    @show solution
end

function Base.isless(a::Hand, b::Hand)
    aType = type_of_hand[getHandType(a)]
    bType = type_of_hand[getHandType(b)]

    if aType != bType return aType < bType end

    if (card_value[a.cards[1]] != card_value[b.cards[1]]) return card_value[a.cards[1]] < card_value[b.cards[1]] end
    if (card_value[a.cards[2]] != card_value[b.cards[2]]) return card_value[a.cards[2]] < card_value[b.cards[2]] end
    if (card_value[a.cards[3]] != card_value[b.cards[3]]) return card_value[a.cards[3]] < card_value[b.cards[3]] end
    if (card_value[a.cards[4]] != card_value[b.cards[4]]) return card_value[a.cards[4]] < card_value[b.cards[4]] end
    if (card_value[a.cards[5]] != card_value[b.cards[5]]) return card_value[a.cards[5]] < card_value[b.cards[5]] end
end

function getHandType(hand::Hand)
    cards = hand.cards
    countMap = countmap(cards)
    
    if (length(values(countMap)) == 1) return "Five of a Kind" end

    # Part 2
    if ('J' in keys(countMap))
        numJs = countMap['J']
        delete!(countMap, 'J')
        keyMax = collect(keys(countMap))[argmax(collect(values(countMap)))]
        countMap[keyMax] += numJs
    end

    countMapValues = countMap |> values |> collect |> sort
    keyMax = collect(keys(countMap))[argmax(collect(values(countMap)))]
    countMapMax = countMap[keyMax]

    if (countMapMax == 5) return "Five of a Kind" end
    if (countMapMax == 4) return "Four of a Kind" end
    if (countMapValues == [2,3]) return "Full House" end
    if (countMapMax == 3) return "Three of a Kind" end
    if (countMapValues == [1,2,2]) return "Two Pairs" end
    if (countMapMax == 2) return "One Pair" end
    return "High Card"
end

main()