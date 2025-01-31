
#!/usr/bin/env bash

#-Project Structure-------------------------------------------------------------

cargo init --vcs none


#-Git Ignore--------------------------------------------------------------------

echo "
Cargo.lock
target/
" >> .gitignore

