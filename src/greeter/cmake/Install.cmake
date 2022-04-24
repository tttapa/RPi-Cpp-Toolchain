include(GNUInstallDirs)

set(INSTALL_CMAKE_DIR "${CMAKE_INSTALL_LIBDIR}/cmake/greeter")

# Add the greeter library to the "export-set", install the library files
install(TARGETS greeter
    EXPORT greeterTargets
    LIBRARY DESTINATION "${CMAKE_INSTALL_LIBDIR}"
        COMPONENT shlib
    ARCHIVE DESTINATION "${CMAKE_INSTALL_LIBDIR}" 
        COMPONENT lib)

# Install the header files
install(DIRECTORY "${CMAKE_CURRENT_SOURCE_DIR}/include/"
    DESTINATION "${CMAKE_INSTALL_INCLUDEDIR}"
        COMPONENT dev
    FILES_MATCHING REGEX "/.*\.[hti](pp)?$")

# Install the export set for use with the install tree
install(EXPORT greeterTargets 
    FILE greeterTargets.cmake
    DESTINATION "${INSTALL_CMAKE_DIR}" 
        COMPONENT dev
    NAMESPACE ${PROJECT_NAME}::)

# Generate the config file that includes the exports
include(CMakePackageConfigHelpers)
configure_package_config_file(
    "${CMAKE_CURRENT_SOURCE_DIR}/cmake/Config.cmake.in"
    "${PROJECT_BINARY_DIR}/greeterConfig.cmake"
    INSTALL_DESTINATION "${INSTALL_CMAKE_DIR}"
    NO_SET_AND_CHECK_MACRO
    NO_CHECK_REQUIRED_COMPONENTS_MACRO)
write_basic_package_version_file(
    "${PROJECT_BINARY_DIR}/greeterConfigVersion.cmake"
    VERSION "${PROJECT_VERSION}"
    COMPATIBILITY SameMajorVersion)

# Install the greeterConfig.cmake and greeterConfigVersion.cmake files
install(FILES
    "${PROJECT_BINARY_DIR}/greeterConfig.cmake"
    "${PROJECT_BINARY_DIR}/greeterConfigVersion.cmake"
    DESTINATION "${INSTALL_CMAKE_DIR}" 
        COMPONENT dev)

# Add all targets to the build tree export set
export(EXPORT greeterTargets
    FILE "${PROJECT_BINARY_DIR}/greeterTargets.cmake"
    NAMESPACE ${PROJECT_NAME}::)