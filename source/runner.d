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
        case 2:
            day2_solution(input);
            break;
        case 3:
            day3_solution(input);
            break;
        case 4:
            day4_solution(input);
            break;
        case 5:
            day5_solution(input);
            break;
        case 6:
            day6_solution(input);
            break;
        case 7:
            day7_solution(input);
            break;
        case 8:
            day8_solution(input);
            break;
        case 9:
            day9_solution(input);
            break;
        case 10:
            day10_solution(input);
            break;
        case 11:
            day11_solution(input);
            break;
        case 12:
            day12_solution(input);
            break;
        case 13:
            day13_solution(input);
            break;
        case 14:
            day14_solution(input);
            break;
        case 15:
            day15_solution(input);
            break;
        case 16:
            day16_solution(input);
            break;
        case 17:
            day17_solution(input);
            break;
        case 18:
            day18_solution(input);
            break;
        case 19:
            day19_solution(input);
            break;
        case 20:
            day20_solution(input);
            break;
        case 21:
            day21_solution(input);
            break;
        case 22:
            day22_solution(input);
            break;
        case 23:
            day23_solution(input);
            break;
        case 24:
            day24_solution(input);
            break;
        case 25:
            day25_solution(input);
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