#!/usr/bin/env bash
set -eo pipefail

help() {
  echo -e "\n\e[32m$(basename "$0")\e[39m allows you to create Terraform output DSL from resources found in your code."
  echo -e "It currently supports Terraform DSL only, because that's what I'm using. \xf0\x9f\x98\x89"
  echo -e "\n$(basename "$0") prints to stdout to allow you to plan and then redirect the code as wanted."
  echo -e "\nExample: $(basename "$0") plan <terraform_dir>\n"
}

create_output() {
  local output
  output="$(grep -hr "^resource" "$1"/*.tf)"
  output="$(echo -n "$output" | sed -e 's/^resource\ "//g' -e 's/"\ \"/./g' -e 's/"\ {//g')"
  echo "$output"
}

print_error() {
  >&2 echo "[ERROR] $1" ; exit 1
}

case $1 in
  plan)
    [[ -r $2 ]] || print_error "Nothing readable passed"
    grep -qhr "^resource" "$2"/*.tf 2>&1 /dev/null || print_error "No Resources found in $2"
    OUTPUT_ARRAY=( $(create_output "$2") )
    LAST_LINE_NUM=${#OUTPUT_ARRAY[@]}
    for i in "${OUTPUT_ARRAY[@]}"; do
      echo "output \"$i\" {"
      echo "  value = \"\${""$i"".id}"'"'
      echo "}"
      [[ ! "${OUTPUT_ARRAY[$((LAST_LINE_NUM - 1))]}" == "$i" ]] && echo
    done
  ;;
  *)
    help
  ;;
esac
