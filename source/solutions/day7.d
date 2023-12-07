module day7;

import std.algorithm : sort;
import std.array;
import std.conv : to;
import std.range : enumerate;
import std.regex : regex, matchFirst, Regex;
import std.stdio : writeln;
import std.string : splitLines, split, representation, replace;

immutable string testInput = "32T3K 765\n" ~
"T55J5 684\n" ~
"KK677 28\n" ~
"KTJJT 220\n" ~
"QQQJA 483\n";

int part1(string input);
int part2(string input);

void solution(string input)
{
    int p1Solution = part1(input);
    writeln("Solution for part 1: ", p1Solution);

    int p2Solution = part2(input);
    writeln("Solution for part 2: ", p2Solution);
}

enum HandType { FIVE_OF_KIND, FOUR_OF_KIND, FULL_HOUSE, THREE_OF_KIND, TWO_PAIR, ONE_PAIR, HIGH_CARD } 

auto handTypeRegex = [
    regex(r".*(\w)\1{4}.*"),
    regex(r".*(\w)\1{3}.*"),
    regex(r"((\w)\2\2(\w)\3|(\w)\4(\w)\5\5)"),
    regex(r".*(\w)\1\1.*"),
    regex(r".*(\w)\1.*(\w)\2.*"),
    regex(r".*(\w)\1.*")
];

class Hand
{
    string cards;
    int bet;
    HandType type;

    this (string cards, int bet, HandType type)
    {
        this.cards = cards;
        this.bet = bet;
        this.type = type;
    }
}

bool p1Cmp(Hand h1, Hand h2)
{
    auto cardsOrder = [
        '2': 0, '3': 1, '4': 2, '5': 3, '6': 4,
        '7': 5, '8': 6, '9': 7, 'T': 8, 'J': 9,
        'Q': 10, 'K': 11, 'A': 12
    ];

    if (h1.type != h2.type)
        return h1.type > h2.type;

    foreach (i, c ; h1.cards)
    {
        int c1Order = cardsOrder[c];
        int c2Order = cardsOrder[h2.cards[i]];

        if (c1Order == c2Order)
            continue;
        return c1Order < c2Order;
    }

    return true;
}

int part1(string input)
{
    string[] lines = splitLines(input);

    Hand[] hands;
    foreach (line ; lines)
    {
        string[] handAndBetStr = line.split(" ");
        string cards = handAndBetStr[0];
        int bet = handAndBetStr[1].to!int;

        string sortedCards = to!string(sort(cards.dup.array));

        HandType type = HandType.HIGH_CARD;
        foreach (i, re ; handTypeRegex)
        {
            auto m = matchFirst(sortedCards, re);
            if (m.empty)
                continue;
            type = cast(HandType) i;
            break;
        }

        hands ~= new Hand(cards, bet, type);
    }

    auto sortedHands = sort!(p1Cmp)(hands);

    uint totalWinnings = 0;
    foreach (i, hand ; sortedHands.enumerate(1))
        totalWinnings += i * hand.bet;
    
    return totalWinnings;
}

bool p2Cmp(Hand h1, Hand h2)
{
    auto cardsOrder = [
        'J': 0, '2': 1, '3': 2, '4': 3, '5': 4,
        '6': 5, '7': 6, '8': 7, '9': 8, 'T': 9,
        'Q': 10, 'K': 11, 'A': 12
    ];

    if (h1.type != h2.type)
        return h1.type > h2.type;

    foreach (i, c ; h1.cards)
    {
        int c1Order = cardsOrder[c];
        int c2Order = cardsOrder[h2.cards[i]];

        if (c1Order == c2Order)
            continue;
        return c1Order < c2Order;
    }

    return true;
}

int part2(string input)
{
    string[] lines = splitLines(input);

    Hand[] hands;
    foreach (line ; lines)
    {
        string[] handAndBetStr = line.split(" ");
        string cards = handAndBetStr[0];
        int bet = handAndBetStr[1].to!int;
        
        HandType type = HandType.HIGH_CARD;
        foreach (c ; "23456789TQKA")
        {
            string cardsCpy = cards.dup;
            cardsCpy = cardsCpy.replace('J', c);
            string sortedCards = to!string(sort(cardsCpy.array));

            HandType currType = HandType.HIGH_CARD;
            foreach (i, re ; handTypeRegex)
            {
                auto m = matchFirst(sortedCards, re);
                if (m.empty)
                    continue;
                currType = cast(HandType) i;
                break;
            }

            if (currType < type)
                type = currType;
        }

        hands ~= new Hand(cards, bet, type);
    }

    auto sortedHands = sort!(p2Cmp)(hands);

    uint totalWinnings = 0;
    foreach (i, hand ; sortedHands.enumerate(1))
        totalWinnings += i * hand.bet;
    
    return totalWinnings;
}