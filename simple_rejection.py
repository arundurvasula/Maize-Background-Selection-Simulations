import math
# script to reject simulated samples based on euclidean distance to observed samples
# TODO parse files, create output file


CUTOFF = 1000 #final number of sims to keep
obs_file = file("./data_file.txt", r)
sim_file = file("./prior_file.txt", r)

sims = []
obs = []
#parse files

def euc_dist(x1, x2, y1, y2):
    """ Returns the euclidean distance between two points."""
    # x1: sim pi
    # y1: obs pi
    # x2: sim tajd
    # y2: obs tajd
    return math.sqrt( (math.pow((x1-y1), 2), math.pow((x2-y2), 2) ) # use math.pow to ensure floating points

dist_list = []

for x in sims:
    # appends estimated parameter, euclidean distance to dist_list 
    dist_list.append((i[0], euc_dist(x[1], x[2], obs[0], obs[1])))


sorted_dist_list = sorted(dist_list, key=lambda tup: tup[1])

# write sorted_dist_list[:CUTOFF] to a file
