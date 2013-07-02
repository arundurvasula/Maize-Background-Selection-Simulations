## Todo

install and use https://github.com/rossibarra/msstatsFST instead of standard msstats

## Example runs 

- ./sfs_code 1 1 -n 17 --popSize 500 -r 0.01 -t 0.01 -Td 0 0.8 -Tg 0 60 -TE 0.067 --length 1 10000 --annotate N
- /sfs_code 1 1 -n 17 --popSize 500 -r 0.01 -t 0.01 -Td 0 0.8 -Tg 0 60 -TE 0.067 --length 1 10000 --annotate C --selDistType 2 0 blah blah 1 X


## Params

### Draw from distribution but not do ABC:

- theta ( -t X )
 	- draw from observed values of teosinte pi from Hufford et al. 2012

- rho: set equal to theta

### Do ABC

- bottleneck size ( -Td 0 P 1 X )
	- start w/ X~runif(1,0,1)


- mean of exponential for selection --selDistType 2 0 blah blah 1 X 
	- start with X~runif(1,0,1)

### Try a few different values but no ABC 

- -Tg 0 P 1 alpha; use final pop size such that alpha=log(X/150000)/(0.03333333) where X is final pop size
- try final popsizes of 10^5, 10^7, 10^9

## Popsize check for paranoia

<img src="./popsize_tajd.png" width="250px" />
<img src="./popsize_pi.png" width="250px" />
<img src="./popsize_hprime.png" width="250px" />
