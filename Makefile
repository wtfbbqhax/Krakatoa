# Define variables for build args
ALPINE_VERSION := 3.17.3
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
	docker run --rm -ti $(IMAGE_NAME) sh
