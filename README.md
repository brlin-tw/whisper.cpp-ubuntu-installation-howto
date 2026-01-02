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

## Query the latest release version of whisper.cpp

Browse the [Releases · ggml-org/whisper.cpp](https://github.com/ggml-org/whisper.cpp/releases) page to find out the latest release version of the whisper.cpp project.  It is normally listed as the first entry in the releases page(excluding the potentially pre-release entries), without the `v` prefix.

The corresponding release tag can be found on the same page.  It is listed at the right side of the "tag" icon of each release entry:

![A screenshot of the Releases page of the whisper.cpp project on GitHub, highlighting the location of the release tag of a release entry.](docs-assets/whisper-cpp-release-tag-location.png "Location of the release tag of a release entry")

As of the writing of this article, the latest release version is `1.8.2`(corresponding tag is `v1.8.2`), which will be used in the following examples.

## Acquire the whisper.cpp source code

Run the following commands in the terminal to clone the upstream project's source code:

```bash
whisper_cpp_version=1.8.2
whisper_cpp_tag="v${whisper_cpp_version}"
git_clone_opts=(
    --branch "${whisper_cpp_tag}"
    --single-branch
    --depth 1
)
git clone "${git_clone_opts[@]}" https://github.com/ggml-org/whisper.cpp.git
```

The source code will be checked out to the `whisper.cpp` sub-directory of the
current working directory.

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

## Configure the build of whisper.cpp

Next we should configure the build of the whisper.cpp software to enable features that we want and other details like the installation prefix.

In this tutorial we will only configure whisper.cpp to use CPU acceleration, for other acceleration options the following Agentic AI prompt might be helpful:

```text
Help me figure out the CMake parameters I should set to build whisper.cpp for this particular system?  Just suggest me all the CMake parameters(including CPU and GPU) to set (and to which value) without running the build yourself.
```

You can also run the curses based user interface for CMake utility(ccmake) to see all the available build options:

```bash
ccmake -B build whisper.cpp
```

If you see the EMPTY CACHE entry in the ccmake interface, press the `c` key to configure the build first, then press `e` key to see all the available build options.

After deciding the build options, run the following commands to configure the build:

```bash
whisper_cpp_version=1.8.2
whisper_cpp_prefix="/opt/whisper.cpp-${whisper_cpp_version}"
cmake_opts=(
    # Generate build files in the "build" sub-directory.
    -B build

    # Use Release build type for better performance.
    -DCMAKE_BUILD_TYPE=Release

    # Enable Vulkan support for GPU acceleration (if applicable).
    -DGGML_VULKAN=ON

    # Enable OpenBLAS support for CPU acceleration.
    -DGGML_OPENBLAS=ON

    # Set custom installation prefix to allow easier removal.
    -DCMAKE_INSTALL_PREFIX="${whisper_cpp_prefix}"

    # Build shared libraries instead of static libraries.
    -DBUILD_SHARED_LIBS=ON

    # Allows the program to download models directly from a URL.
    -DWHISPER_CURL=ON

    # Ensure that the RPATH is set correctly for the installed binaries.
    -DCMAKE_INSTALL_RPATH="${whisper_cpp_prefix}/lib"
    -DCMAKE_BUILD_WITH_INSTALL_RPATH=TRUE
)
cmake "${cmake_opts[@]}" whisper.cpp
```

they should have the following similar output if everything goes well:

```text
-- x86 detected
-- Adding CPU backend variant ggml-cpu: -march=native
-- Configuring done (0.8s)
-- Generating done (0.0s)
-- Build files have been written to: build
```

## Build the whisper-cpp software

Run the following commands to build the whisper-cpp software:

```bash
cpu_threads="$(nproc)"
build_threads="$((cpu_threads > 4 ? cpu_threads - 2 : cpu_threads))"
cmake --build build -j "${build_threads}"
```

## Install the whisper-cpp software

Run the following command _as root_ to install the whisper-cpp software:

```bash
cmake --install build --verbose
```

The whisper.cpp binaries and libraries will be installed to the
`/opt/whisper.cpp-1.8.2` directory(as configured in the previous steps).

## Install the runtime dependencies

Run the following command to build the whisper-cpp-deps meta-package:

```bash
equivs-build _control_file_
```

Replace the _control_file_ placeholder with the proper filename for your operating system version:

* Ubuntu 24.04: `whisper-cpp-deps.ctl`
* Ubuntu 25.10: `whisper-cpp-deps-2510.ctl`

After the meta-package is built you can install the meta-package by running the
following command _as root_:

```bash
apt install ./whisper-cpp-deps_1.0_all.deb
```

## Use the built whisper.cpp software

To use the installed whisper.cpp software, download a model first by running the following command:

```bash
./whisper.cpp/models/download-ggml-model.sh _model_name_
```

Replace the _model_name_ placeholder with the proper model name, you can acquire the list of available models by running the following command:

```bash
./whisper.cpp/models/download-ggml-model.sh
```

Then you can run the following command to transcribe an audio file:

```bash
cpu_threads="$(nproc)"
transcribe_threads="$((cpu_threads > 4 ? cpu_threads - 2 : cpu_threads))"
whisper_opts=(
    # Specify the number of threads to use for transcription
    --threads "${transcribe_threads}"

    # Show progress during transcription
    --print-progress

    # Use flash attention for better performance
    --flash-attn

    # Suppress non-speech tokens in the output
    --suppress-nst

    # Automatically detect the language of the input audio(default: English only)
    --language auto

    # Specify the model file to use
    -m whisper.cpp/models/ggml-base.en.bin

    # Specify the input audio file to transcribe
    -f whisper.cpp/samples/jfk.wav
)
/opt/whisper.cpp-1.8.2/bin/whisper-cli "${whisper_opts[@]}"
```

it should have the following similar output if everything goes well:

```text
[00:00:00.000 --> 00:00:11.000]   And so my fellow Americans, ask not what your country can do for you, ask what you can do for your country.


whisper_print_timings:     load time =    85.64 ms
whisper_print_timings:     fallbacks =   0 p /   0 h
whisper_print_timings:      mel time =     6.56 ms
whisper_print_timings:   sample time =    32.52 ms /   131 runs (    0.25 ms per run)
whisper_print_timings:   encode time =   872.30 ms /     1 runs (  872.30 ms per run)
whisper_print_timings:   decode time =     6.49 ms /     2 runs (    3.24 ms per run)
whisper_print_timings:   batchd time =   149.11 ms /   125 runs (    1.19 ms per run)
whisper_print_timings:   prompt time =     0.00 ms /     1 runs (    0.00 ms per run)
whisper_print_timings:    total time =  1189.93 ms
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
