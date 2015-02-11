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

    param_defaults params

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
  def min_time
    @min_time ||= Event.minimum(:time).to_i
  end

  # To Do: Should not rely on specific type (Event).  FIX ME 
  # To Do: Also, consider a class_attribute here
  def max_time
    @max_time ||= Event.maximum(:etime).to_i
  end

  def param_defaults(p = {})
    @t1 = p[:t1] || time_default
    @t2 = p[:t2] || @t1 + ScheduledResource.visible_time
    @inc= p[:inc]
  end

  def time_default
    t_now = Time.now
    t_now.change :min => (t_now.min/15) * 15
  end

  # Set up instance variables for render templates
  #  params:  @t1:      time-inverval start
  #           @t2:      time-inverval end
  #           @inc:     incremental update?  One of: nil, "lo", "hi"
  #
  #  creates: @rsrcs    ordered resource list
  #           @blockss: lists of use-blocks, keyed by resource
  def get_data_for_time_span()
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
