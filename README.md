<p align="center">
  <a href="https://www.taos.com/">
    <img width=100px height=100px src="https://miro.medium.com/fit/c/262/262/0*okNzl1Zgc5ufyVwS.jpg" alt="Taos logo">
  </a>
</p>

<h3 align="center">atlantis-found</h3>

<p align="center">

  <a href="https://github.com/taosmountain/docker-atlantis-found/releases" alt="Release">
    <img src="https://img.shields.io/github/v/release/taosmountain/docker-atlantis-found?sort=semver" /></a>
  <a href="https://github.com/orgs/taosmountain/packages/container/package/atlantis-found" alt="Docker images">
    <img src="https://img.shields.io/badge/docker-ghcr-blue" /></a>
  <a href="https://github.com/taosmountain/docker-atlantis-found/actions?query=workflow%3ADocker" alt="Docker release workflow">
    <img src="https://img.shields.io/github/workflow/status/taosmountain/docker-atlantis-found/Docker" /></a>
  <a href="https://github.com/taosmountain/docker-atlantis-found/issues" alt="Issues">
    <img src="https://img.shields.io/github/issues/taosmountain/docker-atlantis-found" /></a>
  <a href="https://github.com/taosmountain/docker-atlantis-found/pulls" alt="Pull requests">
    <img src="https://img.shields.io/github/issues-pr/taosmountain/docker-atlantis-found" /></a>
  <a href="https://github.com/taosmountain/docker-atlantis-found/master/" alt="License">
    <img src="https://img.shields.io/badge/license-GNU3.0-blue" /></a>

</p>

---

<p align="center"> Combines the benefits of atlantis, terragrunt, and tfmask in an opinionated terraform ci/cd docker image with refreshingly clean output and proper GitHub status updates.
    <br>
</p>

<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**  *generated with [DocToc](https://github.com/thlorenz/doctoc)*

- [About](#about)
  - [The tool stack](#the-tool-stack)
- [Getting Started](#getting-started)
  - [Requirements](#requirements)
  - [Usage](#usage)
- [Compatibility](#compatibility)
- [Contributing](#contributing)
  - [Developing](#developing)
    - [Requirements](#requirements-1)
  - [Building](#building)
  - [Testing](#testing)
  - [Publishing](#publishing)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

# About

While terraform is an excellent tool for infrastructure-as-code,
keeping terraform DRY, automating deployment through gitflow and ci tools,
and doing it all without leaking secrets takes a bit of extra tooling.
With this docker image and adopting [terragrunt], you get all of the above. Also see [why use terragrunt].

## The tool stack

- **[terragrunt]** is a terraform wrapper that helps keep code DRY, maintainable, and safe to automate. See [why use terragrunt].
- **[atlantis]** is a terraform ci/cd tool that makes automating terraform via good git practices easy. No need for jenkins and you can deploy it anywhere.
- **[tfmask]** keeps ci/cd of terraform secure by filtering passwords and secrets in terraform output from plans and applies.
- **[atlantis-found]** custom atlantis image with bash wrappers for everything above and some enhancements:
  - sets opinionated atlantis config defaults so you don't need atlantis config in your tf repo.
  - removes the notoriously verbose terragrunt output from the plan.
  - ensures proper exit code for atlantis to update GitHub build status.

# Getting Started

## Requirements

- Infra to run `atlantis-found` container
- Git host like GitHub that supports PR webhooks that has http access to your deployed `atlantis-found` container.

## Usage

Follow instructions for [atlantis] but use this image. See [packages] in this repo for available image tags.

<!-- TODO: add latest stable package or example here -->

# Compatibility

While atlantis supports any terraform version at runtime,
this image uses explicit terraform and terragrunt versions
to ensure the wrappers that provide secure and terse output are compatible.

<!-- TODO: list supported tf and tg versions or link to them -->

# Contributing

Please follow our [contributing guidelines].

## Developing

### Requirements

- docker
- make (for build/test/deploy shortcuts)

## Building

Running `make build` will build the docker image and use git tag information to tag the image.

## Testing

There are simple make tasks that ensure terraform and terragrunt are properly installed
on in the image. More testing is welcome.

```
# See Makefile for all tasks. This will build and run all current tests:

make test-all
```

## Publishing

Run `make publish` to build and publish an image based on git tag.
If forking this repo, you'll want to customize the `Makefile` to deploy to your registry.


[contributing guidelines]: ./.github/CONTRIBUTING.md
[terragrunt]: https://terragrunt.gruntwork.io/
[why use terragrunt]: https://transcend.io/blog/why-we-use-terragrunt
[atlantis]: https://www.runatlantis.io/
[tfmask]: https://github.com/cloudposse/tfmask
[packages]: https://github.com/###
[atlantis-found]: ./README.md
