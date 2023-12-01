module day1;

import std.ascii : isDigit;
import std.conv : to ;
import std.range : enumerate;
import std.stdio : writeln;
import std.string : splitLines, startsWith;

immutable string testInput1 = "1abc2\npqr3stu8vwx\na1b2c3d4e5f\ntreb7uchet\n";
immutable string testInput2 = "two1nine\neightwothree\nabcone2threexyz\nxtwone3four\n4nineeightseven2\nzoneight234\n7pqrstsixteen\n";

int part1(string input);
int part2(string input);

void solution(string input)
{
    int p1Solution = part1(input);
    writeln("Solution for part 1: ", p1Solution);

    int p2Solution = part2(input);
    writeln("Solution for part 2: ", p2Solution);
}

/*
Everything for part 1
*/



int part1(string input)
{
    auto lines = splitLines(input);
    
    int sum = 0;
    foreach (string line ; lines)
    {
        string[] nums;
        foreach (char c ; line)
        {
            if (isDigit(c))
            {
                nums ~= c.to!string;
            }
        }

        string num = nums[0] ~ nums[nums.length-1];

        sum += to!int(num);
    }

    return sum;
}

/*
Everything for part 2
*/

immutable string[] writtenNums = ["one", "two", "three", "four", "five", "six", "seven", "eight", "nine"];

int part2(string input)
{
    auto lines = splitLines(input);

    int sum = 0;
    foreach (string line ; lines)
    {
        string[] nums;
        foreach (int i, dchar c ; line.enumerate(0))
        {
            if (isDigit(c))
            {
                nums ~= c.to!string;
            }

            foreach (ulong digit, string s ; writtenNums.enumerate(1))
            {
                if (startsWith(line[i..line.length], s))
                {
                    nums ~= (digit).to!string;
                }
            }
        }

        string num = nums[0] ~ nums[nums.length-1];

        sum += to!int(num);
    }

    return sum;


}