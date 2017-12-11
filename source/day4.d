import std.algorithm;
import std.array;
import std.conv;
import std.digest.md;
import std.range;
import std.stdio;
import std.string;
import std.typecons;

auto produces_hash(const char[] secret_key, int x, const char[] starting_with) {
    const char[] input = secret_key ~ "%d".format(x);
    ubyte[16] md5 = md5Of(input);
    return md5.toHexString[0..starting_with.length] == starting_with;
}

auto produces_hash(const char[] secret_key, const char[] starting_with) {
    return iota(1, int.max)
        .filter!(x => produces_hash(secret_key, x, starting_with))
        .take(1)
        .front;
}

unittest {
    import fluent.asserts;

    "abcdef".produces_hash("00000").should.equal(609043).because("the MD5 hash of abcdef609043 starts with five zeroes (000001dbbfa...), and it is the lowest such number to do so");
    "pqrstuv".produces_hash("00000").should.equal(1048970).because("the MD5 hash of pqrstuv1048970 looks like 000006136ef....");
}

auto part1() {
    return File("inputs/day4.txt")
        .byLine()
        .front
        .produces_hash("00000");
}

auto part2() {
    return File("inputs/day4.txt")
        .byLine()
        .front
        .produces_hash("000000");
}
