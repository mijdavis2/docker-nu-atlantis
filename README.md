<!-- <p align="center">
  <a href="" rel="noopener">
 <img width=200px height=200px src="https://i.imgur.com/6wj0hh6.jpg" alt="Project logo"></a>
</p> -->

<h3 align="center">Atlantis Mountain</h3>

<!-- <div align="center">

  [![Status](https://img.shields.io/badge/status-active-success.svg)]()
  [![GitHub Issues](https://img.shields.io/github/issues/###/template-standard.svg)](https://github.com/###/template-standard/issues)
  [![GitHub Pull Requests](https://img.shields.io/github/issues-pr/###/template-standard.svg)](https://github.com/###/template-standard/pulls)
  [![License](https://img.shields.io/badge/license-GNU3.0-blue.svg)](/LICENSE)

</div> -->

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
- **[atlantis-mountain]** custom atlantis image with bash wrappers for everything above and some enhancements:
  - sets opinionated atlantis config defaults so you don't need atlantis config in your tf repo.
  - removes the notoriously verbose terragrunt output from the plan.
  - ensures proper exit code for atlantis to update GitHub build status.

# Getting Started

## Requirements

- Infra to run `atlantis-mountain` container
- Git host like GitHub that supports PR webhooks that has http access to your deployed `atlantis-mountain` container.

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
[atlantis-mountain]: ./README.md
