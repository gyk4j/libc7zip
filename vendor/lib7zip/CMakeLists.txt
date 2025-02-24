cmake_minimum_required(VERSION 3.10)

project(lib7zip)

option(LIB7ZIP_BUILD_TESTS "Build tests for lib7zip" OFF)

set(PATCH_DIR ${CMAKE_CURRENT_SOURCE_DIR}/patches)

set(UPSTREAM_DIR ${CMAKE_BINARY_DIR}/upstream-7zip-src)
set(UPSTREAM_INCLUDE_DIR ${UPSTREAM_DIR})

if (${CMAKE_SYSTEM_NAME} STREQUAL "Windows")
set(UPSTREAM_SRC_URL https://master.dl.sourceforge.net/project/sevenzip/7-Zip/16.04/7z1604-src.7z?viasf=1)
# Stop downloading from http://www.7-zip.org/a/7z1604-src.7z for CI in case 
# site owner blocks further downloading due to excessive repetitive downloads.
# Change to SourceForge mirror instead. 
set(UPSTREAM_PATCH_CMD dos2unix ${PATCH_DIR}/001_avoid_duplicate_guids.patch COMMAND patch --ignore-whitespace --strip 1 < ${PATCH_DIR}/001_avoid_duplicate_guids.patch COMMAND unix2dos ${UPSTREAM_DIR}/CPP/Windows/FileIO.h)
else() # Windows
set(UPSTREAM_SRC_URL https://downloads.sourceforge.net/project/p7zip/p7zip/16.02/p7zip_16.02_src_all.tar.bz2)
set(UPSTREAM_PATCH_CMD )
endif() # not Windows

include(DownloadProject.cmake)
download_project(
  PROJ upstream-7zip
  URL ${UPSTREAM_SRC_URL}
  PATCH_COMMAND ${UPSTREAM_PATCH_CMD}
)

add_subdirectory(Lib7Zip)

if (LIB7ZIP_BUILD_TESTS)
  add_subdirectory(Test7Zip)
endif()

