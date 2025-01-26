# Define variables for build args
ALPINE_VERSION := 3.21.2
CONTAINERFILE=Containerfile

# User may specify the architecture to build else build for the host
ARCH ?= $(shell uname -m)
ifeq ($(filter $(ARCH), x86_64 arm64),)
    $(error Unsupported architecture: $(ARCH))
endif
ARCH := $(if $(filter $(ARCH), x86_64),amd64,arm64v8)

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

.PHONY: start
start:
	docker run --rm -v$(PWD)/volumes:/volumes -td $(IMAGE_NAME)

.PHONY: stop
stop:
	docker stop $(shell docker ps --filter "ancestor=$(IMAGE_NAME)" --format "{{.ID}}")

.PHONY: attach
attach:
	docker exec -ti $(shell docker ps --filter "ancestor=$(IMAGE_NAME)" --format "{{.ID}}" | head -n1) sh

.PHONY: run
run:
	docker run -v$(PWD)/volumes:/volumes --rm -ti $(IMAGE_NAME) sh

.PHONY: clean
clean:
	docker rmi $(IMAGE_NAME)
	docker rmi $(ARCH)/alpine:$(ALPINE_VERSION)
