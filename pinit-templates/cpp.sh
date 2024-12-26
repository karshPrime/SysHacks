
#!/usr/bin/env bash

#-Project Structure-------------------------------------------------------------

mkdir src obj lib include build


#-Main--------------------------------------------------------------------------

echo "
// main.cpp

// #include <iostream>

int main( int argc, char* argv[] )
{
    return 0;
}
" > "src/main.cpp"


#-CMake Files-------------------------------------------------------------------

echo "
cmake_minimum_required(VERSION 3.31)

project($PROJECT_TITLE VERSION 1.0 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

include_directories(include)
add_subdirectory(src)

set(CMAKE_RUNTIME_OUTPUT_DIRECTORY \${CMAKE_BINARY_DIR}/build)
" > CMakeLists.txt


echo "
add_executable(\${PROJECT_NAME} main.cpp)

target_include_directories(\${PROJECT_NAME} PUBLIC \${PROJECT_SOURCE_DIR}/include)
" > ./src/CMakeLists.txt


#- build directory--------------------------------------------------------------

cd ./build; cmake ..; make
cmake -DCMAKE_EXPORT_COMPILE_COMMANDS=ON ..
rm ./CMakeCache.txt
cd ..

ln -s "./build/src/$PROJECT_TITLE" "./bin"



#-Git Ignore--------------------------------------------------------------------

echo "
.cache/
build/
todo/
obj/
" >> .gitignore

