module runner;

import std.format;
import std.process;
import std.stdio;

import requests;

import solutions;

immutable string AOC_URL_FMT_STR = "https://adventofcode.com/2023/day/%d/input";
immutable string SESSION_COOKIE = "SESSION_COOKIE";

void runSolution(byte day);
string getInput(byte day);

void runSolution(byte day)
{
    string input = getInput(day);

    writeln(input);

    switch (day)
    {
        case 1:
            day1_solution(input);
            break;
        default:
            break;
    }
}

string getInput(byte day)
{
    string getInputUrl = format(AOC_URL_FMT_STR, day);

    string sessionCookie = environment.get(SESSION_COOKIE);

    auto rq = Request();
    rq.addHeaders(["Cookie": "session="~sessionCookie]);

    Response rp = rq.get(getInputUrl);

    if (rp.code != 200)
    {
        throw new Exception(format("Status code %d received from AoC: %s", rp.code, rp.responseBody));
    }

    return rp.responseBody.toString();
}