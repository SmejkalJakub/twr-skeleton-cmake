# Set helper variables
set(OUT_DIR out)
set(TOOLCHAIN_DIR toolchain)

include(${TOOLCHAIN_DIR}/utils.cmake)

# Set extension for final binary and output directory
set(CMAKE_EXECUTABLE_SUFFIX ".elf")
set (CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_SOURCE_DIR}/${OUT_DIR}/${TYPE}/)

#Map file location
set(MAP ${CMAKE_SOURCE_DIR}/${OUT_DIR}/${TYPE}/${CMAKE_PROJECT_NAME}.map)

# Setup VERSION CFLAG based on system
# Default VERSION is set to "vdev" for development
if(NOT DEFINED VERSION)
    getVersion()
endif()
add_compile_definitions(VERSION=\"${VERSION}\")

if(NOT DEFINED GIT_VERSION)
    getGitVersion()
endif()
add_compile_definitions(GIT_VERSION=\"${GIT_VERSION}\")

string(TIMESTAMP BUILD_DATE "%Y-%m-%d %H:%M:%S" UTC)
add_compile_definitions(BUILD_DATE=\"${BUILD_DATE}\")

# Set default build type to "debug"
if(NOT DEFINED TYPE)
    set(TYPE debug)
ENDIF()

# Add debug CFLAGS
if(TYPE MATCHES "debug")
    set(CMAKE_C_FLAGS_DEBUG "${CMAKE_C_FLAGS_DEBUG} -g3")
    set(CMAKE_C_FLAGS_DEBUG "${CMAKE_C_FLAGS_DEBUG} -Og")
    set(CMAKE_C_FLAGS_DEBUG "${CMAKE_C_FLAGS_DEBUG} -g3")
    set(CMAKE_C_FLAGS_DEBUG "${CMAKE_C_FLAGS_DEBUG} -DDEBUG")

    set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} ${CMAKE_C_FLAGS_DEBUG}")

    set(CMAKE_ASH_FLAGS_DEBUG "${CMAKE_ASH_FLAGS_DEBUG} -g3")
    set(CMAKE_ASH_FLAGS_DEBUG "${CMAKE_ASH_FLAGS_DEBUG} -Og")
    set(CMAKE_ASH_FLAGS "${CMAKE_ASH_FLAGS} ${CMAKE_ASH_FLAGS_DEBUG}")
ENDIF()

# Add release CFLAGS
if(TYPE MATCHES "release")
    set(CMAKE_C_FLAGS_RELEASE "${CMAKE_C_FLAGS_RELEASE} -Os")
    set(CMAKE_C_FLAGS_RELEASE "${CMAKE_C_FLAGS_RELEASE} -DRELEASE")

    set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} ${CMAKE_C_FLAGS_RELEASE}")

    set(CMAKE_ASH_FLAGS_RELEASE "${CMAKE_ASH_FLAGS_RELEASE} -Os")
    set(CMAKE_ASH_FLAGS "${CMAKE_ASH_FLAGS} ${CMAKE_ASH_FLAGS_RELEASE}")
ENDIF()

# Linker script
set(LINKER_SCRIPT ${CMAKE_CURRENT_SOURCE_DIR}/sys/lkr/stm32l083cz.ld)

# Setup linker flags
set(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} -T${LINKER_SCRIPT}")
set(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} -Wl,-Map=${MAP}")
set(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} -mcpu=cortex-m0plus")
set(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} -mthumb")
set(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} -mlittle-endian")
set(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} -Wl,-lc")
set(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} -Wl,-lm")
set(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} -static")
set(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} -Wl,--gc-sections")
set(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} -Wl,--print-memory-usage")
set(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} -Wl,-u,__errno")
set(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} --specs=nosys.specs")

# Create the final executable 'firmware.elf'
add_executable(${CMAKE_PROJECT_NAME})

# All other directories with source files
# You need to update the specific CMakeLists files in the respective directories if you want to update the SDK
add_subdirectory(twr)
add_subdirectory(bcl)
add_subdirectory(stm)
add_subdirectory(lib)
add_subdirectory(sys)

# Generate the final "firmware.bin" in "out" directory and root directory
generate_object(${CMAKE_PROJECT_NAME} .bin binary)
