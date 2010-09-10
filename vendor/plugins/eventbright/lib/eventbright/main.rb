require 'httparty'
require 'tzinfo'
module EventBright
  EVENTBRITE_TIME_STRING = '%Y-%m-%d %H:%M:%S'
  
  def self.setup_from_initializer()
    self.setup(EventBright::KEYS[:api], EventBright::DEBUG)
    @eventbrite_user = EventBright::User.new(EventBright::KEYS[:user])
  end
  
  def self.setup(app_key = "YmRmMmMxMjYzNDYy", debug = false)
    @app_key = app_key
    @debug = debug
  end
  
  def self.debug!
    @debug = true
  end
  
  def self.call(function, opts = {})
    @app_key ||= "YmRmMmMxMjYzNDYy"
    opts[:app_key] = @app_key
    if opts[:user].is_a? EventBright::User 
      # Allow passing User object instead of user auth info.
      u = opts.delete :user
      opts.merge!(u.auth)
    end 
    debug "\tSending  /#{function}\t\t(#{opts.inspect})"
    response = API.do_post("/#{function}", :body => opts)
    debug "\tResponse /#{function}\t\t#{response.inspect}"

    response
  end
  
  
  def self.debug(msg)
    puts msg if debug?
  end
  
  def self.debug?
    @debug.nil? ? false : @debug
  end
  
  def self.formatted_time(date)
    case date
    when Time
      date.strftime(EVENTBRITE_TIME_STRING)
    when String
      Time.parse(String).strftime(EVENTBRITE_TIME_STRING)
    end
  end
  
  class API
    include HTTParty
    base_uri "https://www.eventbrite.com/json/"
    ERROR_404 = "404 Not Found"
    NUM_RETRIES_ON_404 = 3

    def self.do_post(function, opts = {})

      retries = NUM_RETRIES_ON_404
      begin
        response = post(function, opts)

        if response["error"]
          raise Exception.new(response["error"]["error_message"])
        elsif response.select{|k,v| v =~ /<title>404 Not Found<\/title>/}.present?
          raise Exception.new(ERROR_404)
        end

      rescue Exception => e
        Rails.logger.info "\tEventBright API ERROR \t#{e.message}"
        if e.message == ERROR_404 && retries > 0
          retries -= 1
          retry unless retries <=0
        end
        response = nil
      end
      
      response
    end
  end
end
