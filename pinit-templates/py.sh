#!/usr/bin/env bash

#-Project Structure-------------------------------------------------------------

python3 -m venv ./.venv


#-Main--------------------------------------------------------------------------

echo "
# main.py

def main():
    pass

if __name__ == \"__main__\":
    main()
" > main.py


#-Git Ignore--------------------------------------------------------------------

echo "
.venv/
__pycache__/
" >> .gitignore

