module twigd.vibe;

version(HAVE_VIBE_D):

import vibe.http.server;
import vibe.textfilter.html;
import vibe.utils.dictionarylist;

import twigd.data;
import twigd.parser;

import std.stdio;

template compileHTMLDietFile(string filename, ALIASES...) {
	alias compileHTMLDietFile = compileHTMLDietFileString!(filename, import(filename), ALIASES);
}

template compileHTMLDietFileString(string filename, string contents, ALIASES...) {
	import std.conv : to;
	enum _diet_files = collectFiles!(filename, contents);

    alias TRAITS = DietTraits!ALIASES;
    pragma(msg, "Compiling Twig HTML template "~filename~"...");
    private Document _diet_nodes() { return applyTraits!TRAITS(parseDiet!(translate!TRAITS)(_diet_files)); }
    enum _dietParser = getHTMLMixin(_diet_nodes(), dietOutputRangeName, getHTMLOutputStyle!TRAITS);

	// uses the correct range name and removes 'dst' from the scope
	private void exec(R)(ref R _diet_output) {
		mixin(localAliasesMixin!(0, ALIASES));
		//pragma(msg, getHTMLMixin(nodes));
		mixin(_dietParser);
	}

	void compileHTMLDietFileString(R)(ref R dst) {
		exec(dst);
	}
}

void renderTwigStr(string templateStr, Data data) (HTTPServerResponse res) {
    auto dst = StreamOutputRange(res.bodyWriter);

	auto t = compile_temple!(templateStr, TempleHtmlFilter);
	t.render(res.bodyWriter, data);
}

void renderTwig(string templateFile, Data data) (HTTPServerResponse res) {
	auto t = compile_temple_file!(templateFile, TempleHtmlFilter);
	t.render(res.bodyWriter, context);
}