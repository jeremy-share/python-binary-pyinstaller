compile-deb:
	pyinstaller --onefile --noconfirm --distpath build/binaries --name pyinstaller_project_deb  pyinstaller_project/main.py

compile-alpine:
	pyinstaller --onefile --noconfirm --distpath build/binaries --name pyinstaller_project_alpine  pyinstaller_project/main.py

docker-compile:
	docker-compose run -u `id -u`:`id -g` app-deb make compile-deb
	docker-compose run -u `id -u`:`id -g` app-alpine make compile-alpine

cleanup:
	rm build/binaries/pyinstaller_project_* || true
	rm -rf build/pyinstaller_project_* || true
	rm *.spec || true

docker-run-deb:
	docker-compose -f docker-compose-test.yml up app-deb

docker-run-alpine:
	docker-compose -f docker-compose-test.yml up app-alpine

docker-run:
	docker-compose -f docker-compose-test.yml up
