import std.stdio;
import std.conv : to;

import twigd.data;
import twigd.exceptions;
import twigd.parser;

void main()
{
	writeln("Edit source/app.d to start your project.");

	import std.string : replace;

	string str = "Some text {{ololo}}";

	writeln(str.replace("ololo", "trololo"));
	//throw new NotImplementedException("Something wrong");

    //Parser parser = new Parser;
    //string resultStr = parser.parse("Content");

    //testImport();

    Data data = Data();
    data.title = "Awesome Twig.d";
    write(tempMethod(data));
}

private void testImport() {
    enum string val = import("testfile.txt");
    writeln(val);
    mixin(val);

    writeln(msg);
}

private string tempMethod(Data data) {
    string str = "";
    str ~= "<html><header><title>";
    str ~= to!string(data.title);
    str ~= "</title></header><body></body></html>";

    str ~= "\n";
    return str;
}