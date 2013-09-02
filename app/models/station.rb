

class Station < ActiveRecord::Base
  self.table_name = 'station'

  # # Just use the associations for now...
  # class_attribute :id_to_callsign, :callsign_to_id
  # self.id_to_callsign = {}
  # self.callsign_to_id = {}
  
  # pluck(:id, :callsign).each do |id, callsign|
  #   id_to_callsign[      id] = callsign
  #   callsign_to_id[callsign] = id
  # end

  class_attribute :from_id
  self.from_id = {}
  all.each{|station| from_id[station.id] = station}
  

  def callsign
    id_to_callsign[id]
  end

  def channum
    Map.station_to_channel[id]
  end


  # The rid (SchedResource resource id) is the channel number (string)
  # 
  # (For SchedResource protocol)  Returns a Station object from channum.  This
  # lets us specify the yml configuration with regular channel numbers rather
  # than funky database id integers.
  # 
  # ==== Parameters
  # * <tt>channum</tt> - A channel number (string) as we usually think of it
  #   rather than the chanid, the database id for this table.
  #
  # ==== Returns
  # * <tt>Station</tt>
  def self.find_as_schedule_resource(rid)
    from_id[ Map.channel_to_station[rid.to_i] ]
  end

  
  # (For SchedResource protocol)  This method lets us set display attributes
  # on the instance in a resource-class-specific way.
  # 
  # ==== Parameters
  # * <tt>rsrc</tt> - A SchedResource instance. 
  def decorate_resource( rsrc )
    rsrc.label = channum
    rsrc.title = name
  end


end
