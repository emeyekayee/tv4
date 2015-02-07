class ZTimeHeaderHour < ZTimeHeader

  # (For SchedResource protocol)  This method lets us set display attributes
  # on the instance in a way specific to the resource-class and rid.
  # 
  # ==== Parameters
  # * <tt>rsrc</tt> - A SchedResource instance. 
  def self.decorate_resource( rsrc )
    rid = rsrc.sub_id

    rsrc.label = "Hour"
    rsrc.title = rid
  end

end
