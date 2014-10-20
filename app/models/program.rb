

class Program < ActiveRecord::Base
  self.table_name = 'program'

  has_many :genres, foreign_key: 'program'

  def category
    # genre.genre
    lgenre # table-local concatenation of genres
  end

  def category_type
    showType
  end

  def stars
    (starRating || '').split('').map{|c|  {'*' => 0.25, '+' => 0.125}[c] || 0 }.sum
  end


  # Typically...> rails runner "Program.do_after_xtvd_load"
  def self.do_after_xtvd_load
    puts "Starting  Program.do_after_xtvd_load on #{`hostname`.chomp}..."
    Rails.logger.silence{
      Program.all.includes(:genres).find_each do |p| 
        p.lgenre = p.genres.map(&:genre).join(' ')
        p.save!
      end
    }
    puts "Completed Program.do_after_xtvd_load."
  end

end
