class TimelabelDayNight < Timelabel
  self.label   = 'Day'
  self.format  = '<span class="ampmLeft" > %P </span>' +
                 '<span class="ampmCenter">&nbsp %a %B %e &nbsp&nbsp </span>' +
                 '<span class="ampmRight"> %P </span>'

  def initialize( t )
    @starttime, @endtime = [t, self.class.next_12_oclock(t)].map{|t| t.to_i.to_s}
  end

  def self.get_timeblocks(id, t1, t2, inc)
    # require 'pry'; binding.pry
    t1 = floor(t1)

    t1 = next_12_oclock(t1) if inc == 'hi'
    t2 = floor(t2) - 1.hour if inc == 'lo'

    blks = []
    t = t1
    while t < t2 do
      blks << new(t)
      t = Time.at( blks[-1].endtime.to_i )
    end
    blks
  end

  def self.next_12_oclock(t)
    t1 = t.change(min: 0) + 1.hour
    t1 += 1.hour until t1.hour % 12 == 0
    t1
  end

  def self.floor(t)
    t1 = t.change min: 0
    t1 -= 1.hour until t1.hour % 12 == 0
    t1
  end
end

