# Install the hello-world program
include(GNUInstallDirs)
install(TARGETS hello-world
        RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR})
