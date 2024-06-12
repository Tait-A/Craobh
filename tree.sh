#!/bin/bash

# This script will print the directory tree of the current directory

levels=2

while getopts "l:" opt; do
    case "${opt}" in
        l ) levels="${OPTARG}";;
        \? )
            echo "Usage: cmd [-l max_depth] [directory]"
            exit 1
            ;;
    esac
done

shift $((OPTIND - 1))

if [ $# -gt 0 ]; then
    root_dir="$1"
else
    root_dir="."
fi

print_tree() {
    local directory=$1
    local cur_level=$2

    if [ $cur_level -gt $levels ]; then
        return
    fi

    local prefix=$(printf "%*s" $((((cur_level - 1)) * 4)) "")

    for entry in "$directory"/*; do
        if [ -d "$entry" ]; then
            echo "${prefix}├──$(basename "$entry")"
            print_tree "$entry" $((cur_level + 1))
        else
            echo "${prefix}├──$(basename "$entry")"
        fi
    done
}

echo "$root_dir"
print_tree "$root_dir" 1