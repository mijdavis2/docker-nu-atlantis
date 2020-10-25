IMAGE_NAME = atlantis-found
GIT_TAG = $(shell git describe --tags HEAD)
TAG ?= $(GIT_TAG)
REGISTRY = 'ghcr.io/taosmountain/atlantis-found'
DOCKER_REGISTRY ?= $(REGISTRY)
IMAGE_ID = $(DOCKER_REGISTRY)/$(IMAGE_NAME)

########
# Docker
build:
	docker build -t $(IMAGE_ID):$(TAG) ./

publish: build
	docker push $(IMAGE_ID):$(TAG)
	docker tag $(IMAGE_ID):$(TAG) $(IMAGE_ID):tf13-$(TAG)
	docker push $(IMAGE_ID):tf13-$(TAG)

# For Terraform 0.12
build-tf12:
	docker build -t $(IMAGE_NAME):tf12-$(TAG) \
		--build-arg TERRAFORM_VERSION=0.12.29 \
		--build-arg TERRAGRUNT_VERSION=v0.24.4 \
		./

publish-tf12: build-tf12
	docker push $(IMAGE_ID):tf12-$(TAG)

#########
# Testing
test-terraform:
	docker run --rm --name atlantis-test-tf --entrypoint /bin/bash $(IMAGE_ID):$(TAG) -l -c "terraform --version"

test-terragrunt:
	docker run --rm --name atlantis-test-tg --entrypoint /bin/bash $(IMAGE_ID):$(TAG) -l -c "terragrunt --version"

test-tfmask:
	docker run --rm --name atlantis-test-tfmask --entrypoint /bin/bash $(IMAGE_ID):$(TAG) -l -c "type tfmask"

test: build test-terraform test-terragrunt test-tfmask

###############
# Documentation
update-changelog:
	auto-changelog

update-toc:
	doctoc --maxlevel 2 ./README.md

update: update-changelog update-toc
