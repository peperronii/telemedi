package telemedi_server

import http "./odin-http"
import "core:fmt"
import "core:io"
import "core:log"
import "core:net"

main_page :: #load(`./main.html`, string)
main :: proc() {
	context.logger = log.create_console_logger(.Info)
	s: http.Server
	// register a graceful shutdown when the program recives a SIGINT signal
	http.server_shutdown_on_interrupt(&s)
	router: http.Router
	http.router_init(&router)
	defer http.router_destroy(&router)

	http.route_get(&router, "/", http.handler(proc(req: ^http.Request, res: ^http.Response) {
			http.respond_file(res, "./index.html")
		}))
	http.route_get(
		&router,
		"/telemedi_style.css",
		http.handler(proc(req: ^http.Request, res: ^http.Response) {
				http.respond_file(res, "./telemedi_style.css")
			}),
	)
	http.route_get(
		&router,
		"/components.css",
		http.handler(proc(req: ^http.Request, res: ^http.Response) {
				http.respond_file(res, "./components.css")
			}),
	)
	http.route_get(&router, "/main", http.handler(proc(req: ^http.Request, res: ^http.Response) {
			http.respond_html(res, main_page)
			log.info("main page sent")
		}))
	http.route_get(&router, "/call", http.handler(proc(req: ^http.Request, res: ^http.Response) {
			http.respond_file(res, "./call.html")
		}))
	http.route_get(
		&router,
		"/avatar.png",
		http.handler(proc(req: ^http.Request, res: ^http.Response) {
				http.respond_file(res, "./avatar.png")
			}),
	)
	http.route_get(&router, "(.*)", http.handler(proc(req: ^http.Request, res: ^http.Response) {
			log.info(req^)
		}))
	routed := http.router_handler(&router)
	log.info("Listening on http://localhost:6969")
	err := http.listen_and_serve(&s, routed, net.Endpoint{address = net.IP4_Loopback, port = 6969})
	fmt.assertf(err == nil, "server stopped with error: %v", err)
}
