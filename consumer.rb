require 'nsq'
require 'json'
Nsq.logger = Logger.new(STDOUT)
consumer = Nsq::Consumer.new(
  nsqlookupd: ["127.0.0.1:4361", "127.0.0.1:4363"],
  topic: 'some-topic',
  channel: 'some-channel'
)

play_counts = Hash.new(0)

100000.times do
  # Pop a message off the queue
  msg = consumer.pop
  event = JSON.parse(msg.body)
  id = event["video_id"]
  play_counts[id] += 1
  # For videos with fewer than 100 plays, the processor needs to the publish 
  # the result to the client as soon as possible because with such a small sample 
  # size, each play is of the utmost "realtime" importance.
  if play_counts[id] < 100
    puts "Video with id #{id} has #{play_counts[id]} views."
  end
  msg.finish
end



# Close the connections
consumer.terminate