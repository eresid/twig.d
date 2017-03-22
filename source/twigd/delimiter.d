module twigd.delimiter;

struct Delimiter {
    immutable static string COMMENT_START = "{#";
    immutable static string COMMENT_END = "#}";
    immutable static string VARIABLE_START = "{{";
    immutable static string VARIABLE_END = "}}";
    immutable static string BLOCK_START = "{%";
    immutable static string BLOCK_END = "%}";

    enum Type {
        COMMENT,
        VARIABLE,
        BLOCK
    }
}

