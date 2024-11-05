#!/usr/bin/env bash

# This script automates project setup tasks, including directory creation, Git
# initialisation, README file generation and commit, language-specific file 
# setup, and .gitignore configuration. 

# Project Description
LANGUAGE="${1##*.}"
TITLE="${1%.*}"

# User Info
GIT_USER="karshPrime"

# Directories
TEMPLATE="$HOME/Projects/SysHacks/Makefiles/"  # default makefile directory
LICENSE="$HOME/Projects/LICENSE"    # license file; can be upgraded for dynamic 
                                    # licenses per project
TMUXIFIER_LAYOUT="$HOME/.config/tmux/tmuxifier/layouts"


# Get Started -----------------------------------------------------------------

echo "Initializing Project at $(pwd)/$TITLE"

mkdir "$TITLE"
cd "$TITLE"

# Initialize git & Commit license
git init --quiet
cp $LICENSE .
git add LICENSE
git commit -m "Apache 2.0"

# Create .gitignore
echo -e "\n# .gitignore\n\n**/.DS_Store\n" > .gitignore

# Write & Commit basic readme
echo -e "# $TITLE\n\n" > README.md
git add README.md 
git commit -m "readme"

# Language specific actions ---------------------------------------------------

# Go
if [ "$LANGUAGE" = "go" ]; then
    echo -e "go.sum\ngo.mod\n\$TITLE\nbin/\n" >> .gitignore
    go mod init "github.com/$GIT_USER/$TITLE"
    mkdir cmd bin
    echo -e "\npackage main\n\nimport (\n\
    //\"github.com/$GIT_USER/$TITLE/cmd\"\n)\n\nfunc main() {\n\n}\n" > main.go


# C/C++
elif [ "$LANGUAGE" = "c" ] || [ "$LANGUAGE" = "cpp" ]; then
    cp $TEMPLATE/$LANGUAGE ./Makefile
    git add Makefile 
    git commit -m "Makefile"
    mkdir src obj lib
    echo -e "\nint main() {\n    return 0;\n}\n" > "src/main.$LANGUAGE"
    echo -e "bin\nobj/\n" >> .gitignore

# Lua
elif [ "$LANGUAGE" = "lua" ]; then
    mkdir -p "lua/$TITLE"
    touch "lua/$TITLE/init.lua"
    echo -e "[format]\nindent=4\nline_width=80\nquote_style="Auto"">stylua.toml

# Python
elif [ "$LANGUAGE" = "py" ]; then
    python3 -m venv ./.venv
    echo -e ".venv/\n__pycache__/\n" >> .gitignore
    echo -e "\n# $TITLE\n\ndef main():\n    pass\n\nif __name__ == \"__main__\":
    main()\n" > main.py

# Rust
elif [ "$LANGUAGE" = "rs" ]; then
    cargo init --vcs none
    echo -e "Cargo.lock\ntarget/\n" >> .gitignore

elif [ "$LANGUAGE" == "iot" ]; then
    $EDITOR -c "Pioinit"
    echo -e ".pio/\n" >> .gitignore

# Zig
elif [ "$LANGUAGE" = "zig" ]; then
    zig init

    # Remove Comments
    sed "/\/\/.*/d" ./build.zig > ./build.zig.tmp
    mv ./build.zig.tmp ./build.zig
    sed "/\/\/.*/d" ./build.zig.zon > ./build.zig.zon.tmp
    mv ./build.zig.zon.tmp ./build.zig.zon

    # Cleaner Template code
    cd ./src/; rm ./main.zig ./root.zig
    echo -e '\n// Main.zig\n\nconst std = @import("std");\n' > ./main.zig
    echo -e 'pub fn main() !void {\n}\n\ntest "basic" {\n}\n' >> ./main.zig
    echo -e '\nconst std = @import("std");\nconst testing = std.testing;\n' > \
        ./root.zig

    cd ..
    echo -e ".zig-cache/\n\nzig-out/\nbin\n\n" >> .gitignore

# Java
elif [ "$LANGUAGE" = "java" ]; then
	yes no | gradle init \
		--type java-application \
		--dsl kotlin \
		--test-framework junit-jupiter \
		--package "$TITLE" \
		--project-name my-project \
		--no-split-project \
		--java-version 21 \
		--overwrite


	# use $TITLE as main class instead of App.Java

	cd "./app/src/main/java/$TITLE"
	sed "s/App/$TITLE/g" "App.java" > "$TITLE.java"
	rm App.java
	cd -

	cd "./app/src/test/java/$TITLE"
	sed "s/App/$TITLE/g" "AppTest.java" > ""$TITLE"Test.java"
	rm AppTest.java
	cd -

	sed "s/$TITLE.App/$TITLE.$TITLE/g" ./app/build.gradle.kts > \
        ./build.gradle.kts.tmp
	mv ./build.gradle.kts.tmp ./app/build.gradle.kts

	# update .gitignore
	echo -e "\n**/gradlew*\n**/*gradle*\n**/.settings\n\n**/*.class
\n*/app/.classpath\n*/app/.project\n*/.project\n" >> .gitignore
fi

# Commit Template
git add -A
git commit -m "project init"

# FLags Actions ---------------------------------------------------------------

# Check if the -g flag is present
contains_flag() {
    local flag="-$1"
    shift # Remove the first argument which is the flag we are checking for
    for arg in "$@"; do
        [[ "$arg" == "$flag" ]] && return 0
    done
    return 1
}

# Push to GitHub
# This step presumes a repo for this project has been already created on
# github. Else extent this portion to include gh-cli to create a repo from
# here as well.
# It is also presumed that the said repo is of the same name as $TITLE

if contains_flag "g" "$@"; then
    git remote add origin "git@github.com:$GIT_USER/$TITLE.git"
    git push -u origin main
fi


# Set up Tmuxifier Layout 

if contains_flag "t" "$@"; then
    # setting up basic template
    echo -e "session_root \"$(pwd)\"\n" > "$TITLE.session.sh"
    echo -e "if initialize_session \"$TITLE\"; then\n" >> "$TITLE.session.sh"
    echo -e "fi\n\nfinalize_and_go_to_session\n" >> "$TITLE.session.sh"

    $EDITOR "$TITLE.session.sh"
    git add "$TITLE.session.sh"
    git commit -m "tmuxifier layout"
    ln -s "$(pwd)/$TITLE.session.sh" $TMUXIFIER_LAYOUT
fi

