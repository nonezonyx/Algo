#!/bin/sh

# $1 - task name
# $2 - test number

# Create a build directory if it doesn't exist
mkdir -p build

# Change to the build directory
cd build

# Generate Makefile using CMake
cmake ..

# Compile the program
make $1

# Create *_res.cpp file with all custom includes
cpp-merge -o "../contest/$1/${1}_res.cpp" -i ../templates/  "../contest/$1/$1.cpp"

# Run the program with input.txt and redirect the output to out.txt
i=1
while [ $i -le $2 ]
do
    printf "Running test %02d\n" "$i"
    perf stat -e task-clock,cycles,instructions,cache-references,cache-misses,branches,branch-misses,page-faults,faults,migrations ./$1 < ../contest/$1/tests/t$(printf "%02d" "$i")/in.txt > ../contest/$1/tests/t$(printf "%02d" "$i")/out.txt

    # Compare the output with sol.txt
    if diff -q ../contest/$1/tests/t$(printf "%02d" "$i")/out.txt ../contest/$1/tests/t$(printf "%02d" "$i")/sol.txt; then
        printf "Test %02d PASSED\n" "$i"
    else
        printf "Test %02d FAILED\n" "$i"
        diff ../contest/$1/tests/t$(printf "%02d" "$i")/out.txt ../contest/$1/tests/t$(printf "%02d" "$i")/sol.txt
    fi
    i=$((i+1))
done
