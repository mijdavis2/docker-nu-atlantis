IMAGE_NAME = nu-atlantis
GIT_TAG = $(shell git describe --tags HEAD)
TAG ?= $(GIT_TAG)
REGISTRY = ghcr.io/taosmountain
DOCKER_REGISTRY ?= $(REGISTRY)
IMAGE_ID = $(DOCKER_REGISTRY)/$(IMAGE_NAME)

########
# Docker
pull:
	docker pull $(IMAGE_ID):latest
	docker tag $(IMAGE_ID):latest $(IMAGE_NAME)

build: pull
	docker build -f ./full/Dockerfile -t $(IMAGE_ID):$(TAG) ./full/
	docker tag $(IMAGE_ID):$(TAG) $(IMAGE_NAME)

publish: build
	docker tag $(IMAGE_ID):$(TAG) $(IMAGE_ID):tf13-$(TAG)
	docker push $(IMAGE_ID):tf13-$(TAG)
	docker push $(IMAGE_ID):$(TAG)
	docker tag $(IMAGE_ID):$(TAG) $(IMAGE_ID):latest
	docker push $(IMAGE_ID):latest

build-base:
	docker build -f ./base/Dockerfile -t $(IMAGE_ID):base-$(TAG) ./base/

publish-base: build-base
	docker tag $(IMAGE_ID):base-$(TAG) $(IMAGE_ID):tf13-base-$(TAG)
	docker push $(IMAGE_ID):tf13-base-$(TAG)
	docker push $(IMAGE_ID):base-$(TAG)

# For Terraform 0.12
build-tf12:
	docker build -f ./full/Dockerfile -t $(IMAGE_ID):tf12-$(TAG) \
		--build-arg TERRAFORM_VERSION=0.12.29 \
		--build-arg TERRAGRUNT_VERSION=0.24.4 \
		./full/

publish-tf12: build-tf12
	docker push $(IMAGE_ID):tf12-$(TAG)

build-tf12-base:
	docker build -f ./full/Dockerfile -t $(IMAGE_ID):tf12-base-$(TAG) \
		--build-arg TERRAFORM_VERSION=0.12.29 \
		--build-arg TERRAGRUNT_VERSION=0.24.4 \
		./base/

publish-tf12-base: build-tf12-base
	docker push $(IMAGE_ID):tf12-base-$(TAG)

#########
# Testing
test-terraform:
	docker run -u atlantis --rm --name atlantis-test-tf --entrypoint /bin/bash $(IMAGE_ID):$(TAG) -c "terraform --version"

test-terragrunt:
	docker run -u atlantis --rm --name atlantis-test-tg --entrypoint /bin/bash $(IMAGE_ID):$(TAG) -c "terragrunt --version"

test-tfenv:
	docker run -u atlantis --rm --name atlantis-test-tf --entrypoint /bin/bash $(IMAGE_ID):$(TAG) -c "tfenv list"

test-tgenv:
	docker run -u atlantis --rm --name atlantis-test-tg --entrypoint /bin/bash $(IMAGE_ID):$(TAG) -c "tgenv list"

test-tfenv-install:
	docker run -u atlantis --rm --name atlantis-test-tf --entrypoint /bin/bash $(IMAGE_ID):$(TAG) -c "tfenv install 0.14.1"

test-tgenv-install:
	docker run -u atlantis --rm --name atlantis-test-tg --entrypoint /bin/bash $(IMAGE_ID):$(TAG) -c "tgenv install 0.26.6"

test-tfmask:
	docker run -u atlantis --rm --name atlantis-test-tfmask --entrypoint /bin/bash $(IMAGE_ID):$(TAG) -c "type tfmask"

test-credstash:
	docker run -u atlantis --rm --name atlantis-test-credstash --entrypoint /bin/bash $(IMAGE_ID):$(TAG) -c "type credstash"

test: build test-terraform test-terragrunt test-tfenv test-tgenv test-tfenv-install test-tgenv-install test-tfmask test-credstash

# Base image testing
test-terraform-base:
	docker run -u atlantis --rm --name atlantis-test-tf --entrypoint /bin/bash $(IMAGE_ID):base-$(TAG) -c "terraform --version"

test-terragrunt-base:
	docker run -u atlantis --rm --name atlantis-test-tg --entrypoint /bin/bash $(IMAGE_ID):base-$(TAG) -c "terragrunt --version"

test-tfenv-base:
	docker run -u atlantis --rm --name atlantis-test-tf --entrypoint /bin/bash $(IMAGE_ID):base-$(TAG) -c "tfenv list"

test-tgenv-base:
	docker run -u atlantis --rm --name atlantis-test-tg --entrypoint /bin/bash $(IMAGE_ID):base-$(TAG) -c "tgenv list"

test-tfenv-base-install:
	docker run -u atlantis --rm --name atlantis-test-tf --entrypoint /bin/bash $(IMAGE_ID):base-$(TAG) -c "tfenv install 0.14.1"

test-tgenv-base-install:
	docker run -u atlantis --rm --name atlantis-test-tg --entrypoint /bin/bash $(IMAGE_ID):base-$(TAG) -c "tgenv install 0.26.6"

test-tfmask-base:
	docker run -u atlantis --rm --name atlantis-test-tfmask --entrypoint /bin/bash $(IMAGE_ID):base-$(TAG) -c "type tfmask"

test-base: build-base test-terraform-base test-terragrunt-base test-tfenv-base test-tgenv-base test-tfenv-base-install test-tgenv-base-install test-tfmask-base

test-all: test-base test

###############
# Documentation
update-changelog:
	auto-changelog

update-toc:
	doctoc --maxlevel 2 ./README.md

update: update-changelog update-toc
