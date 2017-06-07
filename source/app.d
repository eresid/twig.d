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

    //testFormat(true);
}

private void testImport() {
    enum string val = import("testfile.txt");
    writeln(val);
    mixin(val);

    writeln(msg);
}

private string tempMethod(Data data) {
    import std.array : appender;

    auto str = appender!string();

    str.put("<html><header><title>");
    str.put(to!string(data.title));
    str.put("</title></header><body></body></html>");

    str.put("\n");
    return str.data;
}

private void testFormat(bool isFormatter) {
    import std.array : appender;
    import std.format : formattedWrite;
    import std.conv : to;

    if (isFormatter) {
        //  50 - 0m1.501s 100k
        // 100 - 0m2.846s 100k
        // 200 - 0m5.615s 100k
        // 200 - 0m3.924s 100k, release
        // 200 - 0m2.753s 100k, -b=release --compiler=ldc2
        // 500 - 0m6.793s 50k
        // 500 - 0m3.271s 50k, -b=release --compiler=ldc2
        for (int i=0; i<100_000; i++) {
            auto writer = appender!string();

            for (int j=0; j<200; j++) {
                writer.put(to!string(42));
                writer.put(" is the ultimate ");
                writer.put("answer");
                writer.put(".");
            }

            //writeln(writer.data); // "42 is the ultimate answer."
        }
    } else {
        //  50 - 0m1.746s 100k
        // 100 - 0m3.385s 100k
        // 200 - 0m6.409s 100k
        // 200 - 0m5.295s 100k, -b=release
        // 200 - 0m4.728s 100k, -b=release --compiler=ldc2
        // 500 - 0m7.846s 50k
        // 500 - 0m5.487s 50k, -b=release --compiler=ldc2
        for (int i=0; i<100_000; i++) {
            auto str = "";

            for (int j=0; j<200; j++) {
                str ~= to!string(42) ~ " is the ultimate " ~ "answer" ~ ".";
            }
            //writeln(str);
        }
    }
}