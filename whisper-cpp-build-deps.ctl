# Package definition for the whisper.cpp software's build dependencies
# Copyright 2024 林博仁(Buo-ren, Lin) <Buo.Ren.Lin@gmail.com>
# SPDX-License-Identifier: CC-BY-SA-4.0
Section: misc
Priority: optional
Homepage: https://github.com/brlin-tw/whisper.cpp-ubuntu-installation-howto
Standards-Version: 3.9.2

Package: whisper-cpp-build-deps
Maintainer: 林博仁(Buo-ren, Lin) <buo.ren.lin@gmail.com>
Depends:
    ccache
    ,gcc
    ,g++
    ,make
    ,cmake
    ,cmake-curses-gui
    ,libopenblas-dev
    ,libavcodec-dev
    ,libswresample-dev
    ,libavformat-dev
Description: Build dependencies for the whisper.cpp software
