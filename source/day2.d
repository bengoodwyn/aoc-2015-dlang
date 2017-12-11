import std.algorithm;
import std.array;
import std.conv;
import std.stdio;
import std.string;

alias Dimensions = int[];

auto dimensions(const char[] line) {
    return line
        .split("x")
        .map!(to!int)
        .array
        .sort
        .array;
}

unittest {
    import fluent.asserts;

    "1x2x33".dimensions.should.equal([1,2,33]);
    "22x32x1".dimensions.should.equal([1,22,32]);
}

auto surface_area(Dimensions dimensions) {
    return 2 * dimensions[0] * dimensions[1]
        + 2 * dimensions[1] * dimensions[2]
        + 2 * dimensions[0] * dimensions[2];
}

unittest {
    import fluent.asserts;

    "2x3x4".dimensions.surface_area.should.equal(52);
    "1x1x10".dimensions.surface_area.should.equal(42);
}

auto slack(Dimensions dimensions) {
    return dimensions[0] * dimensions[1];
}

unittest {
    import fluent.asserts;

    "2x3x4".dimensions.slack.should.equal(6);
    "1x1x10".dimensions.slack.should.equal(1);
}

auto ribbon_to_wrap(Dimensions dimensions) {
    return 2 * dimensions[0] + 2 * dimensions[1];
}

unittest {
    import fluent.asserts;

    "2x3x4".dimensions.ribbon_to_wrap.should.equal(10);
    "1x1x10".dimensions.ribbon_to_wrap.should.equal(4);
}

auto ribbon_for_bow(Dimensions dimensions) {
    return dimensions
            .fold!((length,dimension) => length*dimension)(1);
}

unittest {
    import fluent.asserts;

    "2x3x4".dimensions.ribbon_for_bow.should.equal(24);
    "1x1x10".dimensions.ribbon_for_bow.should.equal(10);
}

auto part1() {
    return File("inputs/day2.txt")
            .byLine()
            .map!dimensions
            .map!(dimensions => dimensions.surface_area + dimensions.slack)
            .sum;
}

auto part2() {
    return File("inputs/day2.txt")
            .byLine()
            .map!dimensions
            .map!(dimensions => dimensions.ribbon_to_wrap + dimensions.ribbon_for_bow)
            .sum;
}
