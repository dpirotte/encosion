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
  
  VERSION = '0.0.1'
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
      
      @http = Net::HTTP.new(SERVER, PORT)
      @http.use_ssl = SECURE
      @http.set_debug_output $stdout if @options[:debug]
    end
    
    # All API calls to Brightcove are actually done here. Simply call the API method you want and make sure
    # you pass the required options:
    #
    #   uploader = Encosion.new(:token => abc123)
    #   video = uploader.find_video_by_id(:video_id => 123456)

    def method_missing(command, args={})
      args.merge!({:command => command}) 
      # args = args.collect { |key,value| "#{key.to_s}=#{value.to_s}" }.join('&')
      if command.match(/^find_/)
        output = do_http_get(args)    # read API
      else
        output = do_http_post(args)   # write API
      end
      return parse(output)
    end
    
    private
      
      # Performs the HTTP call
      def do_http_get(args)
        query_string = queryize_args(args, :read)
        response, data = @http.get("#{PATH}?#{query_string}")
        results = data.strip == 'null' ? nil : JSON.parse(data)   # if the call returns 'null' then there were no valid results
        error_check(response,results)
        return results
      end
      
      # Parses the results and returns either a Video or array of Videos depending on the method call to Brightcove
      def parse(results)
        unless results.nil?
          if results.has_key? 'items'
            if results['items'].first.has_key? 'videoIds'
              return results['items'].collect { |item| Playlist.new(item) }   # collection of playlists
            else
              return results['items'].collect { |item| Video.parse(item) }    # collection of videos
            end
          else
            if results.has_key? 'videoIds'
              return Playlist.new(results)    # single playlist
            else
              return Video.parse(results)       # single video
            end
          end
        else
          return results
        end
      end
      
      # Turns a hash into a query string and appends the token
      def queryize_args(args, type)
        case type
        when :read
          raise EncosionError::TokenMissing, 'No read token found' if @read_token.nil?
          args.merge!({ :token => @read_token })
        when :write
          raise EncosionError::TokenMissing, 'No write token found' if @write_token.nil?
          args.merge!({ :token => @write_token })
        end
        return args.collect { |key,value| "#{key.to_s}=#{value.to_s}" }.join('&')
      end
      
      
      # Checks the HTTP resonse and handles any errors
      def error_check(response,results)
        if response.code == '200'
          return true if results.nil?
          if results.has_key? 'error'
            message = "Brightcove responded with an error: #{results['error']} (code #{results['code']})"
            results['errors'].each do |error| 
              message += "\n#{error.values.first} (code #{error.values.last})"
            end if results.has_key? 'errors'
            raise EncosionError::BrightcoveException, message
          end
        else
          raise EncosionError::BrightcoveException, response.body + " (status code: #{response.code})"
        end
      end
    
  end
  
end
