module app;

import std.functional : toDelegate;

import vibe.vibe;

void main()
{
	auto router = new URLRouter;
	router.get("/", staticTemplate!"index.html");
	router.get("*", serveStaticFiles("public"));

	auto settings = new HTTPServerSettings;
	settings.port = 8080;
	settings.bindAddresses = ["::1", "127.0.0.1"];
	settings.errorPageHandler = toDelegate(&showError);

	listenHTTP(settings, router);

	logInfo("Please open http://127.0.0.1:8080/ in your browser.");
	runApplication();
}

void doRequest(HTTPServerRequest req, HTTPServerResponse res) {

	// Client requested with query string `?name=foo`
	req.renderTemple!(`
		Hello, world!
		And hello, <%= var.name %>!
	`)(res);
}

void showError(HTTPServerRequest req, HTTPServerResponse res, HTTPServerErrorInfo error)
{
	res.renderTemplate!("error.html", req, error);
}
