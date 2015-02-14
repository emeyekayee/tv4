# ============================================================================
# Hi-lock: (("# ?[T]o Do:.*"                                  (0 'accent10 t)))
# Hi-lock: (("\\(^\\|\\W\\)\\*\\(\\w.*\\w\\)\\*\\(\\W\\|$\\)" (2 'accent3 t)))
# Hi-lock: end
# ============================================================================

# Hmm... Seem to need this here to get the ZTime* classes loaded in time.
require 'scheduled_resource'

class ScheduleController < ApplicationController

  # Returns angularjs page (template) which in turn fetches data.
  # See model class ScheduledResource.
  def index 
    check_config
  end

  # Json data.
  def schedule
    check_config

    get_data_for_time_span

    render json: @blockss
   end


  private

  def check_config
    meth = params[:reset] ? :config_from_yaml : :ensure_config
    ScheduledResource.send( meth, session )
  end

  # To Do: Should not rely on specific type (Event).  FIX ME 
  # To Do: Also, consider a class_attribute here
  class_attribute :overall_time_range
  t0 = Time.now.midnight
  self.overall_time_range = (t0 - 1.week)..(t0 + 1.week)

  def min_time;  overall_time_range.min.to_i  end
  def max_time;  overall_time_range.max.to_i  end

  def time_default
    t_now = Time.now
    t_now.change :min => (t_now.min/15) * 15
  end

  def set_schedule_query_params(p = params)
    @t1 = p[:t1] || time_default
    @t2 = p[:t2] || @t1 + ScheduledResource.visible_time
    @inc= p[:inc]
  end

  # Set up instance variables for render templates
  #  params:  @t1:      time-inverval start
  #           @t2:      time-inverval end
  #           @inc:     incremental update?  One of: nil, "lo", "hi"
  #
  #  creates: @rsrcs    ordered resource list
  #           @blockss: lists of use-blocks, keyed by resource
  def get_data_for_time_span()
    set_schedule_query_params

    @t1 = Time.at(@t1.to_i)
    @t2 = Time.at(@t2.to_i)

    @rsrcs = ScheduledResource.resource_list

    @blockss = ScheduledResource.get_all_blocks(@t1, @t2, @inc)

    json_adjustments
  end

  # Always send starttime/endtime attributes as Integer values (UTC) -- they
  # are used to size and place the blocks.  TZ is configured separately in the
  # ZTime* classes (config/resource_schedule.yml).
  def json_adjustments
    @blockss.each do |rsrc, blocks|
      blocks.each do |block|
        block.starttime =  block.starttime.to_i
        block.endtime   =  block.endtime.to_i
      end
    end
    @blockss['meta'] = {
      rsrcs: @rsrcs, min_time: min_time, max_time: max_time,
      t1: @t1.to_i, t2: @t2.to_i, inc: @inc,
    }
  end

end
