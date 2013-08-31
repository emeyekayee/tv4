

class Event < ActiveRecord::Base
  belongs_to :program, foreign_key: :program
  belongs_to :station, foreign_key: :station

  # def channum
  #   Map.station_to_channel[station] # => 58 eg
  # end

  # def callsign
  #   Station.id_to_callsign[station] # => "CNBC" eg
  # end

end
