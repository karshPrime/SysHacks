
#!/usr/bin/env bash

#-Project Structure-------------------------------------------------------------

mkdir src obj lib include build


#-Main--------------------------------------------------------------------------

echo "
// main.c

// #include <stdio.h>
#include \"Aliases.h\"

int main( int argc, str argv[] )
{
    return 0;
}
" > "src/main.c"

echo "
// Aliases

typedef enum { false, true } bool;
typedef unsigned int uint;
typedef char* str;

" > "include/Aliases.h"


#-CMake Files-------------------------------------------------------------------

echo "
cmake_minimum_required( VERSION 3.30 )

project( $PROJECT_TITLE VERSION 1.0 LANGUAGES C )

include_directories( include )
add_subdirectory( src )

set( CMAKE_RUNTIME_OUTPUT_DIRECTORY \${CMAKE_BINARY_DIR}/build )
" > CMakeLists.txt


echo "
add_executable( \${PROJECT_NAME}
    main.c
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

