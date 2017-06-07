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
    auto generator = new Generator();

    string commentResult = "string comment2390961865 = \"some comment\";\nstr.put(\"<!-- \");\nstr.put(commentName);\nstr.put(\" -->\");\n";
    assert(generator.toComment("some comment") == commentResult);

    assert(generator.toVariable("title") == "str.put(to!string(data.title));\n");
}