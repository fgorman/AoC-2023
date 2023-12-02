module day2;

import std.array : split;
import std.algorithm : cmp;
import std.conv : to;
import std.range : enumerate;
import std.string : splitLines;
import std.stdio : writeln;

immutable string testInput = "Game 1: 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green\n" ~
"Game 2: 1 blue, 2 green; 3 green, 4 blue, 1 red; 1 green, 1 blue\n" ~
"Game 3: 8 green, 6 blue, 20 red; 5 blue, 4 red, 13 green; 5 green, 1 red\n" ~
"Game 4: 1 green, 3 red, 6 blue; 3 green, 6 red; 3 green, 15 blue, 14 red\n" ~
"Game 5: 6 red, 1 blue, 3 green; 2 blue, 1 red, 2 green\n";

int part1(string input);
int part2(string input);

void solution(string input)
{
    int p1Solution = part1(input);
    writeln("Solution for part 1: ", p1Solution);

    int p2Solution = part2(input);
    writeln("Solution for part 2: ", p2Solution);
}

const int MAX_RED = 12;
const int MAX_GREEN = 13;
const int MAX_BLUE = 14;

int part1(string input)
{
    auto games = splitLines(input);

    int sum = 0;
    foreach (i, game ; games.enumerate(1))
    {
        auto sets = game.split(": ")[1];

        bool passes = true;
        
        gameLoop:
        foreach (set ; sets.split("; "))
        {
            foreach (cubes ; set.split(", "))
            {
                string[] split = cubes.split(" ");
                string color = split[1].to!string;
                int numCubes = split[0].to!int;

                if (color == "red" && numCubes > MAX_RED)
                {
                    passes = false;
                    break gameLoop;
                } 
                if (color == "green" && numCubes > MAX_GREEN)
                {
                    passes = false;
                    break gameLoop;
                } 
                if (color == "blue" && numCubes > MAX_BLUE)
                {
                    passes = false;
                    break gameLoop;
                } 
            }
        }
        
        if (passes)
            sum += i;
    }

    return sum;
}

int part2(string input)
{
    auto games = splitLines(input);

    int sum = 0;
    foreach (i, game ; games.enumerate(1))
    {
        auto sets = game.split(": ")[1];

        int maxRed = 0;
        int maxGreen = 0;
        int maxBlue = 0;
        
        foreach (set ; sets.split("; "))
        {
            foreach (cubes ; set.split(", "))
            {
                string[] split = cubes.split(" ");
                string color = split[1].to!string;
                int numCubes = split[0].to!int;

                if (color == "red" && numCubes > maxRed)
                {
                    maxRed = numCubes;
                } 
                if (color == "green" && numCubes > maxGreen)
                {
                    maxGreen = numCubes;
                } 
                if (color == "blue" && numCubes > maxBlue)
                {
                    maxBlue = numCubes;
                } 
            }
        }
        
        sum += maxRed * maxGreen * maxBlue;
    }

    return sum;
}