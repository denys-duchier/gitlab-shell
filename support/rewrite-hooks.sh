#!/bin/bash

# $1 is an optional argument specifying the location of the repositories directory.
# If no argument is provided then path is readed from /etc/gitlab-shell.yml

base_path="$(realpath `dirname $(readlink -f "$0")`/..)"
repos_path="$(ruby -ryaml -e 'puts YAML::load_file("/etc/gitlab-shell.yml")["repos_path"]')"
src=${1:-"$repos_path"}

function create_link_in {
  ln -s -f "$base_path/hooks/update" "$1/hooks/update"
}

for dir in `ls "$src/"`
do
  if [ -d "$src/$dir" ]; then
    if [[ "$dir" =~ ^.*\.git$ ]]
    then
      create_link_in "$src/$dir"
    else
      for subdir in `ls "$src/$dir/"`
      do
        if [ -d "$src/$dir/$subdir" ] && [[ "$subdir" =~ ^.*\.git$ ]]; then
          create_link_in "$src/$dir/$subdir"
        fi
      done
    fi
  fi
done
