FROM alpine:3.18

COPY build/bin/pyinstaller_project /usr/local/bin/pyinstaller_project
COPY run_alpine/entrypoint.sh /usr/local/bin/run-pyinstaller-project

ENTRYPOINT ["/usr/local/bin/run-pyinstaller-project"]
