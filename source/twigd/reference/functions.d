module twigd.reference.functions;

import std.string : stripLeft, split;
import std.algorithm.searching : startsWith;
version(unittest) {
    import std.stdio;
}

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

    Type getType(string expression) {
        string value = stripLeft(expression).split[0];

        if (value == ATTRIBUTE) {
            return Type.ATTRIBUTE;
        } else if (value == BLOCK) {
            return Type.BLOCK;
        } else if (value == CONSTANT) {
            return Type.CONSTANT;
        } else if (value == CYCLE) {
            return Type.CYCLE;
        } else if (value == DATE) {
            return Type.DATE;
        } else if (value == DUMP) {
            return Type.DUMP;
        } else if (value == INCLUDE) {
            return Type.INCLUDE;
        } else if (value == MAX) {
            return Type.MAX;
        } else if (value == MIN) {
            return Type.MIN;
        } else if (value == PARENT) {
            return Type.PARENT;
        } else if (value == RANDOM) {
            return Type.RANDOM;
        } else if (value == RANGE) {
            return Type.RANGE;
        } else if (value == SOURCE) {
            return Type.SOURCE;
        } else if (value == TEMPLATE_FROM_STRING) {
            return Type.TEMPLATE_FROM_STRING;
        }

        return Type.NULL;
    }

    bool isFunction(string expression) {
        return getType(expression) != Type.NULL;
    }

    bool isSupport(string expression) {
        return false;
    }
}

unittest {

}