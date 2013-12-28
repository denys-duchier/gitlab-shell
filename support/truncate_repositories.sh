#!/bin/bash

repos_path="$(ruby -ryaml -e 'puts YAML::load_file("/etc/gitlab-shell.yml")["repos_path"]')"

echo "Danger!!! Data Loss"
while true; do
  read -p "Do you wish to delete all directories (except gitolite-admin.git) from $repos_path (y/n) ?:  " yn
  case $yn in
    [Yy]* ) sh -c "find $repos_path/. -maxdepth 1  -not -name 'gitolite-admin.git' -not -name '.' | xargs rm -rf"; break;;
    [Nn]* ) exit;;
    * ) echo "Please answer yes or no.";;
  esac
done
