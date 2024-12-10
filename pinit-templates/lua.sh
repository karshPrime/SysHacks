#!/usr/bin/env bash

#-Project Structure-------------------------------------------------------------

mkdir -p "lua/$PROJECT_TITLE"
touch "lua/$PROJECT_TITLE/init.lua"

echo "
[format]
indent=4
line_width=80
quote_style="Auto"
" > stylua.toml

