$:.unshift File.dirname(__FILE__) # for use/testing when no gem is installed

# external
require 'net/http'
require 'net/https'
require 'uri'
require 'cgi'
require 'logger'
require 'json'
require 'yaml'

# internal
require 'encosion/base'
require 'encosion/video'
require 'encosion/playlist'
require 'encosion/exceptions'

module Encosion
  
  VERSION = '0.1.2'
  LOGGER = Logger.new(STDOUT)
  
  def self.new(*args)
    Engine.new(*args)
  end
  
  class Engine
    
    SERVER = 'api.brightcove.com'
    PORT = 80
    PATH = '/services/library'
    SECURE = false
    DEFAULT_ARGS = { :read_token => nil, :write_token => nil }
    DEFAULT_OPTIONS = { :debug => false }
    
    attr_reader :read_token, :write_token
    
    def initialize(options={})
      @options = DEFAULT_OPTIONS.merge(options)
      @options[:read_token] = @options[:token] if @options[:token]  # if there's only one token, assume it's a read
      @read_token = @options[:read_token]
      @write_token = @options[:write_token]
      if @read_token.nil? && @write_token.nil?
        raise EncosionError::TokenMissing, 'You must provide either a read or write token to use the Brightcove API'
      end
      
      #@http = Net::HTTP.new(SERVER, PORT)
      #@http.use_ssl = SECURE
      #@http.set_debug_output $stdout if @options[:debug]
    end
    
  end
  
end
