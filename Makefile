# Define variables for build args
ALPINE_VERSION := 3.18.0
CONTAINERFILE=Containerfile

# User may specify the architecture to build else build for the host
ARCH ?= $(shell uname -m)
ifeq ($(filter $(ARCH), x86_64 arm64),)
    $(error Unsupported architecture: $(ARCH))
endif
ARCH := $(if $(filter $(ARCH), x86_64),amd64,arm64v8)

# Define the docker image name
IMAGE_NAME := $(ARCH)/krakatoa

.PHONY: build run

build:
	docker build \
		--build-arg ARCH=$(ARCH) \
		--build-arg ALPINE_VERSION=$(ALPINE_VERSION) \
		-t $(IMAGE_NAME) \
		-f $(CONTAINERFILE) \
		.

run:
	docker run -v$(PWD)/mount:/mount --rm -ti $(IMAGE_NAME) sh

clean:
	docker rmi $(IMAGE_NAME)
	docker rmi $(ARCH)/alpine:$(ALPINE_VERSION)
