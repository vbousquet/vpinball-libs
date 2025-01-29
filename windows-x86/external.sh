#!/bin/bash

set -e

PINMAME_SHA=872f7796d4c96567e38e764d4f5f5224efc7c9d4
SDL_SHA=535d80badefc83c5c527ec5748f2a20d6a9310fe
SDL_IMAGE_SHA=4ff27afa450eabd2a827e49ed86fab9e3bf826c5
SDL_TTF_SHA=5e651ee5054a95fdb91702ba1b398d751155febc
SDL_MIXER_SHA=af6a29df4e14c6ce72608b3ccd49cf35e1014255

mkdir -p tmp/build-libs/windows-x86
mkdir -p tmp/runtime-libs/windows-x86
mkdir -p tmp/include

curl -sL https://github.com/vbousquet/pinmame/archive/${PINMAME_SHA}.zip -o pinmame-${PINMAME_SHA}.zip
unzip pinmame-${PINMAME_SHA}.zip
cd pinmame-${PINMAME_SHA}
cp cmake/libpinmame/CMakelists.txt .
cmake -G "Visual Studio 17 2022" \
   -A Win32 \
   -DPLATFORM=win \
   -DARCH=x86 \
   -DBUILD_SHARED=ON \
   -DBUILD_STATIC=OFF \
   -B build
cmake --build build --config Release
cp build/Release/pinmame.lib ../tmp/build-libs/windows-x86
cp build/Release/pinmame.dll ../tmp/runtime-libs/windows-x86
cp src/libpinmame/libpinmame.h ../tmp/include
cd ..

curl -sL https://github.com/libsdl-org/SDL/archive/${SDL_SHA}.zip -o SDL-${SDL_SHA}.zip
unzip SDL-${SDL_SHA}.zip
cd SDL-${SDL_SHA}
cmake -G "Visual Studio 17 2022" -A Win32 \
   -DSDL_SHARED=ON \
   -DSDL_STATIC=OFF \
   -DSDL_TEST_LIBRARY=OFF \
   -B build
cmake --build build --config Release
cp build/Release/SDL3.lib ../tmp/build-libs/windows-x86
cp build/Release/SDL3.dll ../tmp/runtime-libs/windows-x86
mkdir -p ../tmp/include/SDL3
cp -r include/SDL3/* ../tmp/include/SDL3
cd ..

curl -sL https://github.com/libsdl-org/SDL_image/archive/${SDL_IMAGE_SHA}.zip -o SDL_image-${SDL_IMAGE_SHA}.zip
unzip SDL_image-${SDL_IMAGE_SHA}.zip
cd SDL_image-${SDL_IMAGE_SHA}
external/download.sh
cmake -G "Visual Studio 17 2022" -A Win32 \
   -DBUILD_SHARED_LIBS=ON \
   -DSDLIMAGE_SAMPLES=OFF \
   -DSDLIMAGE_DEPS_SHARED=ON \
   -DSDLIMAGE_VENDORED=ON \
   -DSDLIMAGE_AVIF=OFF \
   -DSDLIMAGE_WEBP=OFF \
   -DSDL3_DIR=../SDL-${SDL_SHA}/build \
   -B build
cmake --build build --config Release
cp build/Release/SDL3_image.lib ../tmp/build-libs/windows-x86
cp build/Release/SDL3_image.dll ../tmp/runtime-libs/windows-x86
mkdir -p ../tmp/include/SDL3_image
cp -r include/SDL3_image/* ../tmp/include/SDL3_image
cd ..

curl -sL https://github.com/libsdl-org/SDL_ttf/archive/${SDL_TTF_SHA}.zip -o SDL_ttf-${SDL_TTF_SHA}.zip
unzip SDL_ttf-${SDL_TTF_SHA}.zip
cd SDL_ttf-${SDL_TTF_SHA}
external/download.sh
cmake -G "Visual Studio 17 2022" -A Win32 \
   -DBUILD_SHARED_LIBS=ON \
   -DSDLTTF_SAMPLES=OFF \
   -DSDLTTF_VENDORED=ON \
   -DSDLTTF_HARFBUZZ=ON \
   -DSDL3_DIR=../SDL-${SDL_SHA}/build \
   -B build
cmake --build build --config Release
cp build/Release/SDL3_ttf.lib ../tmp/build-libs/windows-x86
cp build/Release/SDL3_ttf.dll ../tmp/runtime-libs/windows-x86
mkdir -p ../tmp/include/SDL3_ttf
cp -r include/SDL3_ttf/* ../tmp/include/SDL3_ttf
cd ..

curl -sL https://github.com/libsdl-org/SDL_mixer/archive/${SDL_MIXER_SHA}.zip -o SDL_mixer-${SDL_MIXER_SHA}.zip
unzip SDL_mixer-${SDL_MIXER_SHA}.zip
cd SDL_mixer-${SDL_MIXER_SHA}
external/download.sh
cmake -G "Visual Studio 17 2022" -A Win32 \
   -DBUILD_SHARED_LIBS=ON \
   -DSDLMIXER_SAMPLES=OFF \
   -DSDLMIXER_VENDORED=ON \
   -DSDL3_DIR=../SDL-${SDL_SHA}/build \
   -B build
cmake --build build --config Release
cp build/Release/SDL3_mixer.lib ../tmp/build-libs/windows-x86
cp build/Release/SDL3_mixer.dll ../tmp/runtime-libs/windows-x86
mkdir -p ../tmp/include/SDL3_mixer
cp -r include/SDL3_mixer/* ../tmp/include/SDL3_mixer
cd ..