
ROOT		:= $(abspath $(dir $(lastword $(MAKEFILE_LIST))))
BUILDER		:= local/builder

PACKAGE		:= github.com/AcalephStorage/consul-alerts
BINARY		:= consul-alerts
IMAGE		:= alectolytic/$(BINARY)
REPOSITORY	:= docker.io/$(IMAGE)
VERSION		:= 0.3.3

BUILD_OPTS	:=

ifdef NOCACHE
	BUILD_OPTS	:= $(BUILD_OPTS) --no-cache
endif

.PHONY: all build clean tag tag/$(VERSION) push push/$(VERSION)

all: build

build:
	@docker build \
		--build-arg PACKAGE=$(PACKAGE) \
		--build-arg IMAGE=$(IMAGE) \
		--build-arg VERSION=$(VERSION) \
		--build-arg BINARY=$(BINARY) \
		$(BUILD_OPTS) -t $(BUILDER) $(ROOT)
	@docker run \
		--privileged \
		-v /var/run/docker.sock:/var/run/docker.sock \
		-v $(shell which docker):$(shell which docker) \
		-it $(BUILDER)

tag/$(VERSION):
	@docker tag -f $(IMAGE):latest $(REPOSITORY):$(VERSION)

tag: tag/$(VERSION)
	@docker tag -f $(REPOSITORY):$(VERSION) $(REPOSITORY):latest

push/$(VERSION): tag
	@docker push $(REPOSITORY):$(VERSION)

push: | push/$(VERSION)
	@docker push $(REPOSITORY):latest

bumpversion:
	@sed -ie s/'^\(VERSION\s*:=\s\).*$$'/'\1$(VERSION)'/ $(ROOT)/Makefile
	@git add $(ROOT)/Makefile
	@git commit -m "Update to $(VERSION)"
	@git diff HEAD^

clean:
	@docker rmi -f $(BUILDER)
