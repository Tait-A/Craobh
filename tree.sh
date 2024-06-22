#!/bin/bash
### ARGUMENT PROCESSING ###
levels=4

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
        echo "$levels"
        echo "$cur_level"
        return
    fi

    local files=($(ls "$directory"))
    local no_dirs=(${#files[@]})
    local let i=0

    for ((i=0; i<no_dirs; i++)); do
        local entry=${files[$i]}  

        if ((i+1 == $no_dirs)); then            
            local dir_prefix="${cur_prefix}└── "
            local next_prefix="${cur_prefix}    "
        else    
            local dir_prefix="${cur_prefix}├── "
            local next_prefix="${cur_prefix}│   "
        fi

        if [ -d "$entry" ]; then
            echo "${dir_prefix}$(basename "$entry")"
            print_tree "$entry" $((cur_level + 1)) "$next_prefix"
        else
            echo "${dir_prefix}$(basename "$entry")"
        fi
    done
}

echo "$root_dir"
print_tree "$root_dir" 1 ""