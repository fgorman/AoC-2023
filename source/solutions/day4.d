module day4;

import std.container : Array;
import std.algorithm : canFind;
import std.conv : to;
import std.regex : regex, matchAll;
import std.string : splitLines, split, strip;
import std.stdio: writeln;

immutable string testInput = "Card 1: 41 48 83 86 17 | 83 86  6 31 17  9 48 53\n" ~
"Card 2: 13 32 20 16 61 | 61 30 68 82 17 32 24 19\n" ~
"Card 3:  1 21 53 59 44 | 69 82 63 72 16 21 14  1\n" ~
"Card 4: 41 92 73 84 69 | 59 84 76 51 58  5 54 83\n" ~
"Card 5: 87 83 26 28 32 | 88 30 70 12 93 22 82 36\n" ~
"Card 6: 31 18 13 56 72 | 74 77 10 23 35 67 36 11\n";

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
    auto lines = splitLines(input);

    auto re = regex(r"\d+");

    int points = 0;
    foreach (line ; lines)
    {
        auto allNums = line.strip().split(": ")[1];
        auto winAndAttemptNums = allNums.strip().split(" | ");
        ulong[] winningNums;
        foreach (numStr ; matchAll(winAndAttemptNums[0], re))
        {
            winningNums ~= numStr.hit.to!ulong;
        }

        ulong cardScore = 0;
        foreach (numStr ; matchAll(winAndAttemptNums[1], re))
        {
            ulong num = numStr.hit.to!ulong;

            if (winningNums.canFind(num))
                cardScore = cardScore == 0 ? 1 : cardScore * 2;
        }

        points += cardScore;
    }
    return points;
}

struct Card { ulong numWins = 0; }

int part2(string input)
{
    auto lines = splitLines(input);

    auto re = regex(r"\d+");

    Card[] cards;
    foreach (line ; lines)
    {
        Card currCard;
        auto allNums = line.strip().split(": ")[1];
        auto winAndAttemptNums = allNums.strip().split(" | ");
        ulong[] winningNums;
        foreach (numStr ; matchAll(winAndAttemptNums[0], re))
        {
            winningNums ~= numStr.hit.to!ulong;
        }

        foreach (numStr ; matchAll(winAndAttemptNums[1], re))
        {
            ulong num = numStr.hit.to!ulong;

            if (winningNums.canFind(num))
                currCard.numWins += 1;
        }
        cards ~= currCard;
    }

    Array!ulong dp;
    for (int _ = 0; _ < cards.length; _++)
        dp.insert(1);

    for (int i = cast(int)cards.length-1; i >= 0; i--)
    {
        ulong currCardNumWins = cards[i].numWins;

        ulong lowerIdx, upperIdx;
        if (currCardNumWins == 0)
            continue;
        else
        {
            lowerIdx = i + 1 > cards.length-1 ? cards.length-1 : i + 1;
            upperIdx = i + currCardNumWins > cards.length-1 ? cards.length-1 : i + currCardNumWins;
        }

        for (ulong j = lowerIdx; j <= upperIdx; j++)
        {
            dp[i] += dp[j];
        }
    }

    ulong totalNumCards = 0;
    foreach (num ; dp)
        totalNumCards += num;
    
    return cast(int) totalNumCards; 
}