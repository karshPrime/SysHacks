
#!/usr/bin/env bash

#-Project Structure-------------------------------------------------------------

mkdir -p build docs external src/tests src/utils
touch src/utils/extra.c # need a .c file in utils to compile


#-Main--------------------------------------------------------------------------

echo "
// main.c

// #define NODEBUG

#include <stdio.h>
#include <stdint.h>
#include \"utils/debug.h\" // IWYU pragma: keep

int main(int argc, char *argv[])
{
    return 0;
}
" > "src/main.c"

echo '
// Fork of Zed Shaw debug macro

#pragma once

// #define NODEBUG

#include <stdio.h>
#include <errno.h>
#include <string.h>

#if !defined(_WIN32) && !defined(_WIN64)
    #define TERM_RED      "\033[31m" // Error
    #define TERM_BLUE     "\033[34m" // Debug
    #define TERM_YELLOW   "\033[33m" // Warning
    #define TERM_GREEN    "\033[32m" // File Name + Line Number
    #define TERM_GRAY     "\033[36m" // Extra Args
    #define TERM_RESET    "\033[0m"
#else
    #define TERM_RED     ""
    #define TERM_BLUE    ""
    #define TERM_YELLOW  ""
    #define TERM_GREEN   ""
    #define TERM_GRAY    ""
    #define TERM_RESET   ""
#endif

#ifdef NODEBUG
    #define debug(M, ...)

    #define log_error(M, ...) fprintf(stderr, "%s[ERROR]%s " M "\n%s",\
        TERM_RED, TERM_GRAY, ##__VA_ARGS__, TERM_RESET)

    #define log_warn(M, ...) fprintf(stderr, "%s[WARN]%s " M "\n%s",\
        TERM_YELLOW, TERM_GRAY, ##__VA_ARGS__, TERM_RESET)

    #define log_info(M, ...) fprintf(stderr, "%s[INFO]%s " M "\n%s",\
        TERM_BLUE, TERM_GRAY, ##__VA_ARGS__, TERM_RESET)

#else
    #define debug(M, ...) fprintf(stderr, "%s[DEBUG]%s (%s:%d)%s " M "\n%s",\
        TERM_BLUE, TERM_GREEN, __FILE__, __LINE__, TERM_GRAY, ##__VA_ARGS__, TERM_RESET)

    #define clean_errno() (errno == 0 ? "None" : strerror(errno))

    #define log_error(M, ...) fprintf(stderr,\
        "%s[ERROR]%s (%s:%d: errno: %s)%s " M "\n%s", TERM_RED, TERM_GREEN, __FILE__, __LINE__,\
        clean_errno(), TERM_GRAY, ##__VA_ARGS__, TERM_RESET)

    #define log_warn(M, ...) fprintf(stderr,\
        "%s[WARN]%s (%s:%d: errno: %s)%s " M "\n%s", TERM_YELLOW, TERM_GREEN, __FILE__, __LINE__,\
        clean_errno(), TERM_GRAY, ##__VA_ARGS__, TERM_RESET)

    #define log_info(M, ...) fprintf(stderr, "%s[INFO]%s (%s:%d)%s " M "\n%s",\
        TERM_BLUE, TERM_GREEN, __FILE__, __LINE__, TERM_GRAY, ##__VA_ARGS__, TERM_RESET)

#endif

#define check(A, M, ...) if(!(A)) { log_error(M, ##__VA_ARGS__); errno=0; goto error; }
#define sentinel(M, ...) { log_error(M, ##__VA_ARGS__); errno=0; goto error; }
#define check_mem(A) check((A), "Out of memory.")
#define check_debug(A, M, ...) if(!(A)) { debug(M, ##__VA_ARGS__); errno=0; goto error; }
' > "src/utils/debug.h"


#-CMake Files-------------------------------------------------------------------

echo "
cmake_minimum_required(VERSION 4.0)
project($PROJECT_TITLE VERSION 0.0 LANGUAGES C)

add_subdirectory(src)
add_subdirectory(external)
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY \${CMAKE_BINARY_DIR}/build)
" > CMakeLists.txt


echo "
#
# Project Modules

# Miscellaneous code and shared components used by different modules
file(GLOB_RECURSE UTILS_SOURCES
    utils/*.h
    utils/*.c
)
add_library(utils STATIC \${UTILS_SOURCES})

#
# Create Executable

add_executable($PROJECT_TITLE main.c)
target_link_libraries($PROJECT_TITLE PRIVATE utils)
" > ./src/CMakeLists.txt


echo "
cmake_minimum_required(VERSION 4.0)
" > ./external/CMakeLists.txt


#- build directory--------------------------------------------------------------

cd ./build
cmake ..
make
cmake -DCMAKE_EXPORT_COMPILE_COMMANDS=ON ..
cd ..

ln -s "./build/src/$PROJECT_TITLE" "./bin"


#-Git Ignore--------------------------------------------------------------------

echo "
.cache/
build/
" >> .gitignore

