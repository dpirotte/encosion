module Encosion
  
  class Playlist
    
    attr_reader :id, :name, :short_description, :reference_id, :videos
        
    def initialize(obj)
      @id = obj['id']
      @name = obj['name']
      @short_description = obj['shortDescription']
      @videos = obj['videos'].collect { |video| Video.new(video) }
    end
    
    def to_json
      { :id => @id,
        :name => @name,
        :short_description => @short_description,
        :reference_id => @reference_id,
        :videos => @videos }.to_json
    end
    
  end
  
end