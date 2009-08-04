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
  
  VERSION = '0.3.0'
  LOGGER = Logger.new(STDOUT)
  
  SERVER = 'api.brightcove.com'
  PORT = 80
  SECURE = false
  READ_PATH = '/services/library'
  WRITE_PATH = '/services/post'
  DEFAULT_OPTIONS = { :debug => false }
  
  @options = {  :read_token => nil, 
                :write_token => nil, 
                :server => SERVER, 
                :port => PORT, 
                :secure => SECURE, 
                :read_path => READ_PATH, 
                :write_path => WRITE_PATH }
  attr_accessor :options
  
  # make @options available so it can be set externally when using the library
  extend self
  
end
