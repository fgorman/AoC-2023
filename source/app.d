import std.stdio;
import options;
import runner;

int main(string[] args)
{
    Options opts = getArgs(args);
	
	if (opts.day < 1 || opts.day > 25) 
	{
		throw new Exception("Day must be between 1 and 30");
	}

	runSolution(opts.day);

	return 0;
}