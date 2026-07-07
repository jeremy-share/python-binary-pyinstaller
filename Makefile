DOCKER_COMPOSE ?= docker compose
DIST_DIR := build/bin
ARTIFACT := $(DIST_DIR)/pyinstaller_project
RUNTIME_DIR := build/runtime
BUILD_DEB_COMPOSE := build_deb/docker-compose.yml
BUILD_ALPINE_COMPOSE := build_alpine/docker-compose.yml
RUN_DEB_COMPOSE := run_deb/docker-compose.yml
RUN_ALPINE_COMPOSE := run_alpine/docker-compose.yml
RUN_SCRATCH_COMPOSE := run_scratch/docker-compose.yml

.PHONY: build-deb build-alpine collect-runtime-libs docker-build-deb docker-build-alpine docker-build clean cleanup docker-run-deb docker-run-alpine docker-run-scratch docker-run

build-deb:
	$(MAKE) clean
	pyinstaller --noconfirm --clean --distpath $(DIST_DIR) --workpath build/pyinstaller_project build_deb/pyinstaller_project.spec
	$(MAKE) collect-runtime-libs

build-alpine:
	$(MAKE) clean
	pyinstaller --noconfirm --clean --distpath $(DIST_DIR) --workpath build/pyinstaller_project build_alpine/pyinstaller_project.spec
	$(MAKE) collect-runtime-libs

collect-runtime-libs:
	rm -rf $(RUNTIME_DIR)
	mkdir -p $(RUNTIME_DIR)/app $(RUNTIME_DIR)/tmp
	chmod 1777 $(RUNTIME_DIR)/tmp
	cp $(ARTIFACT) $(RUNTIME_DIR)/app/pyinstaller_project
	{ \
		ldd $(ARTIFACT); \
		if [ -f /usr/local/lib/libpython3.11.so.1.0 ]; then ldd /usr/local/lib/libpython3.11.so.1.0; fi; \
	} | awk '/=> \// { print $$3 } /^[[:space:]]*\// { print $$1 }' \
		| sort -u \
		| while read -r lib; do \
			mkdir -p "$(RUNTIME_DIR)$$(dirname "$$lib")"; \
			cp "$$lib" "$(RUNTIME_DIR)$$lib"; \
		done

docker-build-deb:
	$(DOCKER_COMPOSE) -f $(BUILD_DEB_COMPOSE) run --rm -u `id -u`:`id -g` app make build-deb

docker-build-alpine:
	$(DOCKER_COMPOSE) -f $(BUILD_ALPINE_COMPOSE) run --rm -u `id -u`:`id -g` app make build-alpine

docker-build:
	@echo "Build a single target: make docker-build-deb or make docker-build-alpine"

clean:
	rm -rf $(DIST_DIR) || true
	rm -rf $(RUNTIME_DIR) || true
	rm -rf build/binaries || true
	rm -rf build/pyinstaller_project build/pyinstaller_project_* || true

cleanup: clean

docker-run-deb:
	$(DOCKER_COMPOSE) -f $(RUN_DEB_COMPOSE) run --rm --build app

docker-run-alpine:
	$(DOCKER_COMPOSE) -f $(RUN_ALPINE_COMPOSE) run --rm --build app

docker-run-scratch:
	$(DOCKER_COMPOSE) -f $(RUN_SCRATCH_COMPOSE) run --rm --build app

docker-run:
	@echo "Run a single target: make docker-run-deb, make docker-run-alpine, or make docker-run-scratch"
