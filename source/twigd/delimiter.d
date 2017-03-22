module twigd.delimiter;

struct Delimiter {
    immutable string CommentOpen = "{#";
    immutable string CommentClose = "#}";
    immutable string VariableOpen = "{{";
    immutable string VariableClose = "}}";
    immutable string BlockOpen = "{%";
    immutable string BlockClose = "%}";
}

