#!/usr/bin/env ruby

require "celluloid/io"
require "gmail"

class SimpleIOActor
  include Celluloid::IO

  def initialize
    async.attach_to_imap

    # HACK The celluloid timers, depending on where they were started
    # (inside my task delegator and whatnot), sometimes do not fire
    # unless a timer started directly from the C::IO Actor is firing.
    every 1 do
      puts "Tick!"
    end
  end

  def delegate_new_task(block)
    block.call
  end

  def restart_imap
    puts "Restarting IMAP in a few seconds..."
    after 3 do
      puts "Re-activating... stack count: #{Kernel.caller.inspect}"
      async.attach_to_imap
    end
  end

  def attach_to_imap
    puts "Attempting to attach to gmail..."

    # all of these shenanigans are to delegate the ability to spawn
    # new tasks to Gmail (and by extension Celluloid::Net::IMAP.
    task_delegator = lambda do |&block|
      async.delegate_new_task block
    end

    begin
      # note that while we're passing self, we are *not* passing it
      # outside of the object graph owned by this actor!
      @gmail = Gmail.connect_on_celluloid!(self,
                                  task_delegator,
                                  :plain,
                                  "me@gmail.com",
                                  "monkey") do |disconnect_reason|
        puts "Disconnected: #{disconnect_reason}"
        restart_imap
      end
    rescue Gmail::Client::ConnectionError => e
      puts "Well, crap. Connection dropped because: #{e}"
      restart_imap
      return
    end
    
    begin
      @gmail.mailbox "INBOX"
      @gmail.conn.idle do |idle_msg|
        puts "Got IDLE: #{idle_msg}"
      end
    rescue ::Net::IMAP::Error => e
      puts "Some sort of command error.  Starting over. #{e}"
      @gmail.logout
      restart_imap
    end
  end
end

actor = SimpleIOActor.new
sleep
