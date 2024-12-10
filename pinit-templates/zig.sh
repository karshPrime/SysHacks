
#!/usr/bin/env bash

#-Project Structure-------------------------------------------------------------

zig init

# Remove Comments
sed "/\/\/.*/d" ./build.zig > ./build.zig.tmp
mv ./build.zig.tmp ./build.zig

sed "/\/\/.*/d" ./build.zig.zon > ./build.zig.zon.tmp
mv ./build.zig.zon.tmp ./build.zig.zon

# Cleaner Template code
rm ./src/main.zig ./src/root.zig


#-Main--------------------------------------------------------------------------

echo "
// main.zig

const std = @import(\"std\");

pub fn main() !void {
    //
}

test \"basic\" {
    //
}
" >> ./main.zig


echo '
const std = @import("std");
const testing = std.testing;
' > ./root.zig


#-CMake Files-------------------------------------------------------------------

echo "
.zig-cache/
zig-out/

bin
" >> .gitignore

