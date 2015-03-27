require 'nsq'

# Seed NSQ with data

# Each message in the queue is a JSON string with a GUID video_id attribute,
# which is used by the client to identify a video.

# There are 100,000 messages on the queue combined for 100 videos. 
# Some videos have more plays than other videos. You can decide on the distribution 
# of 100,000 plays across the 100 videos, but ensure there are at least 15 videos
# with fewer than 100 plays each.

producer = Nsq::Producer.new(
  nsqd: '127.0.0.1:4250',
  topic: 'some-topic'
)

# Write a message to NSQ
producer.write('some-message')

# # Write a bunch of messages to NSQ (uses mpub)
producer.write('one', 'two', 'three', 'four', 'five')

# # Close the connection
producer.terminate