module twigd.reference.functions;

import std.string : strip;

class Functions {

    immutable static string ATTRIBUTE = "attribute(";
    immutable static string BLOCK = "block(";
    immutable static string CONSTANT = "constant(";
    immutable static string CYCLE = "cycle(";
    immutable static string DATE = "date(";
    immutable static string DUMP = "dump(";
    immutable static string INCLUDE = "include(";
    immutable static string MAX = "max(";
    immutable static string MIN = "min(";
    immutable static string PARENT = "parent(";
    immutable static string RANDOM = "random(";
    immutable static string RANGE = "range(";
    immutable static string SOURCE = "source(";
    immutable static string TEMPLATE_FROM_STRING = "template_from_string(";

    enum Type {
        ATTRIBUTE,
        BLOCK,
        CONSTANT,
        CYCLE,
        DATE,
        DUMP,
        INCLUDE,
        MAX,
        MIN,
        PARENT,
        RANDOM,
        RANGE,
        SOURCE,
        TEMPLATE_FROM_STRING,
        NULL
    }

    bool isFunction(string expression) {
        return false;
    }

    Type getType(string expression) {
        return Type.ATTRIBUTE;
    }
}

unittest {

}