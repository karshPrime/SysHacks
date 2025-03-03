
#!/usr/bin/env bash

#-Project Structure-------------------------------------------------------------

mkdir src lib include build


#-Main--------------------------------------------------------------------------

echo "
// main.cpp

#include <Arduino.h>

void setup()
{
}

void loop()
{
}
" > "src/main.cpp"

echo "
return {
    build = 'mv ./include/Arduino.h a; pio check; mv ./a ./include/Arduino.h',
    run = 'mv ./include/Arduino.h a; pio run; mv ./a ./include/Arduino.h',
}
" > "tmux-compile.lua"

echo "
#ifndef ARDUINO_STUB_H
#define ARDUINO_STUB_H

#include <stdint.h>

// Pin modes
#define INPUT           0
#define OUTPUT          1
#define INPUT_PULLUP    2

// Logic levels
#define LOW     0
#define HIGH    1

// Arduino standard functions
void pinMode( int pin, int mode );
void digitalWrite( int pin, int value );
void analogWrite( int pin, int value );
int  digitalRead( int pin );
int  analogRead( int pin );
void delay( unsigned long ms );
void delayMicroseconds( unsigned int us );
unsigned long millis();
unsigned long micros();

// Serial (Basic stubs)
class SerialClass {
public:
    void begin(unsigned long baudrate);
    void end();
    int available();
    int read();
    size_t write(uint8_t byte);
    void print(const char* str);
    void println(const char* str);
};

extern SerialClass Serial;

// Other utility functions
void tone(int pin, unsigned int frequency, unsigned long duration = 0);
void noTone(int pin);
void attachInterrupt(int pin, void (*ISR)(void), int mode);
void detachInterrupt(int pin);

#endif
" > "include/Arduino.h"


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

#-Git Ignore--------------------------------------------------------------------

echo "
.cache/
build/
todo/

**/CMakeLists.txt
include/Arduino.h
./tmux-compile.lua
" >> .gitignore

