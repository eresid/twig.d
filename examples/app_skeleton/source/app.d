module app;

import std.functional : toDelegate;

import index;
import vibe.vibe;

void main()
{
	auto router = new URLRouter;
	router.get("/", &showHome);
	router.get("/about", staticTemplate!"about.dt");
	router.get("*", serveStaticFiles("public"));

	auto settings = new HTTPServerSettings;
	settings.port = 8080;
	settings.bindAddresses = ["::1", "127.0.0.1"];
	settings.errorPageHandler = toDelegate(&showError);

	listenHTTP(settings, router);

	logInfo("Please open http://127.0.0.1:8080/ in your browser.");
	runApplication();
}

void showError(HTTPServerRequest req, HTTPServerResponse res, HTTPServerErrorInfo error)
{
	res.render!("error.dt", req, error);
}
