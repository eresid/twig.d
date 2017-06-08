module app;

import std.functional : toDelegate;

import vibe.vibe;
import twigd;

shared static this() {
	auto router = new URLRouter;
	router.get("/", &showHome);
	router.get("*", serveStaticFiles("public"));

	auto settings = new HTTPServerSettings;
	settings.port = 8080;
	settings.bindAddresses = ["::1", "127.0.0.1"];
	settings.errorPageHandler = toDelegate(&showError);

	listenHTTP(settings, router);

	logInfo("Please open http://127.0.0.1:8080/ in your browser.");
}

void showHome(HTTPServerRequest req, HTTPServerResponse res) {
    Data data = Data();
    data.title = "The Venus Project";
    data.username = "Eugene";

	//res.renderTwig!("index.html", req, data);
}

void testGet(HTTPServerRequest req, HTTPServerResponse res) {
	// Client requested with query string `?name=foo`
	/+req.renderTemple!(`
		Hello, world!
		And hello, {{ name }}!
	`)(res);+/
}

void showError(HTTPServerRequest req, HTTPServerResponse res, HTTPServerErrorInfo error) {
	//res.renderTwig!("error.html", req, error);
}
