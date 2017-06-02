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
        string commentName = "comment" ~ to!string(comment.hashOf());

        string result = "string " ~ commentName ~ " = \"" ~ comment ~ "\";\n";
        return result ~ "str ~= \"<!-- \" ~ " ~ commentName ~ " ~ \" -->\";\n";
    }

    string toVariable(string variable) {
        return "str ~= to!string(data." ~ variable ~ ");\n";
    }
}

unittest {
    Data data = Data();
    data.title = "Awesome Twig.d";
    auto generator = new Generator(data);

    write(generator.toComment("some comment"));
    write(generator.toVariable("title"));
}