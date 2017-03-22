module twigd.reference.tags;

import std.string : stripLeft, split;
import std.algorithm.searching : startsWith;
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

    Type getType(string expression) {
        string value = stripLeft(expression).split[0];

        if (value == AUTOSCAPE) {
            return Type.AUTOSCAPE;
        } else if (value == END_AUTOSCAPE) {
            return Type.END_AUTOSCAPE;
        } else if (value == WIDH) {
            return Type.WIDH;
        } else if (value == END_WIDH) {
            return Type.END_WIDH;
        } else if (value == BLOCK) {
            return Type.BLOCK;
        } else if (value == END_BLOCK) {
            return Type.END_BLOCK;
        } else if (value == IF) {
            return Type.IF;
        } else if (value == ELSEIF) {
            return Type.ELSEIF;
        } else if (value == ELSE) {
            return Type.ELSE;
        } else if (value == END_IF) {
            return Type.END_IF;
        } else if (value == FOR) {
            return Type.FOR;
        } else if (value == END_FOR) {
            return Type.END_FOR;
        } else if (value == EMBED) {
            return Type.EMBED;
        } else if (value == END_EMBED) {
            return Type.END_EMBED;
        } else if (value == FILTER) {
            return Type.FILTER;
        } else if (value == END_FILTER) {
            return Type.END_FILTER;
        } else if (value == MACRO) {
            return Type.MACRO;
        } else if (value == END_MACRO) {
            return Type.END_MACRO;
        } else if (value == SANDBOX) {
            return Type.SANDBOX;
        } else if (value == END_SANDBOX) {
            return Type.END_SANDBOX;
        } else if (value == SPACELESS) {
            return Type.SPACELESS;
        } else if (value == END_SPACELESS) {
            return Type.END_SPACELESS;
        } else if (value == VERBATIM) {
            return Type.VERBATIM;
        } else if (value == END_VERBATIM) {
            return Type.END_VERBATIM;
        } else if (value == SET) {
            return Type.SET;
        } else if (value == END_SET) {
            return Type.END_SET;
        } else if (value == DO) {
            return Type.DO;
        } else if (value == EXTENDS) {
            return Type.EXTENDS;
        } else if (value == FLUSH) {
            return Type.FLUSH;
        } else if (value == IMPORT) {
            return Type.IMPORT;
        } else if (value == INCLUDE) {
            return Type.INCLUDE;
        }

        return Type.NULL;
    }

    bool isFunction(string expression) {
        return getType(expression) != Type.NULL;
    }

    bool isSupport(string expression) {
        switch(getType(expression)) {
            case Type.BLOCK:
            case Type.END_BLOCK:
            case Type.EXTENDS:
            //case Type.IF:
            //case Type.ELSEIF:
            //case Type.ELSE:
            //case Type.END_IF:
            case Type.INCLUDE:
                return true;
            default:
                return false;
        }
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
    Tags tags = getTags();

    Data data;
    data.online = false;

    string bodyStr = "<p>Our website is in maintenance mode. Please, come back later.</p>";

    string ifexpression = tags.ifTag("if online == false", bodyStr);
    writeln(ifexpression);

}

/**
 * Test isFunction
 */
unittest {
    Tags tags = getTags();

    assert(tags.isFunction("if online == false"));
    assert(tags.isFunction("ifonline == false") == false);
    assert(tags.isFunction("if"));
    assert(tags.isFunction("some word") == false);
    assert(tags.isFunction("for user in users"));
    assert(tags.isFunction(" endfor "));
    assert(tags.isFunction("  macro input(name, value, type, size)  "));
    assert(tags.isFunction("import 'forms.html' as forms"));
    assert(tags.isFunction("include 'header.html'"));
    assert(tags.isFunction(" set foo = 'bar' "));
}

version(unittest) {
    private Tags getTags() {
        return new Tags;
    }
}