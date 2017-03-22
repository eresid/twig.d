import std.stdio;

import twigd.exceptions;

void main()
{
	writeln("Edit source/app.d to start your project.");

	import std.string : replace;

	string str = "Some text {{ololo}}";

	writeln(str.replace("ololo", "trololo"));
	//throw new NotImplementedException("Something wrong");
}
