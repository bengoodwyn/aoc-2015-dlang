import std.algorithm;
import std.array;
import std.conv;
import std.range;
import std.stdio;
import std.string;
import std.typecons;

auto has_double_letter(const char[] word) {
    return word.zip(word[1..$])
        .any!(pair => pair[0] == pair[1]);
}

unittest {
    import fluent.asserts;

    "aa".has_double_letter.should.equal(true);
    "abc".has_double_letter.should.equal(false);
    "abbc".has_double_letter.should.equal(true);
}

auto has_no_banned_strings(const char[] word) {
    return -1 == word.indexOf("ab")
        && -1 == word.indexOf("cd")
        && -1 == word.indexOf("pq")
        && -1 == word.indexOf("xy");
}

unittest {
    import fluent.asserts;

    "aa".has_no_banned_strings.should.equal(true);
    "qqqqabqqq".has_no_banned_strings.should.equal(false);
    "qqqcdbqqq".has_no_banned_strings.should.equal(false);
    "qqqqapqqq".has_no_banned_strings.should.equal(false);
    "qqqqaxxyq".has_no_banned_strings.should.equal(false);
}

auto has_enough_vowels(const char[] word) {
    return 3 <= word
        .filter!(x => "aeiou".indexOf(x) >= 0)
        .count;
}

unittest {
    import fluent.asserts;

    "aa".has_enough_vowels.should.equal(false);
    "aea".has_enough_vowels.should.equal(true);
    "aya".has_enough_vowels.should.equal(false);
    "axxxxxxxxxxxsdfsdfsdfsdfa".has_enough_vowels.should.equal(false);
    "aeiou".has_enough_vowels.should.equal(true);
}

auto count_nice(T)(T lines) {
    return lines
        .filter!has_enough_vowels
        .filter!has_double_letter
        .filter!has_no_banned_strings
        .count;
}

unittest {
    import fluent.asserts;

    ["ugknbfddgicrmopn"].count_nice.should.equal(1).because("it has at least three vowels (u...i...o...), a double letter (...dd...), and none of the disallowed substrings");
    ["aaa"].count_nice.should.equal(1).because("it has at least three vowels and a double letter, even though the letters used by different rules overlap");
    ["jchzalrnumimnmhp"].count_nice.should.equal(0).because("it has no double letter");
    ["haegwjzuvuyypxyu"].count_nice.should.equal(0).because("it contains the string xy");
    ["dvszwmarrgswjxmb"].count_nice.should.equal(0).because("it contains only one vowel");
}

auto part1() {
    return File("inputs/day5.txt")
        .byLine
        .count_nice;
}

auto has_sandwich(const char[] word) {
    return word
            .zip(word[2..$])
            .any!(pair => pair[0] == pair[1]);
}

unittest {
    import fluent.asserts;

    "xyx".has_sandwich.should.equal(true);
    "xyz".has_sandwich.should.equal(false);
    "zzx".has_sandwich.should.equal(false);
    "abcdefeghi".has_sandwich.should.equal(true);
    "aaa".has_sandwich.should.equal(true);
}

auto has_repeated_pair(const char[] word) {
    return iota(0,word.length-3)
        .map!(start => tuple(word[start..start+2], word[start+2..$]))
        .any!(pair => pair[1].indexOf(pair[0]) >= 0);
}

unittest {
    import fluent.asserts;

    "xyxy".has_repeated_pair.should.equal(true);
    "aabcdefgaa".has_repeated_pair.should.equal(true);
    "aaa".has_repeated_pair.should.equal(false);
    "abcdefghijklmnop".has_repeated_pair.should.equal(false);
}

auto count_nicer(T)(T lines) {
    return lines
        .filter!has_repeated_pair
        .filter!has_sandwich
        .count;
}

unittest {
    import fluent.asserts;

    ["qjhvhtzxzqqjkmpb"].count_nicer.should.equal(1).because("it has a pair that appears twice (qj) and a letter that repeats with exactly one letter between them (zxz)");
    ["xxyxx"].count_nicer.should.equal(1).because("it has a pair that appears twice and a letter that repeats with one between, even though the letters used by each rule overlap");
    ["uurcxstgmygtbstg"].count_nicer.should.equal(0).because("it has a pair (tg) but no repeat with a single letter between them");
    ["ieodomkazucvgmuy"].count_nicer.should.equal(0).because("it has a repeating letter with one between (odo), but no pair that appears twice");
}

auto part2() {
    return File("inputs/day5.txt")
        .byLine
        .count_nicer;
}
