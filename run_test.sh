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

# Clear *_res.cpp file
echo "" > "../contest/$1/${1}_res.cpp"

# Create *_res.cpp file with all custom includes
grep -r -h '#include "' ../contest/$1/$1.cpp | grep -v '<' | cut -d'"' -f2 | while read line
do
    cat "../templates/$line" >> "../contest/$1/${1}_res.cpp"
done

# Append the original C++ code to *_res.cpp
cat "../contest/$1/$1.cpp" >> "../contest/$1/${1}_res.cpp"

# Replace includes from templates with the actual content of the files
sed -i '/#include "/{s/^.*"//;s/".*$//;r ../templates/'"../contest/$1/${1}_res.cpp" -e 'd}' "../contest/$1/${1}_res.cpp"

# Remove original includes from templates
sed -i '/#include "/d' "../contest/$1/${1}_res.cpp"

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
