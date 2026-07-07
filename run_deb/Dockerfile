FROM debian:bookworm-slim

COPY build/bin/pyinstaller_project /usr/local/bin/pyinstaller_project
COPY run_deb/entrypoint.sh /usr/local/bin/run-pyinstaller-project

ENTRYPOINT ["/usr/local/bin/run-pyinstaller-project"]
