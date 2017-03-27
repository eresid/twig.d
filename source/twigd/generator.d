module twigd.generator;

import std.conv : to;
import std.meta;
import std.traits;
import std.typecons;
version(unittest) {
    import std.stdio;
}

import twigd.data;

class Generator {

    private Data data;

    private alias allMembers(T...) = Identity!(__traits(allMembers, T));
    private alias getMember(T...) = Identity!(__traits(getMember, T));

    this(Data data) {
        this.data = data;
    }

    string toComment(string comment) {
        return "<!-- " ~ comment ~ " -->";
    }

    string toVariable(string variable) {
        foreach(n; allMembers!data) {
            if (n == variable) {
                return getMember!(data, variable);
            }
        }

        return "";
    }
}

unittest {


}