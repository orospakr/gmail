#!/usr/bin/env ruby

require "celluloid/io"
require "gmail"


class SimpleIOActor
  include Celluloid::IO

  def initialize
    async.try_imap
  end

  def delegate_new_task(block)
    block.call
  end

  def try_imap
    puts "Attempting to attach to gmail..."

    # all of these shenanigans are to delegate the ability to spawn
    # new tasks to Gmail (and by extension Celluloid::Net::IMAP.
    task_delegator = lambda do |&block|
      async.delegate_new_task block
    end

    begin
      # note that while we're passing self, we are *not* passing it
      # outside of the object graph owned by this actor!
      Gmail.connect_on_celluloid!(self,
                                  task_delegator,
                                  :plain,
                                  {"username" => "alc@openera.com", "password" => "lollerskates"}) do |disconnect_reason|
        puts "Disconnected: #{disconnect_reason}"
      end
    rescue Exception => e
      puts "Well, crap. Dropped: #{e}"
    end
  end
end

actor = SimpleIOActor.new
sleep
