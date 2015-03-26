require 'nsq-cluster'
require 'nsq'

# Start a cluster of 3 nsqd's and 2 nsqlookupd's.
# This will block execution until all components are fully up and running.
cluster = NsqCluster.new(nsqd_count: 3, nsqlookupd_count: 2)

# Stop the 3rd nsqd instance and wait for it to come down.
cluster.nsqd.last.stop

# Start it back up again and wait for it to fully start.
cluster.nsqd.last.start

# Tear down the whole cluster.
cluster.destroy