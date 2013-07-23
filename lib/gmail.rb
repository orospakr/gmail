require 'net/imap'
require 'net/smtp'
require 'mail'
require 'date'
require 'time'

if RUBY_VERSION < "1.8.7"
  require "smtp_tls"
end

class Object
  def to_imap_date
    Date.parse(to_s).strftime("%d-%B-%Y")
  end
end

module Gmail
  autoload :Version, "gmail/version"
  autoload :Client,  "gmail/client"
  autoload :Labels,  "gmail/labels"
  autoload :Mailbox, "gmail/mailbox"
  autoload :Message, "gmail/message"

  class << self
    # Creates new Gmail connection using given authorization options.
    #
    # ==== Examples
    #
    #   Gmail.new(:plain, "foo@gmail.com", "password")
    #   Gmail.new(:xoauth, "foo@gmail.com", 
    #     :consumer_key => "",
    #     :consumer_secret => "",
    #     :token => "",
    #     :secret => "")
    #
    # To use plain authentication method you can also call:
    #
    #   Gmail.new("foo@gmail.com", "password")
    #
    # You can also use block-style call:
    #
    #   Gmail.new("foo@gmail.com", "password") do |client|
    #     # ...
    #   end
    #

    ['', '!'].each { |kind|
      define_method("new#{kind}") do |*args, &block|                  # def new(*args, &block)
        args.unshift(:plain) unless args.first.is_a?(Symbol)          #   args.unshift(:plain) unless args.first.is_a?(Symbol)  
        client = Gmail::Client.new_client(*args)                      #   client = Gmail::Client.new(*args) 
        client.send("connect#{kind}")                                 #   client.connect 
        client.send("login#{kind}")                                   #   and client.login
                                                                      #  
        if block_given?                                               #   if block_given?
          yield client                                                #     yield client
          client.logout                                               #     client.logout
        end                                                           #   end
                                                                      #   
        client                                                        #   client
      end                                                             # end
    }

    # Create a Celluloid::IO-aware Gmail instance.  Authentication
    # method must always be specified.
    #
    # This method will block your Celluloid Task (Fiber) for a little
    # while while the connection establishes.
    # 
    # The block-style call method given for #connect and #connect! is
    # not available (and you are therefore responsible for closing the
    # connection), nor is the implicit :plain authentication method
    # (it must be specified explicitly).
    def new_on_celluloid!(actor, task_delegator, authtype, auth_params, &closed_handler)
      client = Gmail::Client.new_client(authtype, *auth_params)
      
      client.connect_on_celluloid! actor, task_delegator, &closed_handler
      client.login!

      client
    end

    alias :connect :new
    alias :connect! :new!
    alias :connect_on_celluloid! :new_on_celluloid!
  end # << self
end # Gmail
