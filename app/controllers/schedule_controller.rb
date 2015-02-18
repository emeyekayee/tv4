
# Needed this here to get the ZTime* classes in time for session.
require 'scheduled_resource'

class ScheduleController < ApplicationController
  include ScheduledResource::Helper

  before_action :ensure_schedule_config


  # Returns angularjs page (template) which in turn fetches data.
  def index
  end


  # Json data.
  def schedule
    get_data_for_time_span

    render json: @blockss
  end

end
