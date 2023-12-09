module day9;

import std.algorithm.searching : count;
import std.conv : to;
import std.stdio : writeln;
import std.string : splitLines, split;

immutable string testInput = "0 3 6 9 12 15\n" ~
    "1 3 6 10 15 21\n" ~
    "10 13 16 21 30 45\n";

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
    int sum = 0;

    foreach (line ; splitLines(input))
    {
        int[] nums = to!(int[])(line.split(" "));

        int[][] diffs;
        diffs ~= nums.dup;
        int[] currNums = nums.dup;
        while (currNums.count(0) != currNums.length)
        {
            int[] currDiffs;
            for (int i = 1; i < currNums.length; i++)
                currDiffs ~= currNums[i] - currNums[i-1];

            diffs ~= currDiffs.dup;
            currNums = currDiffs.dup;
        }

        for (int i = cast(int)(diffs.length-1u); i >= 0; i--)
        {
            int idx = cast(int)(diffs[i].length - 1u);
            sum += diffs[i][idx];
        }   
    }

    return sum;
}

int part2(string input)
{
    int sum = 0;

    foreach (line ; splitLines(input))
    {
        int[] nums = to!(int[])(line.split(" "));

        int[][] diffs;
        diffs ~= nums.dup;
        int[] currNums = nums.dup;
        while (currNums.count(0) != currNums.length)
        {
            int[] currDiffs;
            for (int i = 1; i < currNums.length; i++)
                currDiffs ~= currNums[i] - currNums[i-1];

            diffs ~= currDiffs.dup;
            currNums = currDiffs.dup;
        }

        int firstDigit = 0;
        for (int i = cast(int)(diffs.length-1u); i >= 0; i--)
            firstDigit = diffs[i][0] - firstDigit;

        sum += firstDigit;
    }
        
    return sum;
}