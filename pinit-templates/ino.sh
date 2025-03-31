
#!/usr/bin/env bash

#-Project Structure---------------------------------------------------------------------------------

mkdir src include

#-Main----------------------------------------------------------------------------------------------

echo "
// main.cpp

#include <Arduino.h>

void setup( void )
{
}

void loop( void )
{
}
" > "src/main.cpp"


#-Compile Commands and LSP--------------------------------------------------------------------------

echo "
CompileFlags:
    Add: [
        "-I$(pwd)/src",
        "-I$(pwd)/include",
        "-I/Users/zul/.platformio/packages/framework-arduino-avr/cores/arduino",
        "-I/Users/zul/.platformio/packages/framework-arduino-avr/variants/standard",
        "-I/Users/zul/.platformio/packages/framework-arduino-avr/libraries/EEPROM/src",
        "-I/Users/zul/.platformio/packages/framework-arduino-avr/libraries/HID/src",
        "-I/Users/zul/.platformio/packages/framework-arduino-avr/libraries/SPI/src",
        "-I/Users/zul/.platformio/packages/framework-arduino-avr/libraries/SoftwareSerial/src",
        "-I/Users/zul/.platformio/packages/framework-arduino-avr/libraries/Wire/src",
        "-I/Users/zul/.platformio/packages/toolchain-atmelavr/lib/gcc/avr/7.3.0/include",
        "-I/Users/zul/.platformio/packages/toolchain-atmelavr/lib/gcc/avr/7.3.0/include-fixed",
        "-I/Users/zul/.platformio/packages/toolchain-atmelavr/avr/include",
        "--target=avr-atmel-none",
        "-mmcu=atmega328p"
    ]
" > .clangd

echo "
return {
    build = 'pio check',
    run = 'pio run -t upload',
}
" > "tmux-compile.lua"

#-Git Ignore----------------------------------------------------------------------------------------

echo "
.pio/
.cache/

./tmux-compile.lua
" >> .gitignore

