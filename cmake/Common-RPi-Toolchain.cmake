# Path to find compilers and other tools
set(RPI_CPP_TOOLCHAIN_TOOLCHAIN_PATHS
    "${CMAKE_CURRENT_LIST_DIR}/../docker-arm-cross-build-scripts/x-tools/${RPI_CPP_TOOLCHAIN_TRIPLE}/bin")

# Find the C, C++ and Fortran compilers
find_program(RPI_CPP_TOOLCHAIN_C_COMPILER
    ${RPI_CPP_TOOLCHAIN_TRIPLE}-gcc
    PATHS ${RPI_CPP_TOOLCHAIN_TOOLCHAIN_PATHS}
    REQUIRED
)
find_program(RPI_CPP_TOOLCHAIN_CXX_COMPILER
    ${RPI_CPP_TOOLCHAIN_TRIPLE}-g++
    PATHS ${RPI_CPP_TOOLCHAIN_TOOLCHAIN_PATHS}
    REQUIRED
)
find_program(RPI_CPP_TOOLCHAIN_Fortran_COMPILER
    ${RPI_CPP_TOOLCHAIN_TRIPLE}-gfortran
    PATHS ${RPI_CPP_TOOLCHAIN_TOOLCHAIN_PATHS}
    REQUIRED
)
set(CMAKE_C_COMPILER ${RPI_CPP_TOOLCHAIN_C_COMPILER} CACHE PATH "C compiler")
set(CMAKE_CXX_COMPILER ${RPI_CPP_TOOLCHAIN_CXX_COMPILER} CACHE PATH "C++ compiler")
set(CMAKE_Fortran_COMPILER ${RPI_CPP_TOOLCHAIN_Fortran_COMPILER} CACHE PATH "Fortran compiler")

# Find the sysroot
set(CMAKE_SYSROOT 
    "${CMAKE_CURRENT_LIST_DIR}/../docker-arm-cross-build-scripts/sysroot-${RPI_CPP_TOOLCHAIN_TRIPLE}")
set(CMAKE_FIND_ROOT_PATH "${CMAKE_SYSROOT}")

set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)
set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_PACKAGE ONLY)

# Create a symlink to the sysroot so GDB can find it
if (NOT CMAKE_HOST_WIN32)
    execute_process(COMMAND ${CMAKE_COMMAND} -E create_symlink
        ${CMAKE_SYSROOT} ${PROJECT_BINARY_DIR}/sysroot)
endif()

# Find a debugger
find_program(RPI_CPP_TOOLCHAIN_GDB
    ${RPI_CPP_TOOLCHAIN_TRIPLE}-gdb
    gdb-multiarch
    gdb
    PATHS ${RPI_CPP_TOOLCHAIN_TOOLCHAIN_PATHS}
)
# Create a symlink to GDB so other tools can find it more easily
if (RPI_CPP_TOOLCHAIN_GDB AND NOT CMAKE_HOST_WIN32)
    execute_process(COMMAND ${CMAKE_COMMAND} -E create_symlink
        ${RPI_CPP_TOOLCHAIN_GDB} ${PROJECT_BINARY_DIR}/gdb)
endif()