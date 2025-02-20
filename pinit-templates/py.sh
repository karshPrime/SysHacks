#!/usr/bin/env bash

#-Project Structure-------------------------------------------------------------

python3 -m venv ./.pyenv
source ./.pyenv/bin/activate

touch requirements.txt

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
.pyenv/
__pycache__/
" >> .gitignore

