#collect stats
cat ./raw_data/slim-stats* | awk '$1 ~ /[0-9]/ {print}' | awk '{print $5, "\t", $8}' > ./data/stats.txt
#collect gamma params
awk '{print $1, "\t", $2}' ./raw_data/gamma_params.* > ./data/gamma_params.txt

#create prior file
paste ./data/gamma_params.txt ./data/stats.txt | grep -v 'nan' > ./data/prior_file.txt

# take the log of the prior file and the log of the data file
awk '{print log(-1*$1), log($2), $3, $4;}' ./data/prior_file.txt > ./data/prior_file_log.txt

~/ABCreg/reg -T -P 2 -S 2 -p ./data/prior_file_log.txt -d ../data/data-genic-pi-tajd.txt -b gamma -t 0.01