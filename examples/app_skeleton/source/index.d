module index;

import vibe.http.server;
import vibe.templ.diet;

void showHome(HTTPServerRequest req, HTTPServerResponse res)
{
	string username = "Tester Test";
	res.render!("home.dt", req, username);
}
