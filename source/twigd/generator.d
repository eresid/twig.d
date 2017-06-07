module twigd.generator;

import std.conv : to;
import std.meta;
import std.traits;
import std.typecons;
version(unittest) {
    import std.stdio;
}
import std.array : appender;

import twigd.data;

class Generator {

    private Data data;

    this(Data data) {
        this.data = data;
    }

    string toComment(string comment) {
        auto result = appender!string();

        string commentName = "comment" ~ to!string(comment.hashOf());

        result.put("string ");
        result.put(commentName);
        result.put(" = \"");
        result.put(comment);
        result.put("\";\n");

        result.put("str.put(\"<!-- \");\n");
        result.put("str.put(commentName);\n");
        result.put("str.put(\" -->\");\n");

        return result.data;
    }

    string toVariable(string variable) {
        return "str.put(to!string(data." ~ variable ~ "));\n";
    }
}

unittest {
    Data data = Data();
    data.title = "Awesome Twig.d";
    auto generator = new Generator(data);

    write(generator.toComment("some comment"));
    write(generator.toVariable("title"));
}