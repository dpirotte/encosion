require 'lib/encosion'

reader = Encosion.new(:read_token => 'x5VgEdjdYksNTfP57sHYB331bXnAVl9xgK6hcevAQLY.')
# output = reader.find_all_videos(:page_size => 2, :video_fields => '').inspect
output = reader.find_video_by_id(:video_id => 19575518001, :video_fields => 'name,length')
# output = reader.find_all_playlists(:page_size => 2)
# output = reader.find_playlist_by_id(:playlist_id => 1699210865)
puts output.inspect