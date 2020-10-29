<p align="center">
  <a href="https://www.taos.com/">
    <img width=100px height=100px src="https://miro.medium.com/fit/c/262/262/0*okNzl1Zgc5ufyVwS.jpg" alt="Taos logo">
  </a>
</p>

<h1>atlantis-found</h1>

<p>

  <a href="https://github.com/taosmountain/docker-atlantis-found/releases" alt="Release">
    <img src="https://img.shields.io/github/v/release/taosmountain/docker-atlantis-found?sort=semver" /></a>
  <a href="https://github.com/orgs/taosmountain/packages/container/package/atlantis-found" alt="Docker images">
    <img src="https://img.shields.io/badge/docker-ghcr-blue" /></a>
  <a href="https://github.com/taosmountain/docker-atlantis-found/actions?query=workflow%3Adocker-publish" alt="Docker release workflow">
    <img src="https://img.shields.io/github/workflow/status/taosmountain/docker-atlantis-found/Docker" /></a>
  <a href="https://github.com/taosmountain/docker-atlantis-found/issues" alt="Issues">
    <img src="https://img.shields.io/github/issues/taosmountain/docker-atlantis-found" /></a>
  <a href="https://github.com/taosmountain/docker-atlantis-found/pulls" alt="Pull requests">
    <img src="https://img.shields.io/github/issues-pr/taosmountain/docker-atlantis-found" /></a>
  <a href="https://github.com/taosmountain/docker-atlantis-found/blob/master/LICENSE" alt="License">
    <img src="https://img.shields.io/github/license/taosmountain/docker-atlantis-found" /></a>

</p>

<p> Combines the benefits of atlantis, terragrunt, and tfmask in an opinionated terraform ci/cd docker image with refreshingly clean output and proper GitHub status updates.
    <br>
</p>

---

<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
 **Table of Contents**  *generated with [DocToc](https://github.com/thlorenz/doctoc)*

- [About](#about)
- [Usage](#usage)
- [Compatibility](#compatibility)
- [Contributing](#contributing)
- [Special Thanks](#special-thanks)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

## About

Terraform is an excellent tool for deploying infrastructure-as-code.
However, keeping terraform DRY, automating deployment through gitflow and ci tools,
and doing it all without leaking secrets takes a bit of extra tooling.
With [our docker image](https://github.com/orgs/taosmountain/packages/container/package/atlantis-found) and by adopting [terragrunt],
you get all of the above with minimal overhead. Also see [why use terragrunt].

### The tool stack

- **[terragrunt]** is a terraform wrapper that helps keep code DRY, maintainable, and safe to automate. See [why use terragrunt].
- **[atlantis]** is a terraform ci/cd tool that makes automating terraform via good git practices easy. No need for jenkins and you can deploy it anywhere.
- **[tfmask]** keeps ci/cd of terraform secure by filtering passwords and secrets in terraform output from plans and applies.
- **[atlantis-found]** custom atlantis image with bash wrappers for everything above and some enhancements:
  - sets opinionated atlantis config defaults so you don't need atlantis config in your tf repo.
  - removes the notoriously verbose terragrunt output from the plan.
  - ensures proper exit code for atlantis to update GitHub build status.


## Usage

Follow instructions for [atlantis] but use this image.

See [our GitHub Container Registry](https://github.com/orgs/taosmountain/packages/container/package/atlantis-found) for available image tags.



## Compatibility

While atlantis supports any terraform version at runtime,
this image uses explicit terraform and terragrunt versions
to ensure compatibility.

#### Terraform 0.13

See releases for latest version. May also use `latest`. Examples:

```
docker pull ghcr.io/taosmountain/atlantis-found:latest
docker pull ghcr.io/taosmountain/atlantis-found:1.0.0
docker pull ghcr.io/taosmountain/atlantis-found:tf13-1.0.0
```

#### Terraform 0.12

Use `tf12-*` tag prefix. Example:

```
docker pull ghcr.io/taosmountain/atlantis-found:tf12-1.0.0
```


## Contributing

Please follow our [contributing guidelines].

Use `make update` to update the CHANGELOG and README when appropriate.

### Requirements

- docker
- make (for build/test/publish shortcuts)

### Building

Running `make build` will build the docker image and use git tag information to tag the image.

### Testing

There are simple `make` tasks that ensure certain tools are properly installed
on in the image. More testing is welcome. See [Makefile](./Makefile) for all testing tasks.

```
make test-all
```

### Publishing

Github Actions take care of docker image publish on GitHub release events.

To manually publish, run `make publish` to build and publish an image based on HEAD git tag.
If forking this repo, you'll want to customize the `Makefile` to deploy to your registry.


## Special Thanks

- [hoppalotta] for research and testing

<!-- TODO: once open-source, add sourcerer hall of fame https://sourcerer.io/settings#hof -->

*This project stands on the shoulders of giants. Thanks to:*

- [hashicorp] for terraform
- [gruntwork] for terragrunt
- [runatlantis team] for atlantis
- [cloudposse] for tfmask
- [thlorenz] for doctoc


[contributing guidelines]: ./.github/CONTRIBUTING.md
[terragrunt]: https://terragrunt.gruntwork.io/
[why use terragrunt]: https://transcend.io/blog/why-we-use-terragrunt
[atlantis]: https://www.runatlantis.io/
[tfmask]: https://github.com/cloudposse/tfmask
[atlantis-found]: ./README.md
[hashicorp]: https://www.hashicorp.com/
[gruntwork]: https://gruntwork.io/
[runatlantis team]: https://github.com/runatlantis
[cloudposse]: https://github.com/cloudposse/tfmask
[thlorenz]: https://github.com/thlorenz/doctoc
[hoppalotta]: https://github.com/hoppalotta
