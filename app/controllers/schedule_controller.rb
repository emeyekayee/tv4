# ============================================================================
# Hi-lock: (("# [T]TD.*"                                     (0 'accent10 t)))
# Hi-lock: (("\\(^\\|\\W\\)\\*\\(\\w.*\\w\\)\\*\\(\\W\\|$\\)" (2 'accent3 t)))
# Hi-lock: end
# ============================================================================

class ScheduleController < ApplicationController

  def index # angular.js version
    check_config
  end

  def show
    schedule
    render :action => 'schedule'
  end

  def schedule
    check_config

    param_defaults params
    get_data_for_time_span
    # respond_to do |format|
    #   format.html
    #   format.json do
        json_adjustments

        @blockss.each{|k,v| puts "\n#{k}: #{v.inspect}"}
        puts

        render json: @blockss
    #   end
    # end
   end

  def groupupdate
    SchedResource.ensure_config session
    param_defaults params
    get_data_for_time_span
  end

  # def test
  #   SchedResource.config_from_yaml session
  #   @text = ""
  #   config = SchedResource.config
  #   config.keys.each{|key| @text << "\n#{key}:\n" + config[key].inspect}
  # end


  private

  def check_config
    meth = params[:reset] ? :config_from_yaml : :ensure_config
    SchedResource.send( meth, session )
  end

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

  # TTD: Should not rely on specific type (Event).  FIX ME 
  # TTD: Also, consider a class_attribute here
 def min_time
    @min_time ||= Event.minimum(:time).to_i
  end

  # TTD: Should not rely on specific type (Event).  FIX ME 
  # TTD: Also, consider a class_attribute here
def max_time
    @max_time ||= Event.maximum(:etime).to_i
  end

  def param_defaults(p = {})
    @t1 = p[:t1] || time_default
    @t2 = p[:t2] || @t1 + SchedResource.visible_time
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

    @rsrcs = SchedResource.resource_list

    @blockss = SchedResource.get_all_blocks(@t1, @t2, @inc)
  end


end
