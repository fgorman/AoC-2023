module day10;

import std.algorithm.searching : canFind;
import std.array : empty, popFront, front;
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

int part1(string input);

void solution(string input)
{
    int p1Solution = part1(input);
    writeln("Solution for part 1: ", p1Solution);

    int p2Solution = part2(testInput3);
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

bool[][] createAdjMatrix(char[][] sketch, int[][][char] reachability)
{
    ulong numVertices = sketch.length * sketch[0].length;
    bool[][] adj;
    foreach (i ; 0..numVertices) adj ~= new bool[numVertices];

    foreach (i, row ; sketch)
    {
        foreach(j, c ; row)
        {
            int[][] reach = reachability[c];
            foreach (r ; reach)
            {
                int[] reachableTo = cast(int[])([r[0]+i, r[1]+j]);
                if (reachableTo[0] < 0 || reachableTo[1] < 0)
                    continue;

                if (reachableTo[0] >= sketch.length || reachableTo[1] >= row.length)
                    continue;

                char rtChar = sketch[reachableTo[0]][reachableTo[1]];

                if (reachability[rtChar].canFind([r[0]*-1, r[1]*-1]))
                    adj[i*row.length+j][reachableTo[0]*row.length+reachableTo[1]] = true;
            }
        }
    }
    return adj;
}

int[] getDistances(bool[][] adj, int src)
{
    int[] distances = new int[adj.length];
    distances[] = -1;

    int[] q;
    q ~= src;

    distances[src] = 0;

    int vis;
    while (!q.empty)
    {
        vis = q.front;
        q.popFront;

        foreach (i, v ; adj[vis])
        {
            if (v && distances[i] == -1)
            {
                q ~= cast(int) i;
                distances[i] = cast(int)(1 + distances[vis]);
            }
        }
    }

    return distances;
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
        'S': [[-1, 0], [1, 0], [0, -1], [0, 1]]
    ];

    char[][] sketch = cast(char[][])(input.splitLines());

    int[] src = getSource(sketch);

    auto adj = createAdjMatrix(sketch, reach);

    int srcIdx = cast(int)(src[0] * sketch[0].length + src[1]);

    int[] distances = getDistances(adj, srcIdx);

    int maxDist = 0;
    foreach (dist ; distances)
        if (dist > maxDist)
            maxDist = dist;

    return maxDist;
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
        'S': [[-1, 0], [1, 0], [0, -1], [0, 1]]
    ];

    char[][] sketch = cast(char[][])(input.splitLines());

    int[] src = getSource(sketch);

    auto adj = createAdjMatrix(sketch, reach);

    int srcIdx = cast(int)(src[0] * sketch[0].length + src[1]);

    int[] distances = getDistances(adj, srcIdx);

    int numInsideLoop = 0;

    foreach (i, row ; sketch)
    {
        foreach (j, c ; row)
        {
            if (c != '.')
                continue;
            
            writeln("i, j = ", [i, j]);
            bool[] inside;
            for (int k = cast(int)(j+1); k < row.length; k++)
            {   
                writeln("right ", [i,k]);
                int currIdx = cast(int)(i*sketch.length + k);
                if (distances[currIdx] != -1)
                {
                    inside ~= true;
                    break;
                }
            }

            for (int k = cast(int)(j-1); k >= 0; k--)
            {
                writeln("left ", [i,k]);
                int currIdx = cast(int)(i*sketch.length + k);
                if (distances[currIdx] != -1)
                {
                    inside ~= true;
                    break;
                }
            }

            for (int k = cast(int)(i+1); k < sketch.length; k++)
            {
                writeln("down ", [k, j]);
                int currIdx = cast(int)(k*sketch.length+j);
                if (distances[currIdx] != -1)
                {
                    inside ~= true;
                    break;
                }
            }

            for (int k = cast(int)(i-1); k >=0; k--)
            {
                writeln("up ", [k, j]);
                int currIdx = cast(int)(k*sketch.length+j);
                if (distances[currIdx] != -1)
                {
                    inside ~= true;
                    break;
                }
            }

            if (inside == [true, true, true, true])
            {
                numInsideLoop++;
                writeln([i, j]);
            }
                
        }
    }

    return numInsideLoop;
}