require 'nsq'
require 'json'
require 'pp'

class Processer
  def initialize
    @consumer = Nsq::Consumer.new(
      nsqlookupd: ["127.0.0.1:4361", "127.0.0.1:4363"],
      topic: 'some-topic',
      channel: 'some-channel'
    )
    @play_counts = Hash.new(0)
    @batch_counter = 0
    @oldest_time_in_batch = nil
  end

  def parse_msg()  
    # Pop a message off the queue
    msg = @consumer.pop
    if @batch_counter == 0
      @oldest_time_in_batch = msg.timestamp
    end
    event = JSON.parse(msg.body)
    msg.finish
    @batch_counter += 1
    id = event["video_id"]
  end

  def tally_counts(id)
    @play_counts[id] += 1
  end

  # if I hit a small count video - publish the counts
  # if i'm reading and i haven't hit a small count video... 
  # keep reading until i hit 100 events or until the timestamp
  # on the first message in the batch shows i've had it longer than a minute
  def should_publish(id)
    (@play_counts[id] < 100) || (@batch_counter > 99) || (Time.now - @oldest_time_in_batch > 60)
  end

  def publish()
    pp @play_counts
    @batch_counter = 0

  end

  def process_next_msg()
    id = parse_msg()
    tally_counts(id)
    if should_publish(id)
      publish()
    end
  end

  def stop()
    # Close the connections
    @consumer.terminate
  end

end


Nsq.logger = Logger.new(STDOUT)


p = Processer.new()
while true
  p.process_next_msg
end
p.stop
