IMAGE_NAME = atlantis-found
GIT_TAG = $(shell git describe --tags HEAD)
# Use TAG to override GIT_TAG
TAG ?= $(GIT_TAG)
IMAGE_ID = $(IMAGE_NAME):$(TAG)
REGISTRY = 'ghcr.io/taosmountain/atlantis-found'

########
# Docker
build:
	docker build -t $(IMAGE_ID) ./

# Build for Terraform 0.12
build-12:
	docker build -t $(IMAGE_NAME):tf12-$(TAG) \
		--build-arg TERRAFORM_VERSION=0.12.29 \
		--build-arg TERRAGRUNT_VERSION=v0.24.4 \
		./

publish: build
	docker tag $(IMAGE_ID) $(REGISTRY):$(IMAGE_ID)
	docker push $(REGISTRY):$(IMAGE_ID)

#########
# Testing
test-terraform:
	docker run --rm --name atlantis-test-tf --entrypoint /bin/bash $(IMAGE_ID) -l -c "terraform --version"

test-terragrunt:
	docker run --rm --name atlantis-test-tg --entrypoint /bin/bash $(IMAGE_ID) -l -c "terragrunt --version"

test-tfmask:
	docker run --rm --name atlantis-test-tfmask --entrypoint /bin/bash $(IMAGE_ID) -l -c "type tfmask"

test: build test-terraform test-terragrunt test-tfmask

###############
# Documentation
update-changelog:
	auto-changelog

update-toc:
	doctoc --maxlevel 2 ./README.md

update: update-changelog update-toc
