#!/bin/bash

Help()
{
    echo "A simple bash script that replaces the variables in the input file with the corresponding variables provided as script arguments using the built-in envsubst binary"
    echo
    echo "Syntax: $0 [-h] [-d] [-q] -i [input_file] -o [output_file] -p [key=value] [key=value]"
    echo "options:"
    echo "-h               Print this Help."
    echo "-q               Silent mode - nothing will be printed"
    echo "-d               Run in a dry run mode."
    echo "-i input_file    Provide an input file path."
    echo "-o output_file   Provide an output file path, if not specified, input file will be override"
    echo "-p key=value     Provide key value pairs to be passed to the script, multiple pairs can be passes separated by space and double quotes surround \"<key1=value1> <key2=value2>\"."
    echo 
}

while getopts ":hqdi:o:p:" options; do
    case "${options}" in    
    q) 
        silent="true"
        ;;
    d) 
        dry_run="true"
        ;;
    i) 
        input_file="${OPTARG}"
        ;;
    o) 
        output_file="${OPTARG}"
        ;;
    p) 
        # Since getopts doesn't support multiple arguments, we need to use this workaround.
        set -f # disable glob
        IFS=' ' # split on space characters
        # Create an array of parameters to pass to the script
        params=($OPTARG) # use the split+glob operator
        ;;
    h)
        Help; exit 0
        ;;
    *)
        echo "Invalid option -$OPTARG" && exit 1
        ;;
    esac
done

if [ $OPTIND -eq 1 ]; then Help; exit 0; fi

if ! test -f "$input_file"; then
    echo "$input_file doesn't exists." && exit 1
fi

if [ -z "${output_file}" ];then
    output_file=${input_file}
fi

# Set all parameters as an environment variables
for param in "${params[@]}";do
    key=$(echo "${param}" |awk -F= '{print $1}' )
    value=$(echo "${param}" |awk -F= '{print $2}' )
    export "${key}"="${value}"
done

tmpfile=$(mktemp /tmp/vars_replacer.XXXXX)
cat "${input_file}" > "${tmpfile}"

if [ "${dry_run}" == "true" ]; then
     if [ -n "${silent}" ];then
        envsubst < "${tmpfile}" > /dev/null
     else
        echo -e "Running in a dry run mode, no files will be modified\n"
        envsubst < "${tmpfile}"
     fi
else
    envsubst < "${tmpfile}" > "${output_file}"
    if [ -z "${silent}" ];then
      cat "${output_file}"
    fi
fi

rm -fr "${tmpfile}"
