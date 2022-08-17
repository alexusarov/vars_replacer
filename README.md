# vars_replacer

A simple bash script that replaces the variables in the input file with the corresponding variables provided as script arguments using the bash built-in `envsubst` binary

This script might be useful to dynamically modify YAML manifests for kubernetes.

## Installation
```
git https://github.com/alexusarov/vars_replacer.git
cd vars_replacer
```

## Description

```
Syntax: ./vars_replacer.sh [-h] [-d] [-q] -i [input_file] -o [output_file] -p [key=value] [key=value]
options:
-h               Print this Help.
-q               Silent mode - nothing will be printed
-d               Run in a dry run mode.
-i input_file    Provide an input file path.
-o output_file   Provide an output file path, if not specified, input file will be override
-p key=value     Provide key value pairs to be passed to the script, multiple pairs can be passes separated by space and double    quotes surround "<key1=value1> <key2=value2>".
```

## Usage
```
./vars_replacer.sh -i [input_file] -o [output_file] -p "[key=value] [key=value]"
```

Combine with kubectl

```
./vars_replacer.sh -i [input_file] -p "[key=value] [key=value]" |kubectl apply -f - 
```

## Example

Input file content: input_file.yml

```
apiVersion: $APIVERSION
name: $NAME
version: $VERSION
```

Command to execute:
```
 ./vars_replacer.sh -i input_file.yml -o output_file.yml -p "APIVERSION=v2 NAME=root VERSION=1.0.0"
```

Output file content: output_file.yml

```
apiVersion: v2
name: root
version: 1.0.0
```



