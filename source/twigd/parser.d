module twigd.parser;

class Parser {

    private immutable string[3] openDelimiters = [Delimiter.CommentOpen, Delimiter.CommentOpen, Delimiter.CommentOpen];

    struct Tag {

    }

    Tag strToTree(string content, int s, int t) {
        //writeln("s : ",s," t : ",t);
        if(s > t)return new Constant(null);

        bool findVar = false;
        bool findExe = false;
        int ves,vet;
        static import std.algorithm;
        for(int i = s; i<t; i++) {
            if (canFind(openDelimiters, content[i..i+2])) {
                ves = i;
                if (content[i+1] == '{') findVar = true;
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

        if(ves==0 && !findVar && !findExe)return new Constant(content[s..t]);
        if(findVar && ves==s)return new VariableReference(content[ves+2 .. vet-2]);
        if(findExe && ves==s)return new ExecuteBlock(content[ves+2 .. vet-2]);
        if(content[ves .. ves+2] == "{%")
            return new Operation(strToTree(content,s,ves),new ExecuteBlock(content[ves+2 .. vet-2]),strToTree(content,vet,t));
        else
            return new Operation(strToTree(content,s,ves),new VariableReference(content[ves+2 .. vet-2]),strToTree(content,vet,t));
    }
}