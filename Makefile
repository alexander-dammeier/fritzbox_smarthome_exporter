# import .env if it exists
ifneq (,$(wildcard ./.env))
    include .env
    export
endif

VERSION := 0.5.0
REGISTRY ?= docker.io
PROJECT ?= jaymedh
IMAGE_NAME := $(REGISTRY)/$(PROJECT)/fritzbox_smarthome_exporter

# Build parameters
# TARGETOS: linux, darwin, windows
TARGETOS ?= linux
# TARGETARCH: amd64 (64-bit Intel/AMD), arm64 (Apple Silicon/64-bit ARM), arm (Raspberry Pi 32-bit)
TARGETARCH ?= amd64

.PHONY: build
build:
	@echo "Building Docker image $(IMAGE_NAME):$(VERSION) for $(TARGETOS)/$(TARGETARCH)..."
	docker build --build-arg TARGETOS=$(TARGETOS) --build-arg TARGETARCH=$(TARGETARCH) -t $(IMAGE_NAME):$(VERSION) .
	docker tag $(IMAGE_NAME):$(VERSION) $(IMAGE_NAME):latest

.PHONY: push
push: build
	@echo "Pushing Docker image to $(REGISTRY)..."
	docker push $(IMAGE_NAME):$(VERSION)
	docker push $(IMAGE_NAME):latest

.PHONY: test
test:
	@echo "Running local tests..."
	go test ./...

.PHONY: test-docker
test-docker:
	@echo "Running tests in Docker..."
	docker run --rm -v $(PWD):/app -w /app golang:1.26-alpine go test ./...
