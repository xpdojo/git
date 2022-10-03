#!/usr/bin/env bash

# ./dummy-commit.sh 1 11
# ./dummy-commit.sh 3
# ./dummy-commit.sh 3 5
for i in `seq $1 $2`
do
  git commit --allow-empty -m "Dummy commit ${i}"
done
