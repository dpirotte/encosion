=begin
require 'lib/encosion'

reader = Encosion.new(:read_token => 'x5VgEdjdYksNTfP57sHYB331bXnAVl9xgK6hcevAQLY.')
# output = reader.find_all_videos(:page_size => 2, :video_fields => '').inspect
output = reader.find_video_by_id(:video_id => 19575518001, :video_fields => 'name,length')
# output = reader.find_all_playlists(:page_size => 2)
# output = reader.find_playlist_by_id(:playlist_id => 1699210865)
puts output.to_brightcove
=end

require 'lib/encosion'

# find single video
puts "\nFinding single video by id...\n"
video = Encosion::Video.find(28121580001, :token => 'x5VgEdjdYksNTfP57sHYB331bXnAVl9xgK6hcevAQLY.')
puts video.inspect

# find multiple videos by ID
puts "\nFinding multiple videos by ids...\n"
videos = Encosion::Video.find(28121580001, 28115365001, :token => 'x5VgEdjdYksNTfP57sHYB331bXnAVl9xgK6hcevAQLY.')
puts videos.inspect

# find multiple videos
puts "\nFinding all videos...\n"
videos = Encosion::Video.find(:all, :token => 'x5VgEdjdYksNTfP57sHYB331bXnAVl9xgK6hcevAQLY.', :page_size => 3)
puts videos.inspect

