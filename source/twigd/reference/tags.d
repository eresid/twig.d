module twigd.reference.tags;

import std.string;
version(unittest) {
    import std.stdio;
}

import twigd.data;

class Tags {

    immutable static string AUTOSCAPE = "autoescape";
    immutable static string END_AUTOSCAPE = "endautoescape";
    immutable static string WIDH = "with";
    immutable static string END_WIDH = "endwith";
    immutable static string BLOCK = "block";
    immutable static string END_BLOCK = "endblock";
    immutable static string IF = "if";
    immutable static string ELSEIF = "elseif";
    immutable static string ELSE = "else";
    immutable static string END_IF = "endif";
    immutable static string FOR = "for";
    immutable static string END_FOR = "endfor";
    immutable static string EMBED = "embed";
    immutable static string END_EMBED = "endembed";
    immutable static string FILTER = "filter";
    immutable static string END_FILTER = "endfilter";
    immutable static string MACRO = "macro";
    immutable static string END_MACRO = "endmacro";
    immutable static string SANDBOX = "sandbox";
    immutable static string END_SANDBOX = "endsandbox";
    immutable static string SPACELESS = "spaceless";
    immutable static string END_SPACELESS = "endspaceless";
    immutable static string VERBATIM = "verbatim";
    immutable static string END_VERBATIM = "endverbatim";
    immutable static string SET = "set";
    immutable static string END_SET = "endset";
    immutable static string DO = "do";
    immutable static string EXTENDS = "extends";
    immutable static string FLUSH = "flush";
    immutable static string IMPORT = "import";
    immutable static string INCLUDE = "include";

    enum Type {
        AUTOSCAPE,
        END_AUTOSCAPE,
        WIDH,
        END_WIDH,
        BLOCK,
        END_BLOCK,
        IF,
        ELSEIF,
        ELSE,
        END_IF,
        FOR,
        END_FOR,
        EMBED,
        END_EMBED,
        FILTER,
        END_FILTER,
        MACRO,
        END_MACRO,
        SANDBOX,
        END_SANDBOX,
        SPACELESS,
        END_SPACELESS,
        VERBATIM,
        END_VERBATIM,
        SET,
        END_SET,
        DO,
        EXTENDS,
        FLUSH,
        IMPORT,
        INCLUDE,
        NULL
    }

    Tags.Type getType(string expression) {
        string value = strip(expression);

        return Tags.Type.END_SET;
    }

    bool isFunction(string expression) {
        return getType(expression) != Type.NULL;
    }

    string ifTag(string expression, string bodyStd) {
        string[] words = split(expression, " ");

        string result = "";
        foreach (word; words) {
            switch(word) {
                case "if": {
                    result ~= word ~ " (";
                    break;
                }
                case "==":
                case "!=":
                case ">":
                case "<":
                case ">=":
                case "<=":  {
                    result ~= " " ~ word ~ " ";
                    break;
                }
                case "true":
                case "false": {
                    result ~= word;
                    break;
                }
                case "and": {
                    result ~= " && ";
                    break;
                }
                case "or": {
                    result ~= " || ";
                    break;
                }
                default: {
                    result ~= "data." ~ word;
                    break;
                }
            }
        }

        result ~= ") {\n    writeln(\"";
        result ~= bodyStd;
        result ~= "\")\n}";

        return result;
    }

    string forTag() {
        return null;
    }

    string blockTag() {
        return null;
    }

    string extendsTag() {
        return null;
    }

    string includeTag() {
        return null;
    }
}

/**
 * The if statement in Twig is comparable with the if statements of D.
 * In the simplest form you can use it to test if an expression evaluates to true:
 *
 * {% if online == false %}
 *     <p>Our website is in maintenance mode. Please, come back later.</p>
 * {% endif %}
 */
unittest {
    Data data;
    data.online = false;

    string bodyStr = "<p>Our website is in maintenance mode. Please, come back later.</p>";

    string ifexpression = ifTag("if online == false", bodyStr);
    writeln(ifexpression);

}