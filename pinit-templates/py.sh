#!/usr/bin/env bash

#-Project Structure-------------------------------------------------------------

python3 -m venv ./.__pyenv__
source ./.__pyenv__/bin/activate

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
.__pyenv__/
__pycache__/
" >> .gitignore

