module day6;

import std.conv : to;
import std.regex : regex, matchAll;
import std.stdio : writeln;
import std.string : splitLines;

immutable string testInput = "Time:      7  15   30\n" ~
    "Distance:  9  40  200\n";

int part1(string input);
int part2(string input);

void solution(string input)
{
    int p1Solution = part1(input);
    writeln("Solution for part 1: ", p1Solution);

    int p2Solution = part2(input);
    writeln("Solution for part 2: ", p2Solution);
}

int part1(string input)
{
    string[] lines = splitLines(input);

    int[] times, records;
    foreach (match ; matchAll(lines[0], regex(r"\d+")))
        times ~= match.hit.to!int;
    foreach (match ; matchAll(lines[1], regex(r"\d+")))
        records ~= match.hit.to!int;
    
    int total = 1;
    foreach (i, time ; times)
    {
        int timesBeaten = 0;
        
        foreach (heldFor ; 0..time)
        {
            int timeLeft = time - heldFor;
            if (timeLeft * heldFor > records[i])
                timesBeaten++;
        }

        total *= timesBeaten;
    }

    return total;
}

int part2(string input)
{
    string[] lines = splitLines(input);

    string timeStr, recordStr;
    foreach (match ; matchAll(lines[0], regex(r"\d+")))
        timeStr ~= match.hit;
    foreach (match ; matchAll(lines[1], regex(r"\d+")))
        recordStr ~= match.hit;

    long time = timeStr.to!long;
    long record = recordStr.to!long;
    
    int timesBeaten = 0;
    
    foreach (heldFor ; 0..time)
    {
        long timeLeft = time - heldFor;
        if (timeLeft * heldFor > record)
            timesBeaten++;
    }

    return timesBeaten;
}