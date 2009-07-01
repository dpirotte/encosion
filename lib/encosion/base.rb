require 'net/http'
require 'rubygems'
require 'httpclient'
require 'json'

module Encosion
  
  # Generic Encosion error class
  class EncosionError < StandardError
  end
  
  # Raised when there is no token (required to use the Brightcove API)
  class MissingToken < EncosionError
  end
  
  # Raised when Brightcove doesn't like the call that was made for whatever reason
  class BrightcoveException < EncosionError
  end
  
  # The base for all Encosion objects
  class Base
    
    class << self
      
      # Does a GET to search photos and other good stuff
      def find(*args)
        options = extract_options(args)
        case args.first
        when :all   then find_all(options)
        else        find_from_ids(args,options)
        end
      end
      
      # TODO: Add convience methods for Base.first, Base.all, etc.

      private
      
        def extract_options(opts)
          opts.last.is_a?(::Hash) ? opts.pop : {}
        end

        def find_all(*args)
          # Class should override this with the method to find something by its ID
        end

        def find_from_ids(args,options)
          # Class should override this with the method to find something by its ID
        end

        def method_missing(command, *args)
          case command.to_s
          when /^find_(all_by|by)_([_a-zA-Z]\w*)/
            finder = $1
            name = $2
          end
          @attribute_name = name
        end
        
        # Performs the HTTP call
        def get(server,port,path,secure,command,options)
          http = Net::HTTP.new(server, port)
          # http.use_ssl = secure
          query_string = options.collect { |key,value| "#{key.to_s}=#{value.to_s}" }.join('&')
          response, data = http.get("#{path}?command=#{command}&#{query_string}")
          results = data.strip == 'null' ? nil : JSON.parse(data)   # if the call returns 'null' then there were no valid results
          error_check(response,results)
          return parse_response(results)
        end

        # Parses the results and returns either a single instance or array of instances depending on what is queried
        def parse_response(results)
          unless results.nil?
            if results.has_key? 'items'
              return results['items'].collect { |item| self.parse(item) }
            else
              return self.parse(results)       # single instance
            end
          else
            return results
          end
        end

        # Turns a hash into a query string and appends the token
        def queryize_args(args, type)
          case type
          when :read
            raise MissingToken, 'No read token found' if @read_token.nil?
            args.merge!({ :token => @read_token })
          when :write
            raise MissingToken, 'No write token found' if @write_token.nil?
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
              raise BrightcoveException, message
            end
          else
            raise BrightcoveException, response.body + " (status code: #{response.code})"
          end
        end
      
    end
    
    # Does a POST to save a video to the server
    def save()
    end
    
  end
  
end
