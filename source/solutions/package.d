module solutions;

import 
    day1, day2, day3, day4, day5,
    day6, day7, day8, day9, day10, 
    day11, day12, day13, day14, day15, 
    day16, day17, day18, day19, day20, 
    day21, day22, day23, day24, day25;

public class Solutions
{
    private void function(string)[byte] solutionsMap;

    this()
    {
        solutionsMap = [
            1: &day1.solution,
            2: &day2.solution,
            3: &day3.solution,
            4: &day4.solution,
            5: &day5.solution,
            6: &day6.solution,
            7: &day7.solution,
            8: &day8.solution,
            9: &day9.solution,
            10: &day10.solution,
            11: &day11.solution,
            12: &day12.solution,
            13: &day13.solution,
            14: &day14.solution,
            15: &day15.solution,
            16: &day16.solution,
            17: &day17.solution,
            18: &day18.solution,
            19: &day19.solution,
            20: &day20.solution,
            21: &day21.solution,
            22: &day22.solution,
            23: &day23.solution,
            24: &day24.solution,
            25: &day25.solution
        ];
    }

    public void function(string) getDaysSolution(byte day)
    {
        return solutionsMap[day];
    }
}