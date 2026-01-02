# (IN DEVELOPMENT) How to install whisper.cpp on Ubuntu

Documents the process on installing the [whisper.cpp](https://github.com/ggml-org/whisper.cpp) utility on Ubuntu as clean as possible.

<https://gitlab.com/brlin/whisper.cpp-ubuntu-installation-howto>  
[![The GitLab CI pipeline status badge of the project's `main` branch](https://gitlab.com/brlin/whisper.cpp-ubuntu-installation-howto/badges/main/pipeline.svg?ignore_skipped=true "Click here to check out the comprehensive status of the GitLab CI pipelines")](https://gitlab.com/brlin/whisper.cpp-ubuntu-installation-howto/-/pipelines) [![GitHub Actions workflow status badge](https://github.com/brlin-tw/whisper.cpp-ubuntu-installation-howto/actions/workflows/check-potential-problems.yml/badge.svg "GitHub Actions workflow status")](https://github.com/brlin-tw/whisper.cpp-ubuntu-installation-howto/actions/workflows/check-potential-problems.yml) [![pre-commit enabled badge](https://img.shields.io/badge/pre--commit-enabled-brightgreen?logo=pre-commit&logoColor=white "This project uses pre-commit to check potential problems")](https://pre-commit.com/) [![REUSE Specification compliance badge](https://api.reuse.software/badge/gitlab.com/brlin/whisper.cpp-ubuntu-installation-howto "This project complies to the REUSE specification to decrease software licensing costs")](https://api.reuse.software/info/gitlab.com/brlin/whisper.cpp-ubuntu-installation-howto)

## Acquire the projects release package

To assist on the tutorial, download the project's release package from the
Releases page and extract it.  Then, launch your preferred terminal application
and run the following command to switch the working directory to the extracted
project working directory.

```bash
cd /path/to/whisper.cpp-ubuntu-installation-howto-X.Y.Z
```

## Installing the build dependencies

By reading [the upstream project's README](https://github.com/ggerganov/whisper.cpp/blob/master/README.md)
one could find out that this software requires the following build dependencies:

* GNU Make
* Build chain for building C and C++ programs

In order to install these build dependencies with uninstalling them cleanly in
mind, one can use the equivs utility to build a meta-package that depends on
these packages.

Install the equivs utility by running the following command _as root_:

```bash
apt install equivs
```

Then run the following command to build the whisper-cpp-build-deps meta-package:

```bash
equivs-build whisper-cpp-build-deps.ctl
```

After the meta-package is built you can install the meta-package by running the
following command _as root_:

```bash
apt install ./whisper-cpp-build-deps_1.0_all.deb
```

## Build the whisper-cpp software

Run the following command to build the whisper-cpp software:

```bash
GGML_OPENBLAS=1 make -j
```

## Install the runtime dependencies

Run the following command to build the whisper-cpp-deps meta-package:

```bash
equivs-build whisper-cpp-deps.cfl
```

After the meta-package is built you can install the meta-package by running the
following command _as root_:

```bash
apt install ./whisper-cpp-deps_1.0_all.deb
```

## Reference

The following are the external materials that are referenced during the writing
of this article:

* [Quick start | ggerganov/whisper.cpp: Port of OpenAI's Whisper model in C/C++](https://github.com/ggerganov/whisper.cpp?tab=readme-ov-file#quick-start)  
  Explains the process of building the software from source.
* [BLAS CPU support via OpenBLAS | ggerganov/whisper.cpp: Port of OpenAI's Whisper model in C/C++](https://github.com/ggerganov/whisper.cpp?tab=readme-ov-file#blas-cpu-support-via-openblas)  
  Explains on how to enable OpenBLAS support in the whisper-cpp software.

## Licensing

Unless otherwise noted(individual file's header/[REUSE DEP5](.reuse/dep5)), this product is licensed under [the 4.0 International version of the Creative Commons Attribution-ShareAlike license](https://creativecommons.org/licenses/by-sa/4.0/), or any of its more recent versions of your preference.

This work complies to [the REUSE Specification](https://reuse.software/spec/), refer the [REUSE - Make licensing easy for everyone](https://reuse.software/) website for info regarding the licensing of this product.
