module day8;

import std.numeric : gcd;
import std.stdio : writeln;
import std.string : split, splitLines, replace, strip;

immutable string testInput1 = "RL\n" ~
    "\n" ~
    "AAA = (BBB, CCC)\n" ~
    "BBB = (DDD, EEE)\n" ~
    "CCC = (ZZZ, GGG)\n" ~
    "DDD = (DDD, DDD)\n" ~
    "EEE = (EEE, EEE)\n" ~
    "GGG = (GGG, GGG)\n" ~
    "ZZZ = (ZZZ, ZZZ)\n";

immutable string testInput2 = "LLR\n" ~
    "\n" ~
    "AAA = (BBB, BBB)\n" ~
    "BBB = (AAA, ZZZ)\n" ~
    "ZZZ = (ZZZ, ZZZ)\n";

immutable string testInput3 = "LR\n" ~
    "\n" ~
    "11A = (11B, XXX)\n" ~
    "11B = (XXX, 11Z)\n" ~
    "11Z = (11B, XXX)\n" ~
    "22A = (22B, XXX)\n" ~
    "22B = (22C, 22C)\n" ~
    "22C = (22Z, 22Z)\n" ~
    "22Z = (22B, 22B)\n" ~
    "XXX = (XXX, XXX)\n";

int part1(string input);
ulong part2(string input);

void solution(string input)
{
    int p1Solution = part1(input);
    writeln("Solution for part 1: ", p1Solution);

    ulong p2Solution = part2(input);
    writeln("Solution for part 2: ", p2Solution);
}

int part1(string input)
{
    string[] sequenceAndNetwork = input.split("\n\n");

    string sequence = sequenceAndNetwork[0];
    string network = sequenceAndNetwork[1];

    string[][string] nodes;
    foreach (i, node ; network.strip().split("\n"))
    {
        string[] nameAndLR = node.split(" = ");
        string name = nameAndLR[0];
        string left = nameAndLR[1][1..4];
        string right = nameAndLR[1][6..9];
        
        nodes[name] = [left, right];
    }

    
    int currSeq = 0;
    int steps = 0;
    string currNode = "AAA";
    while (currNode != "ZZZ")
    {
        steps++;

        char direction = sequence[currSeq];

        if (direction == 'L')
            currNode = nodes[currNode][0];
        else
            currNode = nodes[currNode][1];

        currSeq++;
        if (currSeq == sequence.length)
            currSeq = 0;
    }

    return steps;
}

ulong part2(string input)
{
    ulong lcm(ulong[] nums)
    {
        ulong ans = nums[0];

        for (int i = 1; i < nums.length; i++)
            ans = (nums[i] * ans) / gcd(nums[i], ans);

        return ans;
    }

    string[] sequenceAndNetwork = input.split("\n\n");

    string sequence = sequenceAndNetwork[0];
    string network = sequenceAndNetwork[1];

    string[][string] nodes;
    foreach (i, node ; network.strip().split("\n"))
    {
        string[] nameAndLR = node.split(" = ");
        string name = nameAndLR[0];
        string left = nameAndLR[1][1..4];
        string right = nameAndLR[1][6..9];
        
        nodes[name] = [left, right];
    }

    string[] aNodes; 
    foreach (name, lr ; nodes)
    {
        if (name[2] == 'A')
            aNodes ~= name;
    }

    ulong[] stepsForNodes;
    foreach (aNode ; aNodes)
    {
        int currSeq = 0;
        ulong steps = 0;
        string currNode = aNode;
        while (currNode[2] != 'Z')
        {
            steps++;

            char direction = sequence[currSeq];

            if (direction == 'L')
                currNode = nodes[currNode][0];
            else
                currNode = nodes[currNode][1];

            currSeq++;
            if (currSeq == sequence.length)
                currSeq = 0;
        }

        stepsForNodes ~= steps;
    }

    return lcm(stepsForNodes);
}