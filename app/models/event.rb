# -*- coding: utf-8 -*-
# event.rb
# Copyright (c) 2008-2013 Mike Cannon (http://github.com/emeyekayee/Tv4)
# (michael.j.cannon@gmail.com)

require 's_r_hash'

class Event < ActiveRecord::Base
  self.table_name = 'schedule'

  belongs_to :program, foreign_key: :program
  belongs_to :station, foreign_key: :station

  attr_accessor     :detail_list

  # Virtual attributes for the event.
  # @@event_attrs = %w(
  #   title subtitle description starttime endtime
  #   category category_type stars airdate previouslyshown, hdtv).join(', ')

  # def channum
  #   Map.station_to_channel[station] # => 58 eg
  # end


  # (ScheduledResource protocol) Returns a hash where each key is a
  # ScheduledResource id (rid, here, a channel number) and the value is an array
  # of Events (program showings) in the interval <tt>t1...t2</tt>, ordered by
  # <tt>starttime</tt>.
  #
  # What <em>in</em> means depends on *inc*.  If inc(remental) is
  # false, client is building an interval from scratch.  If "hi", it is
  # an addition to an existing interval on the high side.  Similarly
  # for "lo".  This is to avoid re-transmitting blocks that span the
  # current time boundaries on the client.
  #
  # Here the resource is a station (indicated by its channel number) and
  # the use blocks are events.
  #
  # ==== Parameters
  # * <tt>rids</tt> - A list of scheduled resource ids (strings).
  # * <tt>t1</tt>   - Start time.
  # * <tt>t2</tt>   - End time.
  # * <tt>inc</tt>  - One of nil, "lo", "hi" (As above).
  #
  # ==== Returns
  # * <tt>Hash</tt> - Each key is a <tt>rid</tt> (here, channel number)
  # and the value is an array of Programs in the interval, ordered by
  # <tt>starttime</tt>.
  def self.get_all_blocks( rids, t1, t2, inc )
    station_ids = rids.map{ |rid| Station.find_as_schedule_resource(rid).id }

    condlo = "etime > "                      # endtime
    condlo = "time >=" if inc == 'hi'        # starttime

    condhi = "time <"                        # starttime
    condhi = "etime <=" if inc == 'lo'       # endtime

    conds = [ "station IN (?) AND (#{condlo} ?) AND (#{condhi} ?)", station_ids, t1, t2 ]

    evts = Event.includes(:program).order("station, time").where(conds)
    blks = evts.map{ |evt| evt.get_visual_info }

    blks.group_by {|blk| blk.channum }
  end

  # class @StationUseBlock in use_block.js.coffee...
  #
  #  Uses fields   : starttime, endtime, title, subtitle,  category,
  #                  category_type, previouslyshown, hdtv
  #
  #  Sets fields   : label, css_classes
  #
  # Also available : channum, description, stars, airdate
  #
  def get_visual_info
    prog = program || default_program

    SRHash[{
              channum: Map.station_to_channel[ station_before_type_cast ], # WAS: station.channum,
                title: prog.title,
             subtitle: prog.subtitle,
          description: prog.description,
            starttime: time.to_i,
              endtime: etime.to_i,
             category: prog.category,
        category_type: prog.category_type,
                stars: prog.stars,
              airdate: prog.originalAirDate,
      previouslyshown: ! self.new,
                 hdtv: hdtv,
     }]
  rescue
    puts "\n#{self.inspect}"
    raise
  end


  def default_program
    SRHash[{ title: "Program  #{self.read_attribute(:program)}  record missing.",
             subtitle: '', description: '', category: '',
             category_type: '', stars: 0, originalAirDate: '',
           }] # Happened (Fri Sep 6 '13) channel 756, 10pm
  end

end
