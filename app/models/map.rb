

class Map < ActiveRecord::Base
  self.table_name = 'map'

  class_attribute :station_to_channel, :channel_to_station
  self.station_to_channel = {}
  self.channel_to_station = {}

  pluck(:station, :channel).each do |station, channel|
    station_to_channel[station] = channel
    channel_to_station[channel] = station
  end



end
