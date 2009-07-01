module Encosion
  
  class Video < Base
    
    SERVER = 'api.brightcove.com'
    PORT = 80
    SECURE = false
    READ_PATH = '/services/library'
    WRITE_PATH = '/services/post'
    ENUMS = { :economics => { :free => 'FREE', :ad_supported => 'AD_SUPPORTED'}}
    
    attr_accessor(:name, 
                  :short_description, 
                  :long_description,
                  :link_url, 
                  :link_text, 
                  :tags, 
                  :reference_id, 
                  :economics)
      attr_reader(:id, 
                  :account_id, 
                  :flv_url,
                  :creation_date, 
                  :published_date, 
                  :last_modified_date, 
                  :video_still_url, 
                  :thumbnail_url, 
                  :length, 
                  :plays_total, 
                  :plays_trailing_week)
    
    
    class << self
      
      # Find a video from a single or array of ids
      def find_from_ids(ids, options)
        expects_array = ids.first.kind_of?(Array)
        return ids.first if expects_array && ids.first.empty?

        ids = ids.flatten.compact.uniq

        case ids.size
          when 0
            raise VideoNotFound, "Couldn't find video without an ID"
          when 1
            result = find_one(ids.first, options)
            expects_array ? [ result ] : result
          else
            find_some(ids, options)
        end
      end
      
      
      # Find some videos by ids
      def find_one(id, options)
        options.merge!({:video_id => id})
        get(SERVER,PORT,READ_PATH,SECURE,'find_video_by_id',options)
      end
      
      
      # Find mutliple videos by id
      def find_some(ids, options)
        options.merge!({:video_ids => ids.join(',')})
        get(SERVER,PORT,READ_PATH,SECURE,'find_videos_by_ids',options)
      end
      
      
      # Find all videos
      def find_all(options)
        get(SERVER,PORT,READ_PATH,SECURE,'find_all_videos',options)
      end

      
      # Creates a new Video object from a Ruby hash (used to create a video from a parsed API call)
      def parse(obj)
        args = {:id => obj['id'].to_i,
                :name => obj['name'],
                :short_description => obj['shortDescription'],
                :long_description => obj['longDescription'],
                :creation_date => Time.at(obj['creationDate'].to_i/1000),
                :published_date => Time.at(obj['publishedDate'].to_i/1000),
                :last_modified_date => Time.at(obj['lastModifiedDate'].to_i/1000),
                :link_url => obj['linkURL'],
                :link_text => obj['linkText'],
                :tags => obj['tags'],
                :video_still_url => obj['videoStillURL'],
                :thumbnail_url => obj['thumbnailURL'],
                :reference_id => obj['referenceID'],
                :length => obj['length'].to_i,
                :economics => obj['economics'] ? ENUMS[:economics].find { |key,value| value == obj['economics'] }.first : nil,
                :plays_total => obj['playsTotal'].to_i,
                :plays_trailing_week => obj['playsTrailingWeek'].to_i }
        return self.new(args)
      end
      
    end
        
    
    def initialize(args)
      @id = args[:id]
      @name = args[:name]
      @short_description = args[:short_description]
      @long_description = args[:long_description]
      @creation_date = args[:creation_date]
      @published_date = args[:published_date]
      @last_modified_date = args[:last_modified_date]
      @link_url = args[:link_url]
      @link_text = args[:link_text]
      @tags = args[:tags]
      @video_still_url = args[:video_still_url]
      @thumbnail_url = args[:thumbnail_url]
      @reference_id = args[:reference_id]
      @length = args[:length]
      @economics = args[:economics]
      @plays_total = args[:plays_total]
      @plays_trailing_week = args[:plays_trailing_week]
    end
    
    # Output the video as JSON
    def to_json
      { :id => @id,
        :name => @name,
        :short_description => @short_description,
        :long_description => @long_description,
        :creation_date => @creation_date,
        :published_date => @published_date,
        :last_modified_date => @last_modified_date,
        :link_url => @link_url,
        :link_text => @link_text,
        :tags => @tags,
        :video_still_url => @video_still_url,
        :thumbnail_url => @thumbnail_url,
        :reference_id => @reference_id,
        :length => @length,
        :economics => @economics,
        :plays_total => @plays_total,
        :plays_trailing_week => @plays_trailing_week }.to_json
    end
    
    # Outputs the video object into Brightcove's expected format
    def to_brightcove
      { 'name' => @name,
        'shortDescription' => @short_description,
        'longDescription' => @long_description,
        'linkURL' => @link_url,
        'linkText' => @link_text,
        'tags' => @tags,
        'referenceId' => @reference_id,
        'economics' => ENUMS[:economics][@economics] }.to_json
    end
    
    def encosion=(sym)
      if ENUMS[:economics].has_key?(sym)
        raise EncosionError::InvalidEconomicsValue, "A video's economics value must be one of #{ENUMS[:economics].collect { |key,value| e.key }.join(',')}"
      else
        @economics = sym
      end
    end
    
  end
  
  # Raised when asked to find a video but not given enough info to do so
  class VideoNotFound < Encosion::EncosionError
  end
  
end