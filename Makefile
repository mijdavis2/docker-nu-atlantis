GIT_TAG = atlantis:$(shell git describe --tags HEAD)
TAG ?= $(GIT_TAG)
# TODO: Add registry
REGISTRY = '___'

build:
	docker build -t $(TAG) .

publish: build
	docker tag $(TAG) $(REGISTRY)/$(TAG)
	docker push $(REGISTRY)/$(TAG)

test-terraform:
	docker run --rm --name atlantis-test-tf --entrypoint /bin/bash $(TAG) -l -c "terraform --version"

test-terragrunt:
	docker run --rm --name atlantis-test-tg --entrypoint /bin/bash $(TAG) -l -c "terragrunt --version"

test-all: build test-terraform test-terragrunt
