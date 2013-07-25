import math
# script to reject simulated samples based on euclidean distance to observed samples
# TODO parse files


CUTOFF = 1000 #final number of sims to keep
obs_file = file("./data_file.txt", "r")
sims_file = file("./prior_file.txt", "r")
out_file = file("./accepted_sim.txt", "w")
sims = []
obs = []
#parse files
for line in sims_file:
    temp = line.split("\t")
    temp[-1] = temp[-1].strip("\n")
    sims.append((float(temp[0]),float(temp[1]),float(temp[2])))

for line in obs_file:
    temp = line.split(" ")
    temp[-1] = temp[-1].strip("\n")
    obs.append((float(temp[0]),float(temp[1])))

def euc_dist(x1, x2, y1, y2):
    """ Returns the euclidean distance between two points."""
    # x1: sim pi
    # y1: obs pi
    # x2: sim tajd
    # y2: obs tajd
    point1 = x1-y1
    point2 = x2-y2
    squared1 = math.pow(point1, 2)
    squared2 = math.pow(point2, 2)
    temp1 = squared1+squared2
    ans = math.sqrt(temp1)
    return ans

dist_list = []
print obs
for x in sims:
    # appends estimated parameter, euclidean distance to dist_list 
    dist_list.append((x[0], euc_dist(x[1], x[2], obs[0][0], obs[0][1])))


sorted_dist_list = sorted(dist_list, key=lambda tup: tup[1])

# write sorted_dist_list[:CUTOFF] to a file
for i in xrange(0, (CUTOFF-1)):
    out_file.write(str(sorted_dist_list[i][0]) + "\n")
