# Python Binary Pyinstaller

This is a quick POC using [PyInstaller](https://pyinstaller.org/en/stable/) to create binary files that can run on a
system without Python installed.

The important detail is that a PyInstaller binary is still linked to the target platform C runtime and shared libraries.
The Debian/Ubuntu build targets glibc. The Alpine build targets musl. A scratch image has no libraries at all, so the
runtime libraries reported by `ldd` must be copied into the image with the binary.

See: [LICENSE](LICENSE) file for additional details

## Layout

* `project/` contains the Python package and Python requirements.
* `build_deb/` contains the Debian/Ubuntu PyInstaller builder image, spec, and Compose file.
* `build_alpine/` contains the Alpine PyInstaller builder image, spec, and Compose file.
* `run_deb/` runs the current PyInstaller binary on a Debian base image without installing Python.
* `run_alpine/` runs the current PyInstaller binary on an Alpine base image without installing Python.
* `run_scratch/` runs the current PyInstaller binary from scratch using the copied runtime libraries in `build/runtime/`.
* `build/` contains generated PyInstaller work files and built artifacts.

## Key points

* The current binary is output to `build/bin/pyinstaller_project`.
* Runtime files for scratch are output to `build/runtime/`.
* The last build wins. Building on Debian then Alpine overwrites the same output artifact.
* Each build target cleans generated `build/` outputs before building.
* `run_deb/` and `run_alpine/` print their libc/runtime details and check `ldd` output before starting the app so mismatches are visible.
* [Makefile](Makefile) contains useful commands
* Each `build_*` and `run_*` folder owns the Compose file for that specific scenario.

## Build

```shell
make docker-build-deb
# or
make docker-build-alpine
```

Both commands create the same artifact path:

* `build/bin/pyinstaller_project`
* `build/runtime/`

## Run

```shell
make docker-run-deb
make docker-run-alpine
make docker-run-scratch
```

The Debian image expects a glibc-linked binary. The Alpine image expects a musl-linked binary. If you build on Alpine and
run on Debian, or build on Debian and run on Alpine, the binary should fail before the Python app starts because the
dynamic loader and C runtime do not match.

The app is a scheduler, so it keeps running until stopped with Ctrl+C.
