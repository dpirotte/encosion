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

puts "\nFinding single video by id...\n"
video = Encosion::Video.find(28121580001, :token => 'x5VgEdjdYksNTfP57sHYB331bXnAVl9xgK6hcevAQLY.')
puts video.inspect

puts "\nFinding multiple videos by ids...\n"
videos = Encosion::Video.find(28121580001, 28115365001, :token => 'x5VgEdjdYksNTfP57sHYB331bXnAVl9xgK6hcevAQLY.')
puts videos.inspect

puts "\nFinding all videos...\n"
videos = Encosion::Video.find(:all, :token => 'x5VgEdjdYksNTfP57sHYB331bXnAVl9xgK6hcevAQLY.', :page_size => 3)
puts videos.inspect

puts "\nFinding all videos with .all alias...\n"
videos = Encosion::Video.all(:token => 'x5VgEdjdYksNTfP57sHYB331bXnAVl9xgK6hcevAQLY.', :page_size => 3)
puts videos.inspect

puts "\nFinding a video by reference_id...\n"
videos = Encosion::Video.find_by_reference_id('activecasting_1',:token => 'x5VgEdjdYksNTfP57sHYB331bXnAVl9xgK6hcevAQLY.', :page_size => 3)
puts videos.inspect

puts "\nFinding videos by reference ids...\n"
videos = Encosion::Video.find_by_reference_id('activecasting_1','activecasting_2',:token => 'x5VgEdjdYksNTfP57sHYB331bXnAVl9xgK6hcevAQLY.', :page_size => 3)
puts videos.inspect

puts "\nFinding videos by text...\n"
videos = Encosion::Video.find_by_text('upload',:token => 'x5VgEdjdYksNTfP57sHYB331bXnAVl9xgK6hcevAQLY.', :page_size => 3)
puts videos.inspect

puts "\nFinding videos by one tag...\n"
videos = Encosion::Video.find_by_tags('activecasting',:token => 'x5VgEdjdYksNTfP57sHYB331bXnAVl9xgK6hcevAQLY.', :page_size => 3)
puts videos.inspect

puts "\nFinding videos by multiple tags...\n"
videos = Encosion::Video.find_by_tags('cycling', 'running', :token => 'x5VgEdjdYksNTfP57sHYB331bXnAVl9xgK6hcevAQLY.', :page_size => 3)
puts videos.inspect

puts "\nFinding related videos by video_id...\n"
videos = Encosion::Video.find_related(:token => 'x5VgEdjdYksNTfP57sHYB331bXnAVl9xgK6hcevAQLY.', :page_size => 3, :video_id => 28115365001)
puts videos.inspect

puts "\nFinding related videos by reference_id...\n"
videos = Encosion::Video.find_related(:token => 'x5VgEdjdYksNTfP57sHYB331bXnAVl9xgK6hcevAQLY.', :page_size => 3, :reference_id => 'activecasting_1')
puts videos.inspect


begin
  puts "\nCreate a video (should throw error because of no file)...\n"
  video = Encosion::Video.new(:name => 'Upload API test', :reference_id => 'activecasting_7', :short_description => 'Test upload through Media API', :tags => ['activecasting'])
  puts video.save(:token => '_eFCYhrtNm-q7u_e6ZbjPKdTl-A6xw6sC2fo1iO8Y1V_d3dMnXnVOA..')
rescue => e
  puts e.inspect
end

# make sure to increment the reference_id here or this will always throw an error
puts "\nCreate a video...\n"
video = Encosion::Video.new(:file => File.new('test/movie.mov'), :name => 'Upload API test', :reference_id => 'activecasting_14', :short_description => 'Test upload through Media API', :tags => ['activecasting'])
puts video.save(:token => '_eFCYhrtNm-q7u_e6ZbjPKdTl-A6xw6sC2fo1iO8Y1V_d3dMnXnVOA..')

