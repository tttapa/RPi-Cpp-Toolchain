list(APPEND CMAKE_PROGRAM_PATH ${CMAKE_CURRENT_LIST_DIR}/../toolchain/x-tools/aarch64-rpi3-linux-gnu/bin)

set(CMAKE_SYSTEM_NAME Linux)
set(CMAKE_SYSTEM_PROCESSOR ARM64)

set(CMAKE_C_COMPILER aarch64-rpi3-linux-gnu-gcc)
set(CMAKE_CXX_COMPILER aarch64-rpi3-linux-gnu-g++)

set(CMAKE_SYSROOT ${CMAKE_CURRENT_LIST_DIR}/../toolchain/RPi3-sysroot-aarch64)

include(${CMAKE_CURRENT_LIST_DIR}/RPi3-Toolchain.cmake)