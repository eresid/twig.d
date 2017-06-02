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

    this(Data data) {
        this.data = data;
    }

    string toComment(string comment) {
        return "<!-- " ~ comment ~ " -->";
    }

    string toVariable(string variable) {
        return null;
        //return mixin (print(variable));// data[variable];
    }
}

private string print(string value) {
   return `writeln("data.` ~ value ~ `");`;
}

unittest {


}