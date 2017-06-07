module twigd.generator;

import std.conv : to;
import std.meta;
import std.traits;
import std.typecons;
version(unittest) {
    import std.stdio;
}
import std.array : appender;

class Generator {

    string toString(string value) {
         return "str.put(\"" ~ value ~ "\"));\n";
    }

    string toComment(string comment) {
        return "str.put(\"<!-- " ~ comment ~ " -->\");\n";
    }

    string toVariable(string variable) {
        return "str.put(to!string(data." ~ variable ~ "));\n";
    }
}

unittest {
    auto generator = new Generator();

    string commentResult = "str.put(\"<!-- some comment -->\");\n";
    assert(generator.toComment("some comment") == commentResult);

    assert(generator.toVariable("title") == "str.put(to!string(data.title));\n");

    string templateStr = "<!DOCTYPE html><html><body><h1>Hello twig.d!</h1></body></html>";
    string templateResult = "str.put(\"<!DOCTYPE html><html><body><h1>Hello twig.d!</h1></body></html>\"));\n";
    assert(generator.toString(templateStr) == templateResult);
}