function getLeftNumber(code::String)
    regularExpression = r"(\d|one|two|three|four|five|six|seven|eight|nine)"
    match1 = match(regularExpression, code).match
    if match1 == "one"
        return "1"
    elseif match1 == "two"
        return "2"
    elseif match1 == "three"
        return "3"
    elseif match1 == "four"
        return "4"
    elseif match1 == "five"
        return "5"
    elseif match1 == "six"
        return "6"
    elseif match1 == "seven"
        return "7"
    elseif match1 == "eight"
        return "8"
    elseif match1 == "nine"
        return "9"
    else
        return match1
    end
end

function getRightNumber(code::String)
    regularExpression = r"(\d)|eno|owt|eerht|ruof|evif|xis|neves|thgie|enin"
    codeReversed = reverse(code)
    match1 = match(regularExpression, codeReversed).match

    if match1 == "eno"
        return "1"
    elseif match1 == "owt"
        return "2"
    elseif match1 == "eerht"
        return "3"
    elseif match1 == "ruof"
        return "4"
    elseif match1 == "evif"
        return "5"
    elseif match1 == "xis"
        return "6"
    elseif match1 == "neves"
        return "7"
    elseif match1 == "thgie"
        return "8"
    elseif match1 == "enin"
        return "9"
    else
        return match1
    end
end

function getRowNumber(code::String)
    return parse(Int, getLeftNumber(code)) * 10 + parse(Int, getRightNumber(code))
end

function main()
    input = readlines("input.txt")
    total = 0
    for line in input
        total += getRowNumber(line)
    end
    @show total
end

main()
