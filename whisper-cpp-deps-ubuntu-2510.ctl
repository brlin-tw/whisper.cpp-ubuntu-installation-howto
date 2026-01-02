# Package definition for the whisper.cpp software's runtime dependencies
# Copyright 2024 林博仁(Buo-ren, Lin) <Buo.Ren.Lin@gmail.com>
# SPDX-License-Identifier: CC-BY-SA-4.0
Section: misc
Priority: optional
Homepage: https://github.com/brlin-tw/whisper.cpp-ubuntu-installation-howto
Standards-Version: 3.9.2

Package: whisper-cpp-deps
Maintainer: 林博仁(Buo-ren, Lin) <buo.ren.lin@gmail.com>
Depends:
    libavcodec-extra61
    ,libavformat61
    ,libopenblas0
    ,libswresample5
    ,libvulkan1
Recommends:
    ffmpeg
Description: Runtime dependencies for the whisper.cpp software
