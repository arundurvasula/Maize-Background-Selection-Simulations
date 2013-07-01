## Todo

install and use https://github.com/rossibarra/msstatsFST instead of standard msstats

## Example run w/ no selection yet
./sfs_code 2 1 -n 7 17 -t 0.01 -TS 0 0 1 -Td 0 P 1 0.8 -Tg 0 P 1 28 -TE 0.067 

### Params we will draw from distribution but not do ABC:

- theta ( -t 0.01 )

### Params we will do ABC on

- bottleneck size ( -Td 0 P 1 X )

### Params we should try a few different values but no ABC nor distributions

- -Tg 0 P 1 alpha; use final pop size such that alpha=log(X/150000)/(0.03333333) where X is final pop size

