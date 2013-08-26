#!/bin/bash

for i in {1..2}
do
    qsub ./forward-sims/forward_sims.sh
done
