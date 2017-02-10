all: build push

build:
	docker-compose build

push:
	grep 'image: sebble/' docker-compose.yml|cut -d: -f2|xargs -Ix docker push x
