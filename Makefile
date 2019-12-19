
USERNAME:=glenux
IMAGE:=$(shell basename "$$(pwd)")
TAG:=$(shell TZ=UTC date +"%Y%m%d_%H%M")

all: build run

build:
	docker build -t $(IMAGE):$(TAG) .
	docker tag $(IMAGE):$(TAG) $(IMAGE):latest

run:
	docker stop $(IMAGE) || true
	docker run --rm \
		--name $(IMAGE) \
		-p 80:80 \
		-t $(IMAGE):$(TAG)



