module Encosion
  
  class Video
    
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
    
    
    # Creates a new Video object from a Ruby hash (used to create a video from a parsed API call)
    def self.parse(obj)
      args = {:id => obj['id'].to_i
              :name => obj['name']
              :short_description => obj['shortDescription']
              :long_description => obj['longDescription']
              :creation_date => Time.at(obj['creationDate'].to_i/1000)
              :published_date => Time.at(obj['publishedDate'].to_i/1000)
              :last_modified_date => Time.at(obj['lastModifiedDate'].to_i/1000)
              :link_url => obj['linkURL']
              :link_text => obj['linkText']
              :tags => obj['tags']
              :video_still_url => obj['videoStillURL']
              :thumbnail_url => obj['thumbnailURL']
              :reference_id => obj['referenceID']
              :length => obj['length'].to_i
              :economics => ENUMS[:economics].find { |key,value| value == obj['economics'] }.first
              :plays_total => obj['playsTotal'].to_i
              :plays_trailing_week => obj['playsTrailingWeek'].to_i }
      return self.new(args)
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
      { 'id' => @id,
        'name' => @name,
        'shortDescription' => @short_description,
        'longDescription' => @long_description,
        'creationDate' => @creation_date,
        'publishedDate' => @published_date,
        'lastModifiedDate' => @last_modified_date,
        'linkURL' => @link_url,
        'linkText' => @link_text,
        'tags' => @tags,
        'videoStillURL' => @video_still_url,
        'thumbnailURL' => @thumbnail_url,
        'referenceId' => @reference_id,
        'length' => @length,
        'economics' => ENUM[:economics][@economics],
        'playsTotal' => @plays_total,
        'playsTrailingWeek' => @plays_trailing_week }
    end
    
    def encosion=(sym)
      if ENUMS[:economics].has_key?(sym)
        raise EncosionError::InvalidEconomicsValue, "A video's economics value must be one of #{ENUMS[:economics].collect { |key,value| e.key }.join(',')}"
      else
        @economics = sym
      end
    end
    
  end
  
end