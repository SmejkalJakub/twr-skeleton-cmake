

cmake_minimum_required(VERSION 3.20.0)

project(firmware)

enable_language(C ASM)

add_subdirectory(sdk)
add_subdirectory(src)
