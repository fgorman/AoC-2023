module day5;

import std.algorithm : max, min;
import std.conv : to;
import std.range : empty, front, popFront;
import std.string : split, strip, splitLines;
import std.stdio : writeln;

immutable string testInput = "seeds: 79 14 55 13\n\n" ~
    "seed-to-soil map:\n" ~
    "50 98 2\n" ~
    "52 50 48\n\n" ~
    "soil-to-fertilizer map:\n" ~
    "0 15 37\n" ~
    "37 52 2\n" ~
    "39 0 15\n\n" ~ 
    "fertilizer-to-water map:\n" ~
    "49 53 8\n" ~
    "0 11 42\n" ~
    "42 0 7\n" ~
    "57 7 4\n\n" ~
    "water-to-light map:\n" ~
    "88 18 7\n" ~
    "18 25 70\n\n" ~
    "light-to-temperature map:\n" ~
    "45 77 23\n" ~
    "81 45 19\n" ~
    "68 64 13\n\n" ~
    "temperature-to-humidity map:\n" ~
    "0 69 1\n" ~
    "1 0 69\n\n" ~
    "humidity-to-location map:\n" ~
    "60 56 37\n" ~
    "56 93 4\n";

long part1(string input);
long part2(string input);

void solution(string input)
{
    long p1Solution = part1(input);
    writeln("Solution for part 1: ", p1Solution);

    long p2Solution = part2(input);
    writeln("Solution for part 2: ", p2Solution);
}

long part1(string input)
{
    auto groups = input.split("\n\n");

    long[] seeds = to!(long[])(groups[0].split(": ")[1]
        .split(" "));

    foreach (group ; groups[1..groups.length])
    {
        auto lines = group.strip().split("\n");
        
        long[] seedsTo = seeds.dup;
        foreach (numStr ; lines[1..lines.length])
        {
            long[] nums = to!(long[])(numStr.split(" "));
            
            foreach (i, seed ; seeds)
            {
                if (seed >= nums[1] && seed < (nums[1]+nums[2]))
                    seedsTo[i] = nums[0] + (seed-nums[1]);
            }
        }
        seeds = seedsTo;
    }

    long ret = long.max;
    foreach (num ; seeds)
    {
        ret = min(ret, num);
    }

    return ret;
}

long part2(string input)
{
    auto groups = input.split("\n\n");

    long[] seedsWithRanges = to!(long[])(groups[0].split(": ")[1]
        .split(" "));

    long[][] seeds;
    for (ulong i = 0; i < seedsWithRanges.length; i += 2)
        seeds ~= [seedsWithRanges[i], seedsWithRanges[i]+seedsWithRanges[i+1]];

    foreach (group ; groups[1..groups.length])
    {
        auto lines = splitLines(group);
        long[][][] ranges;
        foreach (line ; lines[1..lines.length])
        {
            auto nums = to!(long[])(line.split(" "));
            ranges ~= [[nums[1], nums[1]+nums[2]], [nums[0], nums[0]+nums[2]]];
        }
        
        long[][] seedsTo;
        while (!seeds.empty)
        {
            auto seed = seeds.front;

            bool overlap = false;
            foreach (range ; ranges)
            {
                long[] srcRange = range[0].dup;
                long[] destRange = range[1].dup;
                long diff = destRange[0]-srcRange[0];

                if (seed[1] <= srcRange[0] || srcRange[1] <= seed[0])
                    continue;

                overlap = true;

                long[2] overlapRange = [max(seed[0], srcRange[0]), min(seed[1], srcRange[1])];
                long[2] leftoverLeft = [seed[0], overlapRange[0]];
                long[2] leftoverRight = [overlapRange[1], seed[1]];
                
                if ((leftoverLeft[1] - leftoverLeft[0]) > 0)
                    seeds ~= leftoverLeft.dup;
                if ((leftoverRight[1] - leftoverRight[0]) > 0)
                    seeds ~= leftoverRight.dup;

                seedsTo ~= [overlapRange[0] + diff, overlapRange[1] + diff];

                break;
            }
            if (!overlap) seedsTo ~= seed.dup;
            seeds.popFront;
        }
        seeds = seedsTo.dup;
    }

    long min = long.max;
    foreach (num ; seeds)
    {
        if (num[0] < min)
            min = num[0];
    }

    return min;
}