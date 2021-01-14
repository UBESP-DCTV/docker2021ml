module := m2
version := v1.1
name := mlt_dg

all: update

update: build restart push

restart: stop run

# https://stackoverflow.com/questions/34228864/stop-and-delete-docker-container-if-its-running
stop:
	docker stop $(name) || true

run:
	docker run -d --rm --name $(name) -v ${PWD}/homework_persistent:/home/rstudio/homework_persistent -e PASSWORD=docker2021ml -p 18702:8787 docker2021ml:$(module)-$(version)

build:
	docker build -t docker2021ml:$(module)-$(version) .

push:
	docker tag docker2021ml:$(module)-$(version) corradolanera/docker2021ml:$(module)-$(version)
	docker tag docker2021ml:$(module)-$(version) corradolanera/docker2021ml:$(module)-latest
	docker tag docker2021ml:$(module)-$(version) corradolanera/docker2021ml:latest
	docker push -a corradolanera/docker2021ml
