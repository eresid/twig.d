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

    string toComment(string bodyStr) {
        return "<!-- " ~ bodyStr ~ " -->";
    }

    string toVariable() {
        return mixin("writeln(\"Hello World!\");");
    }
}

unittest {


}