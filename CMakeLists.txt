cmake_minimum_required(VERSION 3.20)
project(CMakeCommon
  VERSION 1.0.0
  DESCRIPTION "Some Creepy Shitty CMake Scripts"
)

include(CMakeCommon.cmake)

Core_Utility_FetchQMakeContents(
  GIT_REPOSITORY https://github.com/SMR76/knight-pen.git
  QMAKE_CONFIG_DIRECTORY src/knight-pen
)
