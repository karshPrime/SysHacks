
#!/usr/bin/env bash

#-Project Structure-------------------------------------------------------------

mkdir src obj lib include build


#-Main--------------------------------------------------------------------------

echo "
// main.cpp

#include \"Defines.h\"

int main( int argc, str argv[] )
{
    return 0;
}
" > "src/main.cpp"


echo "
// Defines

#pragma once

#include <iostream>

#if !defined(_WIN32) && !defined(_WIN64)
    #define TERM_RED     \"\033[31m\" <<
    #define TERM_BLUE    \"\033[34m\" <<
    #define TERM_GRAY    \"\033[36m\" <<
    #define TERM_YELLOW  \"\033[33m\" <<
    #define TERM_RESET   \"\033[0m\"  <<
#else
    #define TERM_RED     \"\"  <<
    #define TERM_BLUE    \"\"  <<
    #define TERM_GRAY    \"\"  <<
    #define TERM_YELLOW  \"\"  <<
    #define TERM_RESET   \"\"  <<
#endif

#define ERROR std::cerr << TERM_RED    \"ERROR: \"   << TERM_GRAY
#define WARN  std::cerr << TERM_YELLOW \"WARNING: \" << TERM_GRAY
#define LOG   std::cout << TERM_BLUE   \"LOG: \"     << TERM_GRAY
#define ENDLOG << TERM_RESET std::endl;

using std::string;
using std::ostream;
using str = char*;
using uint = unsigned int;
" > "include/Defines.h"


#-CMake Files-------------------------------------------------------------------

echo "
cmake_minimum_required( VERSION 3.30 )

project( $PROJECT_TITLE VERSION 1.0 LANGUAGES CXX )

set( CMAKE_CXX_STANDARD 20 )
set( CMAKE_CXX_STANDARD_REQUIRED ON )

include_directories( include )
add_subdirectory( src )

set( CMAKE_RUNTIME_OUTPUT_DIRECTORY \${CMAKE_BINARY_DIR}/build )
" > CMakeLists.txt


echo "
add_executable( \${PROJECT_NAME}
    main.cpp
)

target_include_directories( \${PROJECT_NAME} PUBLIC \${PROJECT_SOURCE_DIR}/include )
" > ./src/CMakeLists.txt


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
todo/
obj/
" >> .gitignore

