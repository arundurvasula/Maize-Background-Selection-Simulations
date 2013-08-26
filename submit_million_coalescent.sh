#!/bin/bash

for i in {1..2}
do
    qsub ./coalescent-sims/coalescent_sims.sh
done
