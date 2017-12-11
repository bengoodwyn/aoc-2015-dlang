import std.algorithm;
import std.conv;
import std.stdio;
import std.string;

enum start_floor = 0;

auto next_floor(int current_floor, char instruction) {
    final switch (instruction) {
        case '(':
            return current_floor + 1;
        case ')':
            return current_floor - 1;
    }
}

unittest {
    import fluent.asserts;

    1.next_floor('(').should.equal(2);
    5.next_floor(')').should.equal(4);
}

auto final_floor(T)(T lines) {
    return lines
        .joiner
        .map!(to!char)
        .fold!(next_floor)(start_floor);
}

unittest {
    import fluent.asserts;

    ["(())"].final_floor.should.equal(0);
    ["()()"].final_floor.should.equal(0);
    ["((("].final_floor.should.equal(3);
    ["(()(()("].final_floor.should.equal(3);
    ["))((((("].final_floor.should.equal(3);
    ["())"].final_floor.should.equal(-1);
    ["))("].final_floor.should.equal(-1);
    [")))"].final_floor.should.equal(-3);
    [")())())"].final_floor.should.equal(-3);
}

auto steps_to_basement(T)(T lines) {
    return lines
        .joiner
        .map!(to!char)
        .cumulativeFold!(next_floor)(start_floor)
        .until!(current_floor => current_floor == -1)
        .count + 1;
}

unittest {
    import fluent.asserts;

    [")"].steps_to_basement.should.equal(1);
    ["()())"].steps_to_basement.should.equal(5);
}


auto part1() {
    return File("inputs/day1.txt")
            .byLine()
            .final_floor;
}

auto part2() {
    return File("inputs/day1.txt")
            .byLine()
            .steps_to_basement;
}
