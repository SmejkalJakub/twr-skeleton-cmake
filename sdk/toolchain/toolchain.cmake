# Toolchain file that takes care of the cross compilation for the Core Module

# Setup cross compilation
set(CMAKE_SYSTEM_NAME Generic)
set(CMAKE_SYSTEM_PROCESSOR ARM)

# Setup how the toolchain should be located
if(MINGW OR CYGWIN OR WIN32)
    set(UTIL_SEARCH_CMD where)
elseif(UNIX OR APPLE)
    set(UTIL_SEARCH_CMD which)
endif()

# Set selected toolchain prefix
set(TOOLCHAIN_PREFIX arm-none-eabi-)

# Locate the toolchain
execute_process(
  COMMAND ${UTIL_SEARCH_CMD} ${TOOLCHAIN_PREFIX}gcc
  OUTPUT_VARIABLE BINUTILS_PATH
  OUTPUT_STRIP_TRAILING_WHITESPACE
)
get_filename_component(ARM_TOOLCHAIN_DIR ${BINUTILS_PATH} DIRECTORY)

# Without that flag CMake is not able to pass test compilation check
if (${CMAKE_VERSION} VERSION_EQUAL "3.6.0" OR ${CMAKE_VERSION} VERSION_GREATER "3.6")
    set(CMAKE_TRY_COMPILE_TARGET_TYPE STATIC_LIBRARY)
else()
    MESSAGE( STATUS "CMAKE_C_FLAGS: " ${CMAKE_CURRENT_SOURCE_DIR} )
endif()

# Set all compilers
set(CMAKE_C_COMPILER ${TOOLCHAIN_PREFIX}gcc)
set(CMAKE_ASM_COMPILER ${CMAKE_C_COMPILER})

# Setup default CFLAGS
set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -D\"__weak=__attribute__((weak))\"")
set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -D\"__packed=__attribute__((__packed__))\"")
set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -DUSE_HAL_DRIVER")
set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -DSTM32L083xx")
set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -DHAL_IWDG_MODULE_ENABLED")
set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -mcpu=cortex-m0plus")
set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -mthumb")
set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -mlittle-endian")
set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -Wall")
set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -pedantic")
set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -Wextra")
set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -Wmissing-include-dirs")
set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -Wswitch-default")
set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -Wswitch-enum")
set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -ffunction-sections")
set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -fdata-sections")
set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -std=c11")

# Setup HARDWARIO TOWER special CFLAGS
if(DEFINED SCHEDULER_INTERVAL)
    set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -DTWR_SCHEDULER_INTERVAL_MS=${SCHEDULER_INTERVAL}")
endif()

set(BAND 868)
set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -DBAND=${BAND}")

set(CMAKE_ASH_FLAGS "${CMAKE_ASH_FLAGS} -mcpu=cortex-m0plus")
set(CMAKE_ASH_FLAGS "${CMAKE_ASH_FLAGS} -mthumb")
set(CMAKE_ASH_FLAGS "${CMAKE_ASH_FLAGS} -mlittle-endian")

# Linker script
set(LINKER_SCRIPT ${CMAKE_CURRENT_SOURCE_DIR}/sys/lkr/stm32l083cz.ld)

# Setup utils
set(CMAKE_OBJCOPY ${ARM_TOOLCHAIN_DIR}/${TOOLCHAIN_PREFIX}objcopy CACHE INTERNAL "objcopy tool")

set(CMAKE_SYSROOT ${ARM_TOOLCHAIN_DIR}/../arm-none-eabi)
set(CMAKE_FIND_ROOT_PATH ${BINUTILS_PATH})
set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)
set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)
