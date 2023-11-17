module options;

import std.stdio;
import darg;

struct Options
{
    @Option("help", "h")
    OptionFlag help;

    @Option("day", "d")
    @Help("Day of AoC 2023 to run")
    byte day;
}

immutable usage = usageString!Options("aoc-2023");
immutable help = helpString!Options;

Options getArgs(string[] args)
{
    try
    {
        return parseArgs!Options(args[1 .. $]);
    }
    catch (ArgParseError e)
    {
        writeln(e.msg);
        writeln(usage);
        return Options();
    }
    catch (ArgParseHelp e)
    {
        writeln(usage);
        write(help);
        return Options();
    }
}