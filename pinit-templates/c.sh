
#!/usr/bin/env bash

#-Project Structure-------------------------------------------------------------

mkdir src obj lib include build


#-Main--------------------------------------------------------------------------

echo "
// main.c

// #include \"Debug.h\"

int main( int argc, char *argv[] )
{
    return 0;
}
" > "src/main.c"

echo '
// Fork of Zed Shaw debug macro

#pragma once

// #define PRODUCTION

#include <stdio.h>
#include <errno.h>
#include <string.h>

#if !defined(_WIN32) && !defined(_WIN64)
    #define TERM_RED      "\033[31m" // Error
    #define TERM_BLUE     "\033[34m" // Debug
    #define TERM_YELLOW   "\033[33m" // Warning
    #define TERM_GREEN    "\033[32m"
    #define TERM_GRAY     "\033[36m"
    #define TERM_RESET    "\033[0m"
#else
    #define TERM_RED     ""
    #define TERM_BLUE    ""
    #define TERM_YELLOW  ""
    #define TERM_GREEN   ""
    #define TERM_GRAY    ""
    #define TERM_RESET   ""
#endif

#ifdef PRODUCTION
    #define debug( M, ... )

    #define log_error( M, ... ) fprintf( stderr, "%s[ERROR]%s " M "\n%s",\
        TERM_RED, TERM_GRAY, ##__VA_ARGS__, TERM_RESET )

    #define log_warn( M, ... ) fprintf(stderr, "%s[WARN]%s " M "\n%s",\
        TERM_YELLOW, TERM_GRAY, ##__VA_ARGS__, TERM_RESET )

    #define log_info( M, ... ) fprintf( stderr, "%s[INFO]%s " M "\n%s",\
        TERM_BLUE, TERM_GRAY, ##__VA_ARGS__, TERM_RESET )

#else
    #define debug( M, ... ) fprintf( stderr, "%s[DEBUG]%s (%s:%d)%s " M "\n%s",\
        TERM_BLUE, TERM_GREEN, __FILE__, __LINE__, TERM_GRAY, ##__VA_ARGS__, TERM_RESET )

    #define clean_errno() ( errno == 0 ? "None" : strerror(errno) )

    #define log_error( M, ... ) fprintf( stderr,\
        "%s[ERROR]%s (%s:%d: errno: %s)%s " M "\n%s", TERM_RED, TERM_GREEN, __FILE__, __LINE__,\
        clean_errno(), TERM_GRAY, ##__VA_ARGS__, TERM_RESET )

    #define log_warn( M, ... ) fprintf(stderr,\
        "%s[WARN]%s (%s:%d: errno: %s)%s " M "\n%s", TERM_YELLOW, TERM_GREEN, __FILE__, __LINE__,\
        clean_errno(), TERM_GRAY, ##__VA_ARGS__, TERM_RESET )

    #define log_info( M, ... ) fprintf( stderr, "%s[INFO]%s (%s:%d)%s " M "\n%s",\
        TERM_BLUE, TERM_GREEN, __FILE__, __LINE__, TERM_GRAY, ##__VA_ARGS__, TERM_RESET )

#endif

#define check( A, M, ... ) if( !(A) ) { log_error( M, ##__VA_ARGS__ ); errno=0; goto error; }
#define sentinel( M, ... ) { log_error( M, ##__VA_ARGS__ ); errno=0; goto error; }
#define check_mem( A ) check( (A), "Out of memory." )
#define check_debug( A, M, ... ) if( !(A) ) { debug( M, ##__VA_ARGS__ ); errno=0; goto error; }
' > "include/Debug.h"


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

