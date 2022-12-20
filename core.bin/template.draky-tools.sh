#!/usr/bin/env bash

while getopts ":ht:p:" opt; do
  case $opt in
    t)
      TEMPLATE="${OPTARG}"
    ;;
    h)
      printf "%s\n" "  Usage: $0 <flags>"
      printf "%s\n" ""
      printf "%s\n" "  Available flags:"
      printf "%s\n" "  -t    Path to template to render."
      printf "%s\n" "  -p    Prefix of variables searched for replacement."
      printf "%s\n" "  -h    This help."
      exit 0;
    ;;

    \?)
      echo "Unknown flag has been used: -$OPTARG" >&2
      exit 1
      ;;
    :)
      echo "Option -$OPTARG requires an argument." >&2
      exit 1
      ;;
  esac
done

shift "$((OPTIND-1))"

: ${TEMPLATE:?"You need to provide a template with -t flag."}

ARRAY=()
while read p; do
  ARRAY+=("\$${p}")
done < <(env | sed -rn "s/(${DRAKY_TEMPLATE_VAR_PREFIX:-DRAKY_OVERRIDE_}\w+)=.*/\1/p")

ALL_VARIABLES=$(IFS=, ; echo "${ARRAY[*]}")

echo "$(envsubst "${ALL_VARIABLES}" < "${TEMPLATE}")"
