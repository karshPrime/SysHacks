
#!/usr/bin/env bash

#-Project Structure-------------------------------------------------------------

mkdir cmd bin

go mod init "github.com/$GIT_USER/$PROJECT_TITLE"


#-Main--------------------------------------------------------------------------

echo "
// main.go

package main

import (
    // \"fmt\"
    // \"github.com/$GIT_USER/$PROJECT_TITLE/cmd\"
)

func main() {
    //
}
" > main.go


#-Git Ignore--------------------------------------------------------------------

echo "
go.sum
go.mod
$PROJECT_TITLE

bin/
" >> .gitignore

