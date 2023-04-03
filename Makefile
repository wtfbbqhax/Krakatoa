# Define variables for build args
ARCH := $(or $(ARCH),amd64)
ALPINE_VERSION := 3.17.3
CONTAINERFILE=Containerfile

# Define the docker image name
IMAGE_NAME := $(ARCH)/krakatoa

.PHONY: build

build:
	docker build \
		--build-arg ARCH=$(ARCH) \
		--build-arg ALPINE_VERSION=$(ALPINE_VERSION) \
		-t $(IMAGE_NAME) \
		-f $(CONTAINERFILE) \
		.

run:
	docker run --rm -ti $(IMAGE_NAME) sh
