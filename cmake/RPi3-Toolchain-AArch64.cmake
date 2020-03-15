set(CMAKE_SYSTEM_NAME Linux)
set(CMAKE_SYSTEM_PROCESSOR ARM64)

set(TOOLCHAIN_BIN "${CMAKE_CURRENT_LIST_DIR}/../toolchain/x-tools/aarch64-rpi3-linux-gnu/bin")
set(CMAKE_C_COMPILER "${TOOLCHAIN_BIN}/aarch64-rpi3-linux-gnu-gcc")
set(CMAKE_CXX_COMPILER "${TOOLCHAIN_BIN}/aarch64-rpi3-linux-gnu-g++")

set(CMAKE_SYSROOT "${CMAKE_CURRENT_LIST_DIR}/../toolchain/sysroot-rpi3-aarch64")
SET(CMAKE_FIND_ROOT_PATH "${CMAKE_SYSROOT}") 

include("${CMAKE_CURRENT_LIST_DIR}/Common-RPi-Toolchain.cmake")