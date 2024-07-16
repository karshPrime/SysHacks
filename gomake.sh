#!/usr/bin/env bash

# ensure project is initialised with git
if ! git rev-parse --is-inside-work-tree &> /dev/null; then
	echo -e "\e[31mError: \e[0mInitialise git within your project."
	exit 1
fi

BIN=$(git rev-parse --show-toplevel)
PROJECT_TITLE=$(basename "$BIN")
VERSION=""
OS=""
ARCH=""

# clean existing builds
if [ "$1" == "clean" ]; then
	rm -rf bin/*
	exit 0
fi

# parse arguments
while [[ $# -gt 0 ]]; do
	case "$1" in
		-v)
			VERSION="-v$2"
			shift 2
			;;
		windows|darwin|linux|all)
			OS="$1"
			shift
			if [[ "$1" == "arm" || "$1" == "x64" ]]; then
				ARCH="$1"
				shift
			fi
			;;
		*)
			echo "Invalid arguments."
			echo "Usage: gomake [-v version] [win|mac|linux] [arm|x64] | clean"
			exit 1
			;;
	esac
done

# build only for current architecture
if [ -z "$OS" ]; then
	go build -race -v -o "$BIN/bin/$PROJECT_TITLE$VERSION" main.go
	exit 0
fi

# build for specific architecture
build() {
	echo -e "\033[${3}mCompiling ./$PROJECT_TITLE$VERSION-$4\033[0m"

	output="$BIN/bin/$PROJECT_TITLE$VERSION-$4"
	GOOS="$1" GOARCH="$2" go build -race -o "$output" main.go
}

parse_and_build() {
	local os="$1"
	local arch="$2"

	case "$os" in
		windows)
			if [ "$arch" == "arm" ]; then
				build windows arm64 "1;34" "win-arm64.exe"
			elif [ "$arch" == "x64" ]; then
				build windows amd64 "0;34" "win-x64.exe"
			else
				build windows amd64 "0;34" "win-x64.exe"
				build windows arm64 "1;34" "win-arm64.exe"
			fi
			;;
		darwin)
			if [ "$arch" == "arm" ]; then
				build darwin arm64 "1;31" "darwin-arm"
			elif [ "$arch" == "x64" ]; then
				build darwin amd64 "0;31" "darwin-intel"
			else
				build darwin amd64 "0;31" "darwin-intel"
				build darwin arm64 "1;31" "darwin-arm"
			fi
			;;
		linux)
			if [ "$arch" == "arm" ]; then
				build linux arm64 "1;32" "linux-arm64"
			elif [ "$arch" == "x64" ]; then
				build linux amd64 "0;32" "linux-x64"
			else
				build linux amd64 "0;32" "linux-x64"
				build linux arm64 "1;32" "linux-arm64"
			fi
			;;
		all)
			build linux amd64 "0;32" "linux-x64"
			build linux arm64 "1;32" "linux-arm64"
			build darwin amd64 "0;31" "darwin-intel"
			build darwin arm64 "1;31" "darwin-arm"
			build windows amd64 "0;34" "win-x64.exe"
			build windows arm64 "1;34" "win-arm64.exe"
			;;
		*)
			echo "Invalid arguments. Usage: build.sh [-v version] [win | mac [arm] | linux [x64 | arm]] | clean"
			exit 1
			;;
	esac
}

parse_and_build "$OS" "$ARCH"

