module twigd.parser;

import std.algorithm.searching : canFind;

import twigd.delimiter;

class Parser {

    private immutable string[] OPEN_DELIMITERS = [Delimiter.COMMENT_START, Delimiter.VARIABLE_START, Delimiter.BLOCK_START];

    struct Tag {
        Delimiter.Type type;
        string expression;
        string bodyStr;
        Tag[] tags;
    }

    Tag strToTree(string content, int s, int t) {
        Tag tag;
        bool findVar = false;
        bool findExe = false;
        int ves,vet;
        static import std.algorithm;
        for(int i = s; i<t; i++) {
            string word = content[i .. i+2];

            if (canFind(OPEN_DELIMITERS, word)) {
                ves = i;

                if (word == Delimiter.COMMENT_START) {
                    tag.type = Delimiter.Type.COMMENT;
                } else if (word == Delimiter.VARIABLE_START) {
                    tag.type = Delimiter.Type.VARIABLE;
                } else if (word == Delimiter.BLOCK_START) {
                    tag.type = Delimiter.Type.BLOCK;
                }
                else findExe = true;
                for(int k = i;k<t;k++)
                {
                    if(canFind(["}}","%}"],content[k..k+2]))
                    {
                        vet = k+2;
                        break;
                    }
                }
                break;
            }
        }

        //if(ves==0 && !findVar && !findExe)return new Constant(content[s..t]);
        //if(findVar && ves==s)return new VariableReference(content[ves+2 .. vet-2]);
        //if(findExe && ves==s)return new ExecuteBlock(content[ves+2 .. vet-2]);
        //if(content[ves .. ves+2] == "{%")
        //    return new Operation(strToTree(content,s,ves),new ExecuteBlock(content[ves+2 .. vet-2]),strToTree(content,vet,t));
        //else
        //   return new Operation(strToTree(content,s,ves),new VariableReference(content[ves+2 .. vet-2]),strToTree(content,vet,t));
        return tag;
    }
}

unittest {
    assert(strip("     hello world     ") == "hello world");
}