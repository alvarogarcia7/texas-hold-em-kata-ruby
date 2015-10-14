#!/bin/bash

while [[ true ]]; do
    clear
    date
    date=$(date --iso-8601=seconds)
    rspec
    echo "$date: $?">>exec.log
    read $i
done