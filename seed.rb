require 'nsq'
require 'json'

Nsq.logger = Logger.new(STDOUT)
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

100.times do
  producer.write({:video_id => rand(100)}.to_json)
end


# # Close the connection
producer.terminate