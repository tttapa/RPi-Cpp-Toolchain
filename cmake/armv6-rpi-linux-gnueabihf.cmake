set(CMAKE_SYSTEM_NAME Linux)
set(CMAKE_SYSTEM_PROCESSOR armv6)

set(TOOLCHAIN_BIN "${CMAKE_CURRENT_LIST_DIR}/../toolchain/x-tools/armv6-rpi-linux-gnueabihf/bin")
set(CMAKE_C_COMPILER "${TOOLCHAIN_BIN}/armv6-rpi-linux-gnueabihf-gcc")
set(CMAKE_CXX_COMPILER "${TOOLCHAIN_BIN}/armv6-rpi-linux-gnueabihf-g++")

set(CMAKE_SYSROOT "${CMAKE_CURRENT_LIST_DIR}/../toolchain/sysroot-armv6-rpi-linux-gnueabihf")
SET(CMAKE_FIND_ROOT_PATH "${CMAKE_SYSROOT}") 

include("${CMAKE_CURRENT_LIST_DIR}/Common-RPi-Toolchain.cmake")