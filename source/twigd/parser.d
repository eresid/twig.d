module twigd.parser;

import std.algorithm.searching : canFind;
import std.array : replaceSlice;
import std.string : strip;
version(unittest) {
    import std.stdio;
}

import twigd.delimiter;
import twigd.exceptions;
import twigd.generator;

struct Parser {

    static string parse(string content, ulong indexFrom = 0) {
        Generator generator;
        string result = "";

        Element nextElement;
        do {
            nextElement = findNextElement(content, indexFrom);

            if (nextElement is null) {
                result ~= generator.toString(content[indexFrom .. content.length]);
            } else {
                result ~= generator.toString(content[indexFrom .. nextElement.indexFrom]);

                if (nextElement.type == Delimiter.Type.COMMENT) {
                    result ~=  generator.toComment(nextElement.expression);
                } else if (nextElement.type == Delimiter.Type.VARIABLE) {
                    result ~=  generator.toVariable(nextElement.expression);
                } else {
                    throw new NotImplementedException("Blocks {% %} are not supported");
                }

                indexFrom = nextElement.indexTo;
            }

        } while (nextElement !is null);

        return result;
    }

    private static Element findNextElement(const ref string content, ulong indexFrom) {
        Element element = null;

        for(ulong i = indexFrom; i < content.length; i++) {
            if (i+2 >= content.length) {
                return null;
            }

            string word = content[i .. i+2];

            if (canFind(Delimiter.OPEN_DELIMITERS, word)) {
                element = new Element;

                element.indexFrom = i;

                if (word == Delimiter.COMMENT_START) {
                    element.type = Delimiter.Type.COMMENT;
                } else if (word == Delimiter.VARIABLE_START) {
                    element.type = Delimiter.Type.VARIABLE;
                } else if (word == Delimiter.BLOCK_START) {
                    element.type = Delimiter.Type.BLOCK;
                }

                if (element.type == Delimiter.Type.BLOCK) {
                    throw new NotImplementedException("Blocks {% %} are not supported");
                }

                for(ulong j = i; j < content.length; j++) {
                    if (canFind(Delimiter.CLOSE_DELIMITERS, content[j .. j+2])) {
                        element.indexTo = j+2;
                        break;
                    }
                }
                break;
            }
        }

        element.expression = strip(content[element.indexFrom+2 .. element.indexTo-2]);

        return element;
    }
}

class Element {
    Delimiter.Type type;
    string expression;
    string bodyStr;

    ulong indexFrom;
    ulong indexTo;
    Element[] elements;
}

template GenMethod(string funcName, string funcBody) {
    const char[] GenMethod = "string " ~ funcName ~ "(Data data) {\n"
        ~ "import std.array : appender;\n"
        ~ "import std.conv : to;\n"
        ~ "auto str = appender!string();\n"
        ~ funcBody
        ~ "return str.data;\n" ~
    "}";
}

unittest {
    // Test zero elements
    string source1 = "<html><header><title></title></header><body></body></html>";
    string result1 = "str.put(\"<html><header><title></title></header><body></body></html>\");\n";
    assert(Parser.parse(source1) == result1);

    // Test one variable
    string source2 = "<html><header><title>{{ title }}</title></header><body></body></html>";
    string result2 = "str.put(\"<html><header><title>\");\nstr.put(to!string(data.title));\nstr.put(\"</title></header><body></body></html>\");\n";
    assert(Parser.parse(source2) == result2);

    // Test two variables
    string source3 = "<html><header><title>{{ title }}</title></header><body>{{ bodyText }}</body></html>";
    string result3 = "str.put(\"<html><header><title>\");\nstr.put(to!string(data.title));\nstr.put(\"</title></header><body>\");\nstr.put(to!string(data.bodyText));\nstr.put(\"</body></html>\");\n";
    assert(Parser.parse(source3) == result3);
}

unittest {
    import twigd.data;

    enum string html = "<html><header><title>{{ title }}</title></header><body></body></html>";
    enum string source = Parser.parse(html);
    mixin(GenMethod!("test", source));

    Data data = Data();
    data.title = "Awesome Title";
    string result1 = "<html><header><title>Awesome Title</title></header><body></body></html>";
    assert(test(data) == result1);
    data.title = "Another Title";
    string result2 = "<html><header><title>Another Title</title></header><body></body></html>";
    assert(test(data) == result2);
}

unittest {
    string str = "<title>{{ title }}</title>";
    string result = "str.put(\"<title>\");\nstr.put(to!string(data.title));\nstr.put(\"</title>\");\n";

    assert(Parser.parse(str) == result);
}

unittest {
    string str = "<title>{# some comment #}</title>";
    string result = Parser.parse(str);
    assert(result == "str.put(\"<title>\");\nstr.put(\"<!-- some comment -->\");\nstr.put(\"</title>\");\n");
}