![build](https://img.shields.io/github/actions/workflow/status/linhng98/mess-around/build-docs.yaml?branch=master)
![license](https://img.shields.io/github/license/linhng98/mess-around)
[![semantic-release: angular](https://img.shields.io/badge/semantic--release-angular-e10079?logo=semantic-release)](https://github.com/semantic-release/semantic-release)
![forks](https://img.shields.io/github/forks/linhng98/mess-around?style=social)
![stars](https://img.shields.io/github/stars/linhng98/mess-around?style=social)

<!-- PROJECT LOGO -->
<br />
<div align="center">
  <h3 align="center">MESS AROUND</h3>
  <a href="https://github.com/linhng98/mess-around">
  <img src="images/mess.png" alt="Logo" width="80" height="80">
  </a>

  <p align="center">
    Awesome devops tools playground
    <br />
    <a href="https://docs.homelab.linhng98.com"><strong>Explore the docs »</strong></a>
    <br />
  </p>
</div>

1. [Introduction](#introduction)
2. [About the project](#about-the-project)
3. [Documentation](#documentation)
4. [Improvements](#improvements)
5. [License](#license)
6. [Acknowledgements](#acknowledgements)

## Introduction

- Playground to demonstrate many awesome devops tools, enforce gitops pattern, build scalable and sustainable application cluster
- Got idea and well-structed ansible code from [khuedoan's homelab](https://github.com/khuedoan/homelab.git), he is a talented and enthusiastic SRE, totally worth taking a look at his awesome project

## About the project

- `M`ultiplatform support, avoid vendor lock-in that any enterprise should not be immersed in.
- `E`fficency and effortless bootstrap kubernete framework.
- `S`implicity is prerequisite for reliability.
- `S`calability design in mind.
- `A`utomation help people reduce human error, improve productivity.
- `R`eliability targeted, improve end user experience and development velocity.
- `O`ptimal solution.
- `U`tility configuration could be reused and easy to customize.
- `N`ative Kubernete applications, well-tested and production ready.
- `D`urability is a part of what makes a great system.

## Documentation

- Visit project document and blog at [docs.homelab.linhng98.com](https://docs.homelab.linhng98.com)

## Improvements

- [x] Kernel tuning (max_user_watches, max_user_instances, ...)
- [x] Centralize tracing (grafana tempo)
- [x] Asynchronous distributed tracing (nats jetstream, otel manual instrument)
- [x] Automatic release (semantic release)
- [x] Automatic dependency update (renovate)
- [x] IAC automation via pull request (atlantis)
- [x] Infrastructure monitoring using ebpf (pixis)
- [x] External traffic collecting and monitoring (elastiflow, pmacct)
- [ ] Container runtime security (falco, trivy)
- [ ] Push-based image tag update (release-bot)
- [ ] Admission webhook and policy as code (kyverno, OPA)
- [ ] Chaos testing (chao mesh, litmus)

## License

- Distributed under [Apache License 2.0](https://www.apache.org/licenses/LICENSE-2.0)

## Acknowledgements

- <https://github.com/khuedoan/homelab.git>
- <https://www.youtube.com/watch?v=E_OlsA1hF4k>
- <https://askubuntu.com/questions/1235723/automated-20-04-server-installation-using-pxe-and-live-server-image>
- <https://ubuntu.com/server/docs/install/netboot-amd64>
- <https://github.com/lablabs/ansible-role-rke2>
