#!/bin/sh
set -eu
cd "$(dirname "$0")"
x86_64-w64-mingw32-gcc -shared -O2 -Wall -Wextra -o src/xgameruntime.dll src/xgameruntime.c
