# Python Binary Pyinstaller

This is a quick POC using [Pyinstaller](https://pyinstaller.org/en/stable/) to create binary files that can be run on a 
system without dependencies.

See: [LICENSE](LICENSE) file for additional details

## Key points
* Binaries are output to `build/binaries`.
* [Makefile](Makefile) contains useful commands
* [docker-compose.yml](docker-compose.yml) is used for building binaries
* [docker-compose-test.yml](docker-compose-test.yml) is used for testing/running (direct images without dependencies)

## Running

```shell
make docker-compile
make docker-run
```
