module day3;

import std.array : overlap;
import std.ascii : isDigit;
import std.algorithm : canFind, remove;
import std.conv : to;
import std.range : enumerate;
import std.regex : regex, matchAll;
import std.stdio : writeln;
import std.string : splitLines;

immutable string testInput = "467..114..\n...*......\n..35..633.\n......#...\n" ~
"617*......\n.....+.58.\n..592.....\n......755.\n...$.*....\n.664.598..";

int part1(string input);
int part2(string input);

void solution(string input)
{
    int p1Solution = part1(input);
    writeln("Solution for part 1: ", p1Solution);

    int p2Solution = part2(input);
    writeln("Solution for part 2: ", p2Solution);
}

immutable char[] notSymbol = ['.', '0', '1', '2', '3', '4', '5', '6', '7', '8', '9'];

int part1(string input)
{
    auto lines = splitLines(input);

    ulong numLines = lines.length;

    int sum = 0;
    foreach (i, line ; lines.enumerate(0))
    {
        ulong lineLength = line.length;
        auto re = regex(r"\d+");
        foreach (num ; matchAll(line, re))
        {
            int idx1 = cast(int) num.pre.length;
            int idx2 = cast(int) (idx1 + num.hit.length);

            outer:
            foreach (row ; [i-1, i, i+1])
            {
                foreach (col ; (idx1-1)..(idx2+1))
                {
                    if (row < 0 || col < 0)
                        continue;
                    if (row > (numLines-1) || col > (lineLength-1))
                        continue;

                    if (!notSymbol.canFind(lines[row][col]))
                    {
                        sum += num.hit.to!int;
                        break outer;
                    }
                }
            }
        }
    }
    return sum;
}

class Pair
{
    public ulong x;
    public ulong y;

    this(ulong x, ulong y)
    {
        this.x = x;
        this.y = y;
    }

    override bool opEquals(const Object rhs)
    {
        Pair p = cast(Pair) rhs;
        return this.x == p.x && this.y == p.y;
    }

    override size_t toHash() { return x + y; }
}

int part2(string input)
{
    auto lines = splitLines(input);

    ulong numLines = lines.length;

    int sum = 0;
    int[][Pair] numsForGears;
    foreach (i, line ; lines.enumerate(0))
    {
        ulong lineLength = line.length;
        auto re = regex(r"\d+");
        foreach (num ; matchAll(line, re))
        {
            int idx1 = cast(int) num.pre.length;
            int idx2 = cast(int) (idx1 + num.hit.length);

            foreach (row ; [i-1, i, i+1])
            {
                foreach (col ; (idx1-1)..(idx2+1))
                {
                    if (row < 0 || col < 0)
                        continue;
                    if (row > (numLines-1) || col > (lineLength-1))
                        continue;

                    Pair p = new Pair(row, col);

                    if (lines[row][col] == '*')
                        numsForGears[p] ~= num.hit.to!int;
                }
            }
        }
    }
    
    foreach(pair, nums ; numsForGears)
    {
        if (nums.length != 2)
            continue;
        
        sum += nums[0] * nums[1];
    }

    return sum;
}