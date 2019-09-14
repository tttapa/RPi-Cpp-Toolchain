list(APPEND CMAKE_PROGRAM_PATH ${CMAKE_CURRENT_LIST_DIR}/../toolchain/x-tools/armv8-rpi3-linux-gnueabihf/bin)

set(CMAKE_SYSTEM_NAME Linux)
set(CMAKE_SYSTEM_PROCESSOR armv8)

set(CMAKE_C_COMPILER armv8-rpi3-linux-gnueabihf-gcc)
set(CMAKE_CXX_COMPILER armv8-rpi3-linux-gnueabihf-g++)

set(CMAKE_SYSROOT ${CMAKE_CURRENT_LIST_DIR}/../toolchain/RPi3-sysroot-aarch32)
SET(CMAKE_FIND_ROOT_PATH ${CMAKE_SYSROOT}) 

include(${CMAKE_CURRENT_LIST_DIR}/RPi3-Toolchain.cmake)