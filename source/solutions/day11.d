module day11;

import std.algorithm.comparison : min, max;
import std.algorithm.searching : count;
import std.stdio : writeln;
import std.string : splitLines;

immutable string testInput = "...#......\n" ~
                             ".......#..\n" ~
                             "#.........\n" ~
                             "..........\n" ~
                             "......#...\n" ~
                             ".#........\n" ~
                             ".........#\n" ~
                             "..........\n" ~
                             ".......#..\n" ~
                             "#...#.....\n"; 

int part1(string input);
ulong part2(string input);

void solution(string input)
{
    int p1Solution = part1(input);
    writeln("Solution for part 1: ", p1Solution);

    ulong p2Solution = part2(input);
    writeln("Solution for part 2: ", p2Solution);
}

int[] getExpandedRows(char[][] universe)
{
    int[] rows; 
    foreach (int i, row ; universe)
    {
        if (row.count('.') == row.length)
            rows ~= i;
    }
    return rows;
}

int[] getExpandedCols(char[][] universe)
{
    int[] cols;
    for (int i = 0; i < universe[0].length; i++)
    {
        int count = 0;
        foreach (j ; 0..universe.length)
        {
            if (universe[j][i] == '.')
                count++;
        }

        if (count != universe.length)
            continue;

        cols ~= i;
    }
    return cols;
}

int[][] getGalaxies(char[][] input)
{
    int[][] galaxies;
    foreach (i, row ; input)
    {
        foreach(j, c ; row)
        {
            if (c == '#')
                galaxies ~= cast(int[])([i, j]);
        }
    }
    return galaxies;
}

ulong getPathsSum(char[][] universe, int expansionCoefficient)
{
    int[] rowsExpanded = getExpandedRows(universe);
    int[] colsExpanded = getExpandedCols(universe);

    int[][] galaxies = getGalaxies(universe);

    ulong lengthsSum = 0;

    foreach (i, g1 ; galaxies)
    {
        foreach (j, g2 ; galaxies[i+1..galaxies.length])
        {
            int minX = min(g2[0], g1[0]), maxX = max(g2[0], g1[0]);
            int minY = min(g2[1], g1[1]), maxY = max(g2[1], g1[1]);

            lengthsSum += maxX - minX;
            lengthsSum += maxY - minY;

            foreach (rowIdx ; rowsExpanded)
                if (rowIdx >= minX && rowIdx <= maxX)
                    lengthsSum += expansionCoefficient - 1;

            foreach (colIdx ; colsExpanded)
                if (colIdx >= minY && colIdx <= maxY)
                    lengthsSum += expansionCoefficient - 1;
        }
    }

    return lengthsSum;
}

int part1(string input)
{
    int expansion = 2;

    char[][] universe = cast(char[][])(splitLines(input));

    return cast(int)getPathsSum(universe, expansion);
}

ulong part2(string input)
{
    int expansion = 1_000_000;

    char[][] universe = cast(char[][])(splitLines(input));

    return getPathsSum(universe, expansion);
}