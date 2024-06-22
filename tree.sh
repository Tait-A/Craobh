#!/bin/bash

# This script will print the directory tree of the current directory


### ARGUMENT PROCESSING ###
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

### RECURSIVE FUNCTION TO PRINT TREE ###

print_tree() {
    local directory=$1
    local cur_level=$2
    local cur_prefix=$3

    if [ $cur_level -gt $levels ]; then
        return
    fi

    local prefix=$(printf "%*s" $((((cur_level - 1)) * 4)) "")
    local files = ($(ls -a "$directory"))

    for ((i=0; i<${#files[@]}; i++)); do
        local entry = $files[i]
        if $i == ${#files[@]} - 1; then
            dir_prefix="${prefix}└──"
            local next_prefix="${cur_prefix}    "
        else
            dir_prefix="${prefix}├──"
            local next_prefix="${cur_prefix}│   "
        fi
        if [ -d "$entry" ]; then
            echo "${dir_prefix}$(basename "$entry")"
            print_tree "$entry" $((cur_level + 1)) "$next_prefix"
        else
            echo "${prefix}$(basename "$entry")"
        fi
    done
}

echo "$root_dir"
print_tree "$root_dir" 1 ""