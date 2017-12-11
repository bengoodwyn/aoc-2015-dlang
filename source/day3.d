import std.algorithm;
import std.array;
import std.conv;
import std.range;
import std.stdio;
import std.string;
import std.typecons;

alias House = Tuple!(int,"x",int,"y");

auto move(House house, char direction) {
    final switch (direction) {
        case 'v':
            return House(house.x, house.y-1);
        case '^':
            return House(house.x, house.y+1);
        case '<':
            return House(house.x-1, house.y);
        case '>':
            return House(house.x+1, house.y);
    }
}

unittest {
    import fluent.asserts;

    House(0,0).move('v').should.equal(House(0,-1));
    House(0,0).move('^').should.equal(House(0,1));
    House(0,0).move('<').should.equal(House(-1,0));
    House(0,0).move('>').should.equal(House(1,0));
}

alias Counts = int[House];

void count_presents(T)(T lines, ref Counts counts) {
    House position = House(0,0);
    counts[position] = counts.get(position, 0) + 1;

    auto deliver = delegate(House position, char direction) {
        auto new_position = position.move(direction);
        counts[new_position] = counts.get(new_position, 0) + 1;
        return new_position;
    };

    lines
        .joiner
        .map!(to!char)
        .fold!(deliver)(position);
}

unittest {
    import fluent.asserts;

    {
        Counts counts;
        [">"].count_presents(counts);
        counts[House(0,0)].should.equal(1);
        counts[House(1,0)].should.equal(1);
        counts.byKey.count.should.equal(2);
    }
    
    {
        Counts counts;
        ["^>v<"].count_presents(counts);
        counts[House(0,0)].should.equal(2);
        counts[House(0,1)].should.equal(1);
        counts[House(1,1)].should.equal(1);
        counts[House(1,0)].should.equal(1);
        counts.byKey.count.should.equal(4);
    }
    
    {
        Counts counts;
        ["^v^v^v^v^v"].count_presents(counts);
        counts[House(0,0)].should.equal(6);
        counts[House(0,1)].should.equal(5);
        counts.byKey.count.should.equal(2);
    }
}

auto part1() {
    Counts counts;
    File("inputs/day3.txt")
        .byLine
        .count_presents(counts);
    return counts.byKey.count;
}

auto part2() {
    Counts counts;
    File("inputs/day3.txt")
        .byLine
        .map!(line => line.stride(2))
        .count_presents(counts);
    File("inputs/day3.txt")
        .byLine
        .map!(line => line.drop(1).stride(2))
        .count_presents(counts);
    return counts.byKey.count;
}

