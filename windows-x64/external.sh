#!/bin/bash

set -e

SDL_SHA=535d80badefc83c5c527ec5748f2a20d6a9310fe
SDL_IMAGE_SHA=4ff27afa450eabd2a827e49ed86fab9e3bf826c5
SDL_TTF_SHA=5e651ee5054a95fdb91702ba1b398d751155febc
SDL_MIXER_SHA=af6a29df4e14c6ce72608b3ccd49cf35e1014255

CACHE_NAME="SDL-${SDL_SHA}-${SDL_IMAGE_SHA}-${SDL_TTF_SHA}-${SDL_MIXER_SHA}"

mkdir -p tmp/build-libs/windows-x64
mkdir -p tmp/runtime-libs/windows-x64

curl -sL https://github.com/libsdl-org/SDL/archive/${SDL_SHA}.zip -o SDL-${SDL_SHA}.zip
unzip SDL-${SDL_SHA}.zip
cd SDL-${SDL_SHA}
sed -i 's/OUTPUT_NAME "SDL3"/OUTPUT_NAME "SDL364"/' CMakeLists.txt
cmake -G "Visual Studio 17 2022" \
   -DSDL_SHARED=ON \
   -DSDL_STATIC=OFF \
   -DSDL_TEST_LIBRARY=OFF \
   -B build
cmake --build build --config Release
cp build/Release/SDL364.lib ../tmp/build-libs/windows-x64
cp build/Release/SDL364.dll ../tmp/runtime-libs/windows-x64
cd ..

curl -sL https://github.com/libsdl-org/SDL_image/archive/${SDL_IMAGE_SHA}.zip -o SDL_image-${SDL_IMAGE_SHA}.zip
unzip SDL_image-${SDL_IMAGE_SHA}.zip
cd SDL_image-${SDL_IMAGE_SHA}
external/download.sh
sed -i 's/OUTPUT_NAME "SDL3_image"/OUTPUT_NAME "SDL3_image64"/' CMakeLists.txt
cmake -G "Visual Studio 17 2022" \
   -DBUILD_SHARED_LIBS=ON \
   -DSDLIMAGE_SAMPLES=OFF \
   -DSDLIMAGE_DEPS_SHARED=ON \
   -DSDLIMAGE_VENDORED=ON \
   -DSDLIMAGE_AVIF=OFF \
   -DSDLIMAGE_WEBP=OFF \
   -DSDL3_DIR=../SDL-${SDL_SHA}/build \
   -B build
cmake --build build --config Release
cp build/Release/SDL3_image64.lib ../tmp/build-libs/windows-x64
cp build/Release/SDL3_image64.dll ../tmp/runtime-libs/windows-x64
cd ..

curl -sL https://github.com/libsdl-org/SDL_ttf/archive/${SDL_TTF_SHA}.zip -o SDL_ttf-${SDL_TTF_SHA}.zip
unzip SDL_ttf-${SDL_TTF_SHA}.zip
cd SDL_ttf-${SDL_TTF_SHA}
external/download.sh
sed -i 's/OUTPUT_NAME SDL3_ttf/OUTPUT_NAME "SDL3_ttf64"/' CMakeLists.txt
cmake -G "Visual Studio 17 2022" \
   -DBUILD_SHARED_LIBS=ON \
   -DSDLTTF_SAMPLES=OFF \
   -DSDLTTF_VENDORED=ON \
   -DSDLTTF_HARFBUZZ=ON \
   -DSDL3_DIR=../SDL-${SDL_SHA}/build \
   -B build
cmake --build build --config Release
cp build/Release/SDL3_ttf64.lib ../tmp/build-libs/windows-x64
cp build/Release/SDL3_ttf64.dll ../tmp/runtime-libs/windows-x64
cd ..

curl -sL https://github.com/libsdl-org/SDL_mixer/archive/${SDL_MIXER_SHA}.zip -o SDL_mixer-${SDL_MIXER_SHA}.zip
unzip SDL_mixer-${SDL_MIXER_SHA}.zip
cd SDL_mixer-${SDL_MIXER_SHA}
external/download.sh
sed -i 's/OUTPUT_NAME "SDL3_mixer"/OUTPUT_NAME "SDL3_mixer64"/' CMakeLists.txt
cmake -G "Visual Studio 17 2022" \
   -DBUILD_SHARED_LIBS=ON \
   -DSDLMIXER_SAMPLES=OFF \
   -DSDLMIXER_VENDORED=ON \
   -DSDL3_DIR=../SDL-${SDL_SHA}/build \
   -B build
cmake --build build --config Release
cp build/Release/SDL3_mixer64.lib ../tmp/build-libs/windows-x64
cp build/Release/SDL3_mixer64.dll ../tmp/runtime-libs/windows-x64
cd ..
