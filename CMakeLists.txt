cmake_minimum_required(VERSION 3.16)
project(contest)

set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -O2 -DDEBUG -fsanitize=address,undefined -fno-omit-frame-pointer -std=gnu++17")
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

# Add the templates directory to the include paths
include_directories(templates)
include_directories(.)

file(GLOB_RECURSE CONTEST_SOURCES "contest/*.cpp")
foreach(file ${CONTEST_SOURCES})
    get_filename_component(TASK_NAME ${file} NAME_WE)
    add_executable(${TASK_NAME} ${file})
endforeach()
