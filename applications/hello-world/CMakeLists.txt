# Add a new executable with the name "hello-world" that is compiled from the
# source file "hello-world.cpp".
add_executable(hello-world
    hello-world.cpp
)

# The "hello-world" program requires the "greeter" library.
# The target_link_libraries command ensures that all compiler options such as
# include paths are set correctly, and that the executable is linked with the
# library as well.
target_link_libraries(hello-world 
    greeter
)