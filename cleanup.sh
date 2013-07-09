find ./ -iname out.* | xargs -I '{}' mv {} /home/adurvasu/trash
find ./paramsFile.* | xargs cat > parameters.txt
find ./ -iname paramsFile.* | xargs -I '{}' mv {} /home/adurvasu/trash
cat stats.* > semifinal_stats.txt
find ./ -iname stats.* | xargs -I '{}' mv {} /home/adurvasu/trash
python clean_stats.py
mv semifinal_stats.txt /home/adurvasu/trash
