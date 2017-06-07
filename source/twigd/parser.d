module twigd.parser;

import std.algorithm.searching : canFind;
import std.array : replaceSlice;
import std.string : strip;
version(unittest) {
    import std.stdio;
}

import twigd.data;
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
        this.generator = new Generator(Data());
    }

    this(Data data) {
        this.generator = new Generator(data);
    }

    string parse(string content) {
        elements.length = 0;
        ulong indexFrom = 0;

        Element currentElement = null;

        // find all elements on top level
        do {
            currentElement = toElement(content, indexFrom, content.length);
            if (currentElement !is null) {
                elements ~= currentElement;
                indexFrom = currentElement.indexTo;
            }
        } while (currentElement !is null);

        // change elements to output text
        for (int i=0; i<elements.length; i++) {
            Element tempElement = elements[i];

            final switch(tempElement.type) {
                case Delimiter.Type.COMMENT: {
                    content = content[0 .. tempElement.indexFrom]
                            ~ generator.toComment(tempElement.expression)
                            ~ content[tempElement.indexTo .. content.length];
                    break;
                }
                case Delimiter.Type.VARIABLE: {
                    content = content[0 .. tempElement.indexFrom]
                            ~ generator.toVariable(tempElement.expression)
                            ~ content[tempElement.indexTo .. content.length];
                    break;
                }
                case Delimiter.Type.BLOCK: {
                    break;
                }
            }
        }

        return content;
    }

    string parse2(string content) {
        string result = "";

        elements.length = 0;
        ulong indexFrom = 0;

        Element nextElement;
        do {
            nextElement = findNextElement(content, indexFrom);

            if (nextElement is null) {
                result ~= toPrint(content[indexFrom .. content.length]);
            } else {
                result ~= toPrint(content[indexFrom .. nextElement.indexFrom]);

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

    private string toPrint(const string content) {
        return "str ~= \"" ~ content ~ "\"\n";
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

    private Element toElement(ref string content, ulong indexFrom, ulong indexTo) {
        Element element = null;

        for(ulong i = indexFrom; i < indexTo; i++) {
            if (i+2 >= indexTo) {
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

                for(ulong j = i; j < indexTo; j++) {
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

    Data data = Data();
    data.title = "Awesome Title";

    string str = "<html><header><title>{{ title }}</title></header><body></body></html>";
    string res1 = parser.parse2(str);
    //writeln(res1);
    assert(parser.elements.length == 0);
}

/+
unittest {
    Parser parser = new Parser;

    string str = "<html><header><title>This is title</title></header><body>Hello world</body></html>";
    string result = parser.parse(str);
    assert(parser.elements.length == 0);
}

unittest {
    Data data = Data();
    data.title = "Awesome Title";
    Parser parser = new Parser(data);

    string str = "<title>{{ title }}</title>";
    string result = parser.parse(str);
    writeln("RESULT ", result);
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
    assert(result == "<title><!-- some comment --></title>");
    assert(parser.elements.length == 1);

    Element element = parser.elements[0];
    assert(element.type == Delimiter.Type.COMMENT);
    assert(element.expression == "some comment");
    assert(element.indexFrom == 7);
    assert(element.indexTo == 25);
}+/