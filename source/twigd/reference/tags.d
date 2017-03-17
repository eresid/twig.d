module twigd.reference.tags;

import std.string;

import twigd.data;

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

version(unittest) {
    import std.stdio;
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