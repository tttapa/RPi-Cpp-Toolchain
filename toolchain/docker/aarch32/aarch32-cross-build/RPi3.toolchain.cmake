SET(CMAKE_SYSTEM_NAME Linux)
SET(CMAKE_C_COMPILER armv8-rpi3-linux-gnueabihf-gcc)
SET(CMAKE_CXX_COMPILER armv8-rpi3-linux-gnueabihf-g++)
SET(CMAKE_ASM_COMPILER armv8-rpi3-linux-gnueabihf-gcc)
SET(CMAKE_SYSTEM_PROCESSOR arm)

add_definitions("-marm")

# rdynamic means the backtrace should work
IF (CMAKE_BUILD_TYPE MATCHES "Debug")
   add_definitions(-rdynamic)
ENDIF()

# avoids annoying and pointless warnings from gcc
SET(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -U_FORTIFY_SOURCE")
SET(CMAKE_ASM_FLAGS "${CMAKE_ASM_FLAGS} -c")