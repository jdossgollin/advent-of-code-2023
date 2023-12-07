struct Race
    duration::Int
    record_distance::Int
end
function Race(input::Vector{<:AbstractString})
    times = parse.(Int, split(split(input[1], ":")[2]))
    dists = parse.(Int, split(split(input[2], ":")[2]))
    return [Race(t, d) for (t, d) in zip(times, dists)]
end
function Race(fname::String)
    return Race(readlines(fname))
end

demo_input = ["Time:      7  15   30", "Distance:  9  40  200"]
@assert Race(demo_input) == [Race(7, 9), Race(15, 40), Race(30, 200)]

function distance_traveled(r::Race, t::Int)
    t > r.duration && throw("you cannot hold the button longer than the race duration")
    t < 0 && throw("you cannot hold the button for negative time")
    speed = t
    return speed * (r.duration - t)
end
demo_race = Race(7, 9)
@assert distance_traveled(demo_race, 0) == 0
@assert distance_traveled(demo_race, 1) == 6
@assert distance_traveled(demo_race, 2) == 10
@assert distance_traveled(demo_race, 3) == 12
@assert distance_traveled(demo_race, 4) == 12
@assert distance_traveled(demo_race, 5) == 10
@assert distance_traveled(demo_race, 6) == 6
@assert distance_traveled(demo_race, 7) == 0

function beat_record(r::Race, t::Int)
    return distance_traveled(r, t) > r.record_distance
end

function get_possible_holds(r::Race)
    return 0:(r.duration)
end

function count_ways_to_win(r::Race)
    return sum(beat_record(r, t) for t in get_possible_holds(r))
end
@assert count_ways_to_win(demo_race) == 4

function part1()
    input = Race("input/day-06.txt")
    n_ways = count_ways_to_win.(input)
    return prod(n_ways)
end

function parse_part2(lines::Vector{<:AbstractString})
    parse_line(line) = parse(Int, prod(split(split(line, ":")[2])))
    time = parse_line(lines[1])
    dist = parse_line(lines[2])
    return Race(time, dist)
end
function parse_part2(fname::String)
    return parse_part2(readlines(fname))
end
@assert parse_part2(demo_input) == Race(71530, 940200)
@assert count_ways_to_win(parse_part2(demo_input)) == 71503

function part2()
    input = parse_part2("input/day-06.txt")
    return count_ways_to_win(input)
end

part1()
part2()