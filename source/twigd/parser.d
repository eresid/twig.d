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
    Tag[] tags;

    this() {
        this.generator = new Generator(Data());
    }

    this(Data data) {
        this.generator = new Generator(data);
    }

    public string parse(string content) {
        tags.length = 0;
        ulong indexFrom = 0;

        Tag currentTag = null;

        do {
            currentTag = toTag(content, indexFrom, content.length);
            if (currentTag !is null) {
                tags ~= currentTag;
                indexFrom = currentTag.indexTo;
            }
        } while (currentTag !is null);

        for (int i=0; i<tags.length; i++) {
            Tag tempTag = tags[i];

            final switch(tempTag.type) {
                case Delimiter.Type.COMMENT: {
                    content = content[0 .. tempTag.indexFrom]
                            ~ generator.toComment(tempTag.expression)
                            ~ content[tempTag.indexTo .. content.length];
                    break;
                }
                case Delimiter.Type.VARIABLE: {
                    content = content[0 .. tempTag.indexFrom]
                            ~ generator.toVariable(tempTag.expression)
                            ~ content[tempTag.indexTo .. content.length];
                    break;
                }
                case Delimiter.Type.BLOCK: {
                    break;
                }
            }
        }

        return content;
    }

    Tag toTag(ref string content, ulong indexFrom, ulong indexTo) {
        Tag tag = new Tag;

        for(ulong i = indexFrom; i < indexTo; i++) {
            if (i+2 >= indexTo) {
                return null;
            }

            string word = content[i .. i+2];

            if (canFind(Delimiter.OPEN_DELIMITERS, word)) {
                tag.indexFrom = i;

                if (word == Delimiter.COMMENT_START) {
                    tag.type = Delimiter.Type.COMMENT;
                } else if (word == Delimiter.VARIABLE_START) {
                    tag.type = Delimiter.Type.VARIABLE;
                } else if (word == Delimiter.BLOCK_START) {
                    tag.type = Delimiter.Type.BLOCK;
                }

                if (tag.type == Delimiter.Type.BLOCK) {
                    throw new NotImplementedException("Blocks {% %} are not supported");
                }

                for(ulong j = i; j < indexTo; j++) {
                    if (canFind(Delimiter.CLOSE_DELIMITERS, content[j .. j+2])) {
                        tag.indexTo = j+2;
                        break;
                    }
                }
                break;
            }
        }

        tag.expression = strip(content[tag.indexFrom+2 .. tag.indexTo-2]);

        return tag;
    }
}

class Tag {
    Delimiter.Type type;
    string expression;
    string bodyStr;

    ulong indexFrom;
    ulong indexTo;
    Tag[] tags;
}

unittest {
    Parser parser = new Parser;

    string str = "<html><header><title>This is title</title></header><body>Hello world</body></html>";
    string result = parser.parse(str);
    assert(parser.tags.length == 0);
}

unittest {
    Data data = Data();
    data.title = "Awesome Title";
    Parser parser = new Parser(data);

    string str = "<title>{{ title }}</title>";
    string result = parser.parse(str);
    writeln("RESULT ", result);
    assert(parser.tags.length == 1);

    Tag tag = parser.tags[0];
    assert(tag.type == Delimiter.Type.VARIABLE);
    assert(tag.expression == "title");
    assert(tag.indexFrom == 7);
    assert(tag.indexTo == 18);
}

unittest {
    Parser parser = new Parser;

    string str = "<!DOCTYPE html><html><head><meta http-equiv=\"Content-type\" content=\"text/html; charset=utf-8\">
    <title>{{title}}</title></head><body><h1>Hello world</h1><p>And hello {# name #}</p></body></html>";
    string result = parser.parse(str);
    assert(parser.tags.length == 2);

     Tag tag1 = parser.tags[0];
     assert(tag1.type == Delimiter.Type.VARIABLE);
     assert(tag1.expression == "title");
     assert(tag1.indexFrom == 106);
     assert(tag1.indexTo == 115);

     Tag tag2 = parser.tags[1];
     assert(tag2.type == Delimiter.Type.COMMENT);
     assert(tag2.expression == "name");
     assert(tag2.indexFrom == 169);
     assert(tag2.indexTo == 179);
}

unittest {
    Parser parser = new Parser;

    string str = "<title>{# some comment #}</title>";
    string result = parser.parse(str);
    assert(result == "<title><!-- some comment --></title>");
    assert(parser.tags.length == 1);

    Tag tag = parser.tags[0];
    assert(tag.type == Delimiter.Type.COMMENT);
    assert(tag.expression == "some comment");
    assert(tag.indexFrom == 7);
    assert(tag.indexTo == 25);
}