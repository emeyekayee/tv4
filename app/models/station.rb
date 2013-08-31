

class Station < ActiveRecord::Base
  self.table_name = 'station'

  # # Just use the associations for now...
  class_attribute :id_to_callsign, :callsign_to_id
  self.id_to_callsign = {}
  self.callsign_to_id = {}
  
  pluck(:id, :callsign).each do |id, callsign|
    id_to_callsign[      id] = callsign
    callsign_to_id[callsign] = id
  end


  def callsign
    id_to_callsign[id]
  end

  def channum
    Map.station_to_channel[id]
  end

end
