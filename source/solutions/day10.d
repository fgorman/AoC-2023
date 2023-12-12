module day10;

import std.algorithm.searching : canFind;
import std.stdio : writeln;
import std.string : splitLines;

immutable string testInput1 = "-L|F7\n" ~
    "7S-7|\n" ~
    "L|7||\n" ~
    "-L-J|\n" ~
    "L|-JF\n";

immutable string testInput2 = "7-F7-\n" ~
    ".FJ|7\n" ~
    "SJLL7\n" ~
    "|F--J\n" ~
    "LJ.LJ\n";

immutable string testInput3 = "...........\n" ~
    ".S------7.\n" ~
    ".|F----7|.\n" ~
    ".||....||.\n" ~
    ".||....||.\n" ~
    ".|L-7F-J|.\n" ~
    ".|..||..|.\n" ~
    ".L--JL--J.\n" ~
    "..........\n";

immutable string testInput4 = ".F----7F7F7F7F-7....\n" ~
    ".|F--7||||||||FJ....\n" ~
    ".||.FJ||||||||L7....\n" ~
    "FJL7L7LJLJ||LJ.L-7..\n" ~
    "L--J.L7...LJS7F-7L7.\n" ~
    "....F-J..F7FJ|L7L7L7\n" ~
    "....L7.F7||L7|.L7L7|\n" ~
    ".....|FJLJ|FJ|F7|.LJ\n" ~
    "....FJL-7.||.||||...\n" ~
    "....L---J.LJ.LJLJ...\n"; 

int part1(string input);

void solution(string input)
{
    int p1Solution = part1(input);
    writeln("Solution for part 1: ", p1Solution);

    int p2Solution = part2(input);
    writeln("Solution for part 2: ", p2Solution);
}

int[] getSource(char[][] sketch)
{
    foreach (i, row ; sketch)
    {
        foreach (j, c ; sketch[i])
        {
            if (c == 'S')
                return cast(int[])([i, j]);
        }
    }
    assert(0);
}

char getSrcType(char[][] sketch, int[] src, int[][][char] reach)
{
    int[][] srcDirs;
    foreach (i, diff ; [[-1, 0], [1, 0], [0, -1], [0, 1]])
    {
        int cmpX = src[0] + diff[0];
        int cmpY = src[1] + diff[1];
        if (cmpX < 0 || cmpY < 0 || cmpX >= sketch.length || cmpY >= sketch[0].length)
            continue;
        
        foreach (dr ; reach[sketch[cmpX][cmpY]])
        {
            if (dr.canFind([-1*diff[0], -1*diff[1]]))
            {
                srcDirs ~= diff;
            }
        }
    }

    foreach (c, dr ; reach)
        if (srcDirs == dr)
            return c;

    assert(0);
}

int[][] getPipes(char[][] sketch, int[] src, int[][][char] reach)
{
    int[][] pipes;

    int[] currPipe = src;
    int[] currDiff = reach[sketch[currPipe[0]][currPipe[1]]][0];
    pipes ~= currPipe;
    currPipe = [currDiff[0]+src[0], currDiff[1]+src[1]];
    int[] prevDiff = [-1*currDiff[0], -1*currDiff[1]];

    while (currPipe != src)
    {
        pipes ~= currPipe;

        int[][] diffs = reach[sketch[currPipe[0]][currPipe[1]]];

        currDiff = diffs[0] == prevDiff ? diffs[1] : diffs[0];

        currPipe = [currPipe[0]+currDiff[0], currPipe[1]+currDiff[1]];

        prevDiff = [-1*currDiff[0], -1*currDiff[1]];
    }
    return pipes;
}

int part1(string input)
{
    int[][][char] reach = [
        '.': [],
        '|': [[1, 0], [-1, 0]],
        '-': [[0, 1], [0, -1]],
        'L': [[-1, 0], [0, 1]],
        'J': [[-1, 0], [0, -1]],
        '7': [[1, 0], [0, -1]],
        'F': [[1, 0], [0, 1]],
    ];

    string[] lines = input.splitLines;

    char[][] sketch;
    foreach (line ; lines) sketch ~= line.dup;

    int[] src = getSource(sketch);
    char srcType = getSrcType(sketch, src, reach);
    sketch[src[0]][src[1]] = srcType;

    int[][] pipes = getPipes(sketch, src, reach);

    return cast(int)(pipes.length / 2);
}

int countInside(char[][] sketch, int[][] pipes)
{
    int count = 0;

    foreach (i, row; sketch)
    {
        int p = 0;
        foreach (j, c ; row)
        {
            if (!pipes.canFind([i, j]))
            {
                if (p % 2 == 1)
                    count++;
                continue;
            }

            if (['|', 'L', 'J'].canFind(c))
                p++;
        }
    }

    return count;
}

int part2(string input)
{
    int[][][char] reach = [
        '.': [],
        '|': [[1, 0], [-1, 0]],
        '-': [[0, 1], [0, -1]],
        'L': [[-1, 0], [0, 1]],
        'J': [[-1, 0], [0, -1]],
        '7': [[1, 0], [0, -1]],
        'F': [[1, 0], [0, 1]],
    ];

    string[] lines = input.splitLines;

    char[][] sketch;
    foreach (line ; lines) sketch ~= line.dup;

    int[] src = getSource(sketch);
    char srcType = getSrcType(sketch, src, reach);
    sketch[src[0]][src[1]] = srcType;

    int[][] pipes = getPipes(sketch, src, reach);

    return countInside(sketch, pipes);
}