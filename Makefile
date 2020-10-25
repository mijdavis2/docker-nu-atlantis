GIT_TAG = atlantis:$(shell git describe --tags HEAD)
TAG ?= $(GIT_TAG)
# TODO: Add registry
REGISTRY = '___'

# Docker
build:
	docker build -t $(TAG) .

publish: build
	docker tag $(TAG) $(REGISTRY)/$(TAG)
	docker push $(REGISTRY)/$(TAG)

# Testing
test-terraform:
	docker run --rm --name atlantis-test-tf --entrypoint /bin/bash $(TAG) -l -c "terraform --version"

test-terragrunt:
	docker run --rm --name atlantis-test-tg --entrypoint /bin/bash $(TAG) -l -c "terragrunt --version"

test-tfmask:
	docker run --rm --name atlantis-test-tfmask --entrypoint /bin/bash $(TAG) -l -c "type tfmask"

test: build test-terraform test-terragrunt test-tfmask

# Documentation
update-changelog:
	auto-changelog

update-toc:
	doctoc --notitle --maxlevel 2 ./

update: update-changelog update-toc
