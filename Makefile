.PHONY: install uninstall start-mock-server start-ngrok start

install:
	npm install -g json-server@0.17.4

uninstall:
	npm uninstall -g json-server

start-mock-server:
	json-server --watch mock/db.json --routes mock/routes.json --port 8080

start-ngrok:
	ngrok http --url=convenient-judi-spectrochemical.ngrok-free.dev 8080

start:
	$(MAKE) install && $(MAKE) start-mock-server
