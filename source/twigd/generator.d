module twigd.generator;

import std.conv : to;

import twigd.data;

version(unittest) {
    import std.stdio;
}

class Generator {

    private Data data;

    this(Data data) {
        this.data = data;
    }

    string toComment(string comment) {
        return "<!-- " ~ comment ~ " -->";
    }

    string toVariable(string variable) {
        // "writeln(data." ~ variable ~ ");";
        return null;//mixin("writeln(\"Hello World!\");");
    }
}

unittest {


}