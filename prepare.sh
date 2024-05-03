#!/bin/sh

start_letter=$1
end_letter=$2

start_ascii=$(printf "%d" "'$start_letter")
end_ascii=$(printf "%d" "'$end_letter")

i=$start_ascii
while [ $i -le $end_ascii ]
do
    letter=$(printf \\$(printf "%o" $i))
    folder_name="contest/$letter"
    cpp_file="$folder_name/$letter.cpp"
    tests_folder="$folder_name/tests"

    # Create the folder
    mkdir -p "$folder_name"

    # Create the C++ file
    touch "$cpp_file"

    # Create the tests folder
    mkdir -p "$tests_folder"

    # Create the test files
    j=1
    while [ $j -le 2 ]
    do
        test_folder="$tests_folder/t$(printf "%02d" $j)"
        in_file="$test_folder/in.txt"
        sol_file="$test_folder/sol.txt"

        # Create the test folder
        mkdir -p "$test_folder"

        # Create the input and solution files
        touch "$in_file"
        touch "$sol_file"

        j=$((j+1))
    done

    i=$((i+1))
done
