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

class Parser {

    private Generator generator;
    private Element[] elements;
    template GenMethod(string funcName, string funcBody) {
        const char[] GenMethod = "private string " ~ funcName ~ "(Data data) { return " ~ funcBody ~ "; }";
    }

    this() {
        this.generator = new Generator();
    }

    string parse(string content, ulong indexFrom = 0) {
        string result = "";

        if (indexFrom == 0) {
            elements.length = 0; // clear array
        }

        Element nextElement;
        do {
            nextElement = findNextElement(content, indexFrom);

            if (nextElement is null) {
                result ~= generator.toString(content[indexFrom .. content.length]);
            } else {
                elements ~= nextElement;

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

    private Element findNextElement(const ref string content, ulong indexFrom) {
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

unittest {
    Parser parser = new Parser;

    // Test zero elements
    string example1 = "<html><header><title></title></header><body></body></html>";
    string result1 = "str.put(\"<html><header><title></title></header><body></body></html>\"));\n";
    assert(parser.parse(example1) == result1);
    assert(parser.elements.length == 0);

    // Test one variable
    string example2 = "<html><header><title>{{ title }}</title></header><body></body></html>";
    string result2 = "str.put(\"<html><header><title>\"));\nstr.put(to!string(data.title));\nstr.put(\"</title></header><body></body></html>\"));\n";
    assert(parser.parse(example2) == result2);
    assert(parser.elements.length == 1);

    // Test two variables
    string example3 = "<html><header><title>{{ title }}</title></header><body>{{ bodyText }}</body></html>";
    string result3 = "str.put(\"<html><header><title>\"));\nstr.put(to!string(data.title));\nstr.put(\"</title></header><body>\"));\nstr.put(to!string(data.bodyText));\nstr.put(\"</body></html>\"));\n";
    assert(parser.parse(example3) == result3);
    assert(parser.elements.length == 2);
}

unittest {
    Parser parser = new Parser();

    string str = "<title>{{ title }}</title>";
    string result = "str.put(\"<title>\"));\nstr.put(to!string(data.title));\nstr.put(\"</title>\"));\n";

    assert(parser.parse(str) == result);
    assert(parser.elements.length == 1);

    Element element = parser.elements[0];
    assert(element.type == Delimiter.Type.VARIABLE);
    assert(element.expression == "title");
    assert(element.indexFrom == 7);
    assert(element.indexTo == 18);
}

unittest {
    Parser parser = new Parser;

    string str = "<!DOCTYPE html><html><head><meta http-equiv=\"Content-type\" content=\"text/html; charset=utf-8\">
    <title>{{title}}</title></head><body><h1>Hello world</h1><p>And hello {# name #}</p></body></html>";
    string result = parser.parse(str);
    assert(parser.elements.length == 2);

     Element element1 = parser.elements[0];
     assert(element1.type == Delimiter.Type.VARIABLE);
     assert(element1.expression == "title");
     assert(element1.indexFrom == 106);
     assert(element1.indexTo == 115);

     Element element2 = parser.elements[1];
     assert(element2.type == Delimiter.Type.COMMENT);
     assert(element2.expression == "name");
     assert(element2.indexFrom == 169);
     assert(element2.indexTo == 179);
}

unittest {
    Parser parser = new Parser;

    string str = "<title>{# some comment #}</title>";
    string result = parser.parse(str);
    assert(result == "str.put(\"<title>\"));\nstr.put(\"<!-- some comment -->\");\nstr.put(\"</title>\"));\n");
    assert(parser.elements.length == 1);

    Element element = parser.elements[0];
    assert(element.type == Delimiter.Type.COMMENT);
    assert(element.expression == "some comment");
    assert(element.indexFrom == 7);
    assert(element.indexTo == 25);
}