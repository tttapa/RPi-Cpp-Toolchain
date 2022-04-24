cmake_minimum_required(VERSION 3.20)
project(greeter VERSION 1.0.0 LANGUAGES CXX)
enable_testing()

# Libraries
add_subdirectory("src")

# Applications
add_subdirectory("applications")