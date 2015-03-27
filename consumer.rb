require 'nsq'
Nsq.logger = Logger.new(STDOUT)
consumer = Nsq::Consumer.new(
  nsqlookupd: ["127.0.0.1:4361", "127.0.0.1:4363"],
  topic: 'some-topic',
  channel: 'some-channel'
)

puts 'hello world'
puts consumer.size

# Pop a message off the queue
msg = consumer.pop
puts msg.body
msg.finish




# Close the connections
consumer.terminate